import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/priority_provider.dart';
import '../../domain/usecases/auto_balance_usecase.dart';
import '../../domain/usecases/validate_weights_usecase.dart';
import '../../../criteria_selection/domain/entities/criterion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/forms/weight_slider.dart';
import '../../../../core/widgets/forms/total_weight_indicator.dart';

/// Priority input screen for setting criterion weights
class PriorityInputScreen extends StatefulWidget {
  final List<Criterion> criteria;

  const PriorityInputScreen({required this.criteria, super.key});

  @override
  State<PriorityInputScreen> createState() => _PriorityInputScreenState();
}

class _PriorityInputScreenState extends State<PriorityInputScreen> {
  late PriorityProvider _priorityProvider;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _priorityProvider = PriorityProvider(
      autoBalanceUseCase: AutoBalanceUseCase(),
      validateWeightsUseCase: ValidateWeightsUseCase(),
    );
    _priorityProvider.initialize(widget.criteria.map((c) => c.id).toList());
  }

  @override
  void dispose() {
    _priorityProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PriorityProvider>.value(
      value: _priorityProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Set Priorities'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<PriorityProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.info20,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                      border: Border.all(color: AppColors.info80),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'Set the importance for each criterion. The total must equal 100%.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Weight Sliders
                  Text(
                    'Criterion Weights',
                    style: AppTypography.sectionInnerTitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ..._buildWeightSliders(context, provider),
                  const SizedBox(height: AppSpacing.lg),

                  // Total Weight Indicator
                  TotalWeightIndicator(totalWeight: provider.totalWeight),
                  const SizedBox(height: AppSpacing.lg),

                  // Auto-Balance Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.autoBalance();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Weights auto-balanced to 100%'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.balance),
                      label: const Text('Auto-Balance'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Calculate Result Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCalculating || !provider.isWeightsValid()
                          ? null
                          : () => _handleCalculateResult(context, provider),
                      child: _isCalculating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Calculate Result'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildWeightSliders(
    BuildContext context,
    PriorityProvider provider,
  ) {
    return widget.criteria.map((criterion) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: WeightSlider(
          label: criterion.name,
          value: provider.getWeight(criterion.id),
          onChanged: (value) {
            provider.setWeight(criterion.id, value);
          },
        ),
      );
    }).toList();
  }

  Future<void> _handleCalculateResult(
    BuildContext context,
    PriorityProvider provider,
  ) async {
    // Validate weights
    final validationResult = provider.validateWeights();
    if (!validationResult.isValid) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationResult.errorMessage ?? 'Invalid weights'),
          backgroundColor: AppColors.error80,
        ),
      );
      return;
    }

    setState(() => _isCalculating = true);

    try {
      // Simulate calculation delay
      await Future.delayed(const Duration(seconds: 1));

      if (!context.mounted) return;

      // Navigate to result screen
      Navigator.of(context).pushNamed(
        '/result',
        arguments: {'criteria': widget.criteria, 'weights': provider.weights},
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calculation failed: $e'),
          backgroundColor: AppColors.error80,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isCalculating = false);
      }
    }
  }
}
