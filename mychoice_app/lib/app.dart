import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/supabase_auth_repository.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/category_selection/data/datasources/category_datasource.dart';
import 'features/category_selection/data/repositories/category_repository_impl.dart';
import 'features/category_selection/presentation/providers/category_provider.dart';
import 'features/comparison/presentation/providers/comparison_provider.dart';
import 'features/decision_engine/data/repositories/decision_engine_repository_impl.dart';
import 'features/decision_engine/domain/usecases/calculate_saw_usecase.dart';
import 'features/decision_engine/presentation/providers/result_provider.dart';
import 'features/priority_setting/domain/usecases/auto_balance_usecase.dart';
import 'features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart';
import 'features/what_if_simulation/presentation/providers/simulation_provider.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// MyChoice App
/// Main application widget with routing and theme configuration
class MyChoiceApp extends StatefulWidget {
  const MyChoiceApp({super.key, this.initialPasswordRecovery = false});

  final bool initialPasswordRecovery;

  @override
  State<MyChoiceApp> createState() => _MyChoiceAppState();
}

class _MyChoiceAppState extends State<MyChoiceApp> {
  late final StreamSubscription<supabase.AuthState> _authSubscription;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange
        .listen(
          (authState) {
            if (authState.event == supabase.AuthChangeEvent.passwordRecovery) {
              if (_authProvider?.isPasswordResetCodeVerified == true) {
                return;
              }
              appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/reset-password',
                (route) => false,
              );
            } else if (authState.event == supabase.AuthChangeEvent.signedIn) {
              final auth = _authProvider;
              if (auth == null) return;
              if (auth.isGoogleSignInPending) {
                unawaited(_completeGoogleSignIn(auth));
              }
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            _authProvider?.failGoogleSignIn(error);
          },
        );
  }

  Future<void> _completeGoogleSignIn(AuthProvider auth) async {
    await auth.completeGoogleSignIn();
    if (!auth.isAuthenticated) {
      if (auth.error != null) {
        appScaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(auth.error!)),
        );
      }
      return;
    }

    final destination = auth.user!.isAdmin ? '/admin' : '/dashboard';
    appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
      destination,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        Provider<AuthRepository>(
          create: (_) =>
              SupabaseAuthRepository(supabase.Supabase.instance.client),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) =>
              AuthProvider(repository: context.read<AuthRepository>()),
        ),
        // Category Provider
        Provider<MockCategoryDataSource>(
          create: (_) => MockCategoryDataSource(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(
            repository: CategoryRepositoryImpl(
              dataSource: context.read<MockCategoryDataSource>(),
            ),
          ),
        ),
        // Decision Engine Provider
        Provider<DecisionEngineRepositoryImpl>(
          create: (_) => DecisionEngineRepositoryImpl(),
        ),
        ChangeNotifierProvider<ResultProvider>(
          create: (context) => ResultProvider(
            calculateSAWUseCase: CalculateSAWUseCase(
              repository: context.read<DecisionEngineRepositoryImpl>(),
            ),
          ),
        ),
        // Phase 7: What-If Simulation Provider
        ChangeNotifierProvider<SimulationProvider>(
          create: (context) => SimulationProvider(
            recalculateUseCase: RecalculateSimulationUseCase(
              repository: context.read<DecisionEngineRepositoryImpl>(),
            ),
            autoBalanceUseCase: AutoBalanceUseCase(),
          ),
        ),
        // Phase 7: Comparison Provider
        ChangeNotifierProvider<ComparisonProvider>(
          create: (_) => ComparisonProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MyChoice',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: appScaffoldMessengerKey,
        navigatorKey: appNavigatorKey,
        builder: (context, child) {
          _authProvider = context.read<AuthProvider>();
          return child!;
        },
        theme: AppTheme.lightTheme,
        initialRoute: widget.initialPasswordRecovery ? '/reset-password' : '/',
        routes: buildAppRoutes(),
      ),
    );
  }
}
