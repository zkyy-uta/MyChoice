# MyChoice Flutter Frontend - Technical Design Document

## 1. Overview

This document provides the comprehensive technical architecture and design for the MyChoice Flutter mobile application. It translates the 17 functional requirement groups into concrete architectural decisions, component hierarchies, data models, and implementation guidance.

### Document Scope

- **Target Platform**: Android (API 21+) and iOS (11+)
- **Framework**: Flutter/Dart with Provider state management
- **Scope**: Mobile frontend only (backend integrations are API contracts, not implementations)
- **Architecture Pattern**: Clean Architecture with Feature-Oriented Directory Structure
- **State Management**: Provider with ChangeNotifier (selected via pubspec.yaml analysis)

### Key Design Principles

1. **Separation of Concerns**: Presentation layer isolated from domain logic and data sources
2. **Determinism**: Decision calculations must be reproducible and testable
3. **Offline-First**: Cache critical data, gracefully degrade without network
4. **Type Safety**: Leverage Dart's type system; avoid dynamic types
5. **Accessibility**: Material Design 3 guidelines for inclusive UX
6. **Testability**: Domain models and calculation engines unit tested thoroughly

---

## 2. App Architecture & Directory Structure

### 2.1 Feature-Oriented Architecture

The app follows a feature-oriented (modular) directory structure where each business domain is self-contained:

```
mychoice_app/
├── lib/
│   ├── main.dart                       # App entry point, orientation & system UI setup
│   ├── app.dart                        # MaterialApp configuration with routing
│   │
│   ├── core/                           # Shared infrastructure (theme, widgets, constants)
│   │   ├── theme/
│   │   │   ├── app_theme.dart          # Light/dark theme definitions (Material Design 3)
│   │   │   ├── app_colors.dart         # Color palette constants
│   │   │   ├── app_typography.dart     # Typography scale (Display, H1-H3, Body, Caption, Button)
│   │   │   └── app_spacing.dart        # Spacing tokens (8px grid, padding/margin presets)
│   │   │
│   │   ├── widgets/                    # Reusable UI components
│   │   │   ├── buttons/
│   │   │   │   ├── primary_button.dart      # Elevated primary action button
│   │   │   │   ├── secondary_button.dart    # Outlined secondary button
│   │   │   │   └── text_button.dart         # Text-only tertiary button
│   │   │   ├── cards/
│   │   │   │   ├── base_card.dart           # Reusable card wrapper with shadow/border
│   │   │   │   ├── decision_card.dart       # Decision display card (title, progress, stats)
│   │   │   │   └── criterion_card.dart      # Criterion selection card (name, type indicator)
│   │   │   ├── forms/
│   │   │   │   ├── text_field.dart          # Custom TextField with validation styling
│   │   │   │   ├── slider_input.dart        # Weight input slider (0-100%)
│   │   │   │   ├── checkbox_group.dart      # Multi-select criteria/alternatives list
│   │   │   │   └── radio_group.dart         # Single-select category/tier options
│   │   │   ├── loaders/
│   │   │   │   ├── loading_spinner.dart     # Centered loading indicator
│   │   │   │   └── skeleton_loader.dart     # Placeholder shimmer for list items
│   │   │   ├── error_states/
│   │   │   │   ├── error_message.dart       # Inline error display with retry action
│   │   │   │   └── empty_state.dart         # Empty list with icon + CTA
│   │   │   ├── navigation/
│   │   │   │   ├── bottom_nav_bar.dart      # 5-item persistent bottom navigation
│   │   │   │   ├── app_bar.dart             # Custom AppBar with back button + title
│   │   │   │   └── app_drawer.dart          # Side drawer for navigation (if needed)
│   │   │   └── dialogs/
│   │   │       ├── confirmation_dialog.dart # Yes/No confirmation dialog
│   │   │       ├── upgrade_prompt.dart      # Plan tier upgrade dialog
│   │   │       └── error_dialog.dart        # Error message dialog with details
│   │   │
│   │   ├── constants/
│   │   │   ├── app_constants.dart           # Global constants (timeouts, limits, URLs)
│   │   │   ├── validation_rules.dart        # Email regex, password complexity rules
│   │   │   └── error_messages.dart          # Localized error strings
│   │   │
│   │   ├── extensions/
│   │   │   ├── string_extensions.dart       # isValidEmail(), isStrongPassword(), truncate()
│   │   │   ├── list_extensions.dart         # Extensions on List (mapIndexed, groupBy, etc.)
│   │   │   ├── double_extensions.dart       # Extensions on double (round to decimals, percentage)
│   │   │   └── context_extensions.dart      # MediaQuery shortcuts, theme access
│   │   │
│   │   ├── utils/
│   │   │   ├── logger.dart                  # Debug logging utility
│   │   │   ├── date_utils.dart              # Date formatting, time calculation
│   │   │   └── dio_client.dart              # HTTP client wrapper (future: API calls)
│   │   │
│   │   └── errors/
│   │       ├── app_exception.dart           # Base exception class hierarchy
│   │       ├── validation_error.dart        # ValidationError extends AppException
│   │       ├── auth_error.dart              # AuthenticationError, AuthorizationError
│   │       ├── calculation_error.dart       # CalculationError, DataMissingError
│   │       ├── network_error.dart           # NetworkError, TimeoutError
│   │       └── error_handler.dart           # Maps exceptions to user-facing strings
│   │
│   ├── features/                        # Feature modules (one per requirement group)
│   │   ├── auth/                        # Requirement Group 1: Authentication & Account Management
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── splash_screen.dart
│   │   │   │   │   ├── onboarding_screen.dart
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   └── register_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   ├── auth_provider.dart      # Manages login state, session, tokens
│   │   │   │   │   └── user_provider.dart      # Manages user profile (name, email, tier)
│   │   │   │   └── widgets/
│   │   │   │       ├── email_field.dart        # Validated email input with RFC 5322 check
│   │   │   │       ├── password_field.dart     # Password with visibility toggle
│   │   │   │       └── mfa_code_input.dart     # MFA verification code input
│   │   │   │
│   │   │   ├── domain/                 # Domain (business logic)
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user.dart              # User(id, email, name, dob, tier, createdAt)
│   │   │   │   │   ├── session.dart           # Session(token, expiresAt, refreshToken)
│   │   │   │   │   └── auth_state.dart        # AuthState enum: unauthenticated, authenticated, loading, error
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository.dart   # Interface: login(), register(), logout(), refreshToken()
│   │   │   │
│   │   │   └── data/                   # Data (persistence & API)
│   │   │       ├── datasources/
│   │   │       │   ├── local_auth_datasource.dart     # Reads/writes tokens from secure storage
│   │   │       │   └── remote_auth_datasource.dart    # API calls (placeholder for now)
│   │   │       └── repositories/
│   │   │           └── auth_repository_impl.dart  # Implements interface, coordinates local + remote
│   │   │
│   │   ├── dashboard/                  # Requirement Group 2: Dashboard & Navigation
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── dashboard_screen.dart
│   │   │   │   └── providers/
│   │   │   │       └── dashboard_provider.dart    # Manages dashboard state (decisions list, stats)
│   │   │   ├── domain/
│   │   │   │   └── entities/
│   │   │   │       └── dashboard_stats.dart      # DashboardStats(totalDecisions, completedCount, etc.)
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── dashboard_datasource.dart # Future: Fetch user statistics from API
│   │   │
│   │   ├── category_selection/         # Requirement Group 3: Category & Subcategory Selection
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── category_selection_screen.dart
│   │   │   │   └── providers/
│   │   │   │       └── category_provider.dart    # Manages selected category, subcategories list
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── category.dart            # Category(id, name, icon)
│   │   │   │   │   └── subcategory.dart         # Subcategory(id, name, categoryId)
│   │   │   │   └── repositories/
│   │   │   │       └── category_repository.dart # Interface: getCategories(), getSubcategories(categoryId)
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── category_datasource.dart # Load categories from assets or cache
│   │   │
│   │   ├── alternative_management/    # Requirement Group 4: Alternative Management
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── alternative_management_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── alternative_provider.dart    # Manages selected alternatives list, mode (catalog/custom)
│   │   │   │   └── widgets/
│   │   │   │       ├── catalog_list_item.dart       # Pre-populated alternative card
│   │   │   │       └── custom_alternative_input.dart# TextField for manual alternative entry
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── alternative.dart            # Alternative(id, name, source: 'catalog'|'custom')
│   │   │   │   ├── repositories/
│   │   │   │   │   └── alternative_repository.dart # Interface: getCatalogAlternatives(), validateCount()
│   │   │   │   └── usecases/
│   │   │   │       └── add_alternative_usecase.dart# Validates tier limits before adding
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── alternative_datasource.dart # Load catalog from assets
│   │   │
│   │   ├── criteria_selection/        # Requirement Group 5: Criteria Selection & Suggestion
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── criteria_selection_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── criteria_provider.dart      # Manages selected criteria, AI suggestions state
│   │   │   │   └── widgets/
│   │   │   │       ├── criterion_item.dart         # Checkbox + name + type indicator
│   │   │   │       └── ai_suggestion_widget.dart   # Shows AI-suggested criteria with confidence
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── criterion.dart             # Criterion(id, name, type: 'benefit'|'cost', source)
│   │   │   │   ├── repositories/
│   │   │   │   │   └── criteria_repository.dart    # Interface: getSuggestedCriteria(), validateCount()
│   │   │   │   └── usecases/
│   │   │   │       ├── fetch_ai_suggestions_usecase.dart
│   │   │   │       └── add_criterion_usecase.dart  # Validates tier limits before adding
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           ├── criteria_datasource.dart    # Load suggested criteria from assets/API
│   │   │           └── ai_suggestion_datasource.dart # Future: Call AI service for suggestions
│   │   │
│   │   ├── priority_setting/          # Requirement Group 6: Priority & Weight Input
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── priority_input_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── priority_provider.dart     # Manages weights for each criterion
│   │   │   │   └── widgets/
│   │   │   │       ├── weight_slider.dart          # Slider 0-100% with real-time label
│   │   │   │       └── total_weight_indicator.dart # Shows sum with green/red background
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── priority.dart              # Priority(criterionId, weight: 0-100)
│   │   │   │   ├── repositories/
│   │   │   │   │   └── priority_repository.dart    # Interface: savePriorities()
│   │   │   │   └── usecases/
│   │   │   │       ├── validate_weights_usecase.dart   # Ensures sum = 100%
│   │   │   │       └── auto_balance_usecase.dart       # Proportionally rescale weights
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── priority_datasource.dart    # Future: Persist preferences
│   │   │
│   │   ├── decision_engine/           # Requirement Group 7 & 16: SAW Calculation & Determinism
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── result_screen.dart
│   │   │   │   │   └── result_detail_screen.dart  # Expanded view of calculation breakdown
│   │   │   │   └── providers/
│   │   │   │       └── result_provider.dart       # Manages calculation results, loading state
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── decision_matrix.dart       # DecisionMatrix(alternatives, criteria, values[alt][crit])
│   │   │   │   │   ├── decision_result.dart       # DecisionResult(scores[], rankings[], breakdown)
│   │   │   │   │   ├── calculation_breakdown.dart # Normalized + weighted scores per alternative
│   │   │   │   │   └── saw_configuration.dart     # Algorithm version, tolerance, timestamp
│   │   │   │   ├── repositories/
│   │   │   │   │   └── decision_engine_repository.dart # Interface: calculate(matrix) -> result
│   │   │   │   └── usecases/
│   │   │   │       ├── calculate_saw_usecase.dart      # Orchestrates normalization -> weighting -> ranking
│   │   │   │       ├── normalize_values_usecase.dart   # Benefit & Cost normalization logic
│   │   │   │       └── apply_weights_usecase.dart      # Multiplies normalized values by weights
│   │   │   ├── data/
│   │   │   │   └── datasources/
│   │   │   │       └── saw_calculator.dart        # Pure functions for SAW math (testable)
│   │   │   └── tests/                             # Unit tests co-located with calculation logic
│   │   │       └── saw_calculator_test.dart       # Property-based tests for determinism
│   │   │
│   │   ├── ai_explanation/            # Requirement Group 8 & 17: AI Explanations & Guardrails
│   │   │   ├── presentation/
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── ai_insight_widget.dart     # Displays AI-generated explanation
│   │   │   │   │   └── explanation_disclaimer.dart # "AI suggestions are not guarantees"
│   │   │   │   └── providers/
│   │   │   │       └── ai_explanation_provider.dart # Fetches & caches AI explanations
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── ai_explanation.dart        # AIExplanation(text, factors[], tradeoffs[])
│   │   │   │   │   └── ai_guardrails.dart         # AIGuardrails(confidenceThreshold, charLimit)
│   │   │   │   ├── repositories/
│   │   │   │   │   └── ai_explanation_repository.dart # Interface: generateExplanation(result)
│   │   │   │   └── usecases/
│   │   │   │       └── generate_explanation_usecase.dart # Validates explanation grounding
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── ai_service_datasource.dart # Future: Call LLM backend service
│   │   │
│   │   ├── comparison/                # Requirement Group 9: Comparison Feature
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── comparison_screen.dart
│   │   │   │   └── providers/
│   │   │   │       └── comparison_provider.dart    # Manages comparison view state
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── comparison_view.dart       # Data structured for side-by-side display
│   │   │   │   │   └── cell_highlight.dart        # Identifies best performer per criterion
│   │   │   │   └── repositories/
│   │   │   │       └── comparison_repository.dart  # Interface: buildComparisonView(result)
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── comparison_datasource.dart  # Transform results into comparison format
│   │   │
│   │   ├── what_if_simulation/        # Requirement Group 10: What-If Simulation
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── what_if_screen.dart
│   │   │   │   │   └── simulation_comparison_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── simulation_provider.dart   # Manages simulated weights, live recalculation
│   │   │   │   └── widgets/
│   │   │   │       ├── simulation_slider.dart     # Weight slider for simulation
│   │   │   │       └── ranking_preview.dart       # Real-time preview of new ranking
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── simulation_state.dart      # Simulation(originalWeights, simulatedWeights, result)
│   │   │   │   │   └── ranking_delta.dart         # Tracks which alternatives changed position
│   │   │   │   ├── repositories/
│   │   │   │   │   └── simulation_repository.dart  # Interface: createSimulation(), saveAsDecision()
│   │   │   │   └── usecases/
│   │   │   │       ├── recalculate_simulation_usecase.dart # Fast recalc with updated weights
│   │   │   │       └── validate_simulation_usecase.dart    # Ensures weights = 100%
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── simulation_datasource.dart  # In-memory storage, never mutates original
│   │   │
│   │   ├── decision_history/          # Requirement Group 11: Decision History & Persistence
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── history_screen.dart
│   │   │   │   │   └── decision_detail_screen.dart
│   │   │   │   ├── providers/
│   │   │   │   │   └── history_provider.dart      # Manages history list, filtering, pagination
│   │   │   │   └── widgets/
│   │   │   │       └── history_list_item.dart      # Decision list item (title, status, date, actions)
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── stored_decision.dart       # StoredDecision(id, userId, createdAt, inputs, outputs)
│   │   │   │   │   └── decision_status.dart       # Status enum: draft, in_progress, completed
│   │   │   │   ├── repositories/
│   │   │   │   │   └── decision_history_repository.dart # Interface: save(), list(), delete(), get()
│   │   │   │   └── usecases/
│   │   │   │       ├── save_decision_usecase.dart      # Persists completed decision with full context
│   │   │   │       ├── list_decisions_usecase.dart     # Paginates history, filters by category/date
│   │   │   │       └── delete_decision_usecase.dart    # Soft or hard delete with confirmation
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── decision_history_datasource.dart # Future: SQLite or backend API
│   │   │
│   │   ├── access_control/            # Requirement Group 12: Access Control & Role-Based Features
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_role.dart             # Enum: guest, basic, premium, admin
│   │   │   │   │   ├── user_plan.dart             # Plan(tier, quotas: {alternatives: 3, criteria: 3, ...})
│   │   │   │   │   └── plan_policy.dart           # Enforces quotas and feature availability
│   │   │   │   ├── repositories/
│   │   │   │   │   └── access_control_repository.dart # Interface: canCreateDecision(), canAddAlternative()
│   │   │   │   └── usecases/
│   │   │   │       ├── check_plan_limits_usecase.dart # Validates against tier quotas
│   │   │   │       └── enforce_role_access_usecase.dart # Checks user role for feature access
│   │   │   ├── presentation/
│   │   │   │   ├── providers/
│   │   │   │   │   └── access_control_provider.dart # Manages access state, quota enforcement
│   │   │   │   └── widgets/
│   │   │   │       └── upgrade_required_dialog.dart # Shows tier limitation with upgrade CTA
│   │   │   └── data/
│   │   │       └── datasources/
│   │   │           └── plan_policy_datasource.dart # Defines quota rules per tier
│   │   │
│   │   ├── validation/                # Requirement Group 13: Data Validation & Error Handling
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── validation_result.dart     # ValidationResult(isValid, errors[])
│   │   │   │   │   └── field_validation.dart      # Individual field validation rules
│   │   │   │   ├── repositories/
│   │   │   │   │   └── validation_repository.dart  # Interface: validateEmail(), validatePassword(), etc.
│   │   │   │   └── usecases/
│   │   │   │       ├── validate_registration_usecase.dart
│   │   │   │       ├── validate_alternatives_usecase.dart
│   │   │   │       ├── validate_criteria_usecase.dart
│   │   │   │       └── validate_weights_usecase.dart
│   │   │   ├── data/
│   │   │   │   └── datasources/
│   │   │   │       └── validation_datasource.dart # Regex patterns, rules implementation
│   │   │   └── presentation/
│   │   │       └── providers/
│   │   │           └── validation_provider.dart    # Real-time validation state for forms
│   │   │
│   │   └── profile/                   # User Profile & Settings
│   │       ├── presentation/
│   │       │   ├── screens/
│   │       │   │   └── profile_screen.dart
│   │       │   └── providers/
│   │       │       └── profile_provider.dart      # Manages user profile state
│   │       ├── domain/
│   │       │   └── repositories/
│   │       │       └── profile_repository.dart    # Interface: getProfile(), updateProfile()
│   │       └── data/
│   │           └── datasources/
│   │               └── profile_datasource.dart    # Load/save profile data
│   │
│   └── assets/                         # Static resources
│       ├── images/
│       │   ├── splash_logo.png         # MyChoice logo for splash screen
│       │   ├── onboarding_*.png        # 5 onboarding screen illustrations
│       │   └── empty_state_*.png       # Empty state illustrations
│       ├── icons/                      # SVG icons (16 icons total)
│       │   ├── category_tech.svg
│       │   ├── category_education.svg
│       │   ├── category_fashion.svg
│       │   ├── criteria_benefit.svg
│       │   ├── criteria_cost.svg
│       │   ├── icon_plus.svg
│       │   ├── icon_delete.svg
│       │   ├── icon_check.svg
│       │   ├── icon_settings.svg
│       │   ├── icon_history.svg
│       │   ├── icon_home.svg
│       │   ├── icon_compare.svg
│       │   ├── icon_whatif.svg
│       │   ├── icon_ai.svg
│       │   ├── icon_upgrade.svg
│       │   └── icon_info.svg
│       └── data/
│           ├── categories.json         # Catalog of categories and subcategories
│           ├── subcategories.json      # Detailed subcategory definitions
│           └── alternatives_catalog.json # Pre-populated alternatives per subcategory
```

### 2.2 Layered Architecture

Each feature module follows Clean Architecture layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  Screens, Providers (ChangeNotifier), Widgets, Dialogs      │
│  Responsibility: UI state, user input handling, navigation  │
└───────────────────┬─────────────────────────────────────────┘
                    │ depends on
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  Entities, Use Cases, Repository Interfaces                 │
│  Responsibility: Business logic, pure functions, contracts  │
└───────────────────┬─────────────────────────────────────────┘
                    │ depends on
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  Repositories (Implementations), Data Sources, Models       │
│  Responsibility: API calls, persistence, cache management   │
└─────────────────────────────────────────────────────────────┘
```

**Dependency Rule**: Presentation depends on Domain, Domain depends on Data. No reverse dependencies.

---

## 3. State Management: Provider Pattern

### 3.1 Provider Architecture Overview

The app uses **Provider** (^6.1.1) for state management because:
- Lightweight and performant
- Flutter-native (no custom reducers)
- Easy to test (ChangeNotifier is straightforward)
- Minimal boilerplate compared to BLoC or Redux

### 3.2 Core Providers

```dart
// lib/features/auth/presentation/providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  
  // State
  User? _user;
  Session? _session;
  AuthState _state = AuthState.unauthenticated;
  String? _error;
  
  // Getters
  User? get user => _user;
  AuthState get state => _state;
  bool get isAuthenticated => _state == AuthState.authenticated;
  
  // Methods
  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();
    
    try {
      final result = await _repository.login(email, password);
      _user = result.user;
      _session = result.session;
      _state = AuthState.authenticated;
    } on AuthException catch (e) {
      _state = AuthState.error;
      _error = e.message;
    }
    notifyListeners();
  }
}
```

### 3.3 Provider Consumer Pattern in Screens

```dart
// Usage in screen
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.state == AuthState.loading) {
      return const LoadingSpinner();
    }
    
    if (authProvider.isAuthenticated) {
      return DashboardScreen();
    }
    
    return LoginScreen();
  },
)
```

### 3.4 Cross-Feature Provider Dependencies

Some providers depend on others:

```dart
// Decision creation depends on access control
class AlternativeProvider extends ChangeNotifier {
  final AlternativeRepository _repository;
  final AccessControlProvider _accessControl;
  
  Future<void> addAlternative(Alternative alt) async {
    // Check plan limits
    if (!_accessControl.canAddAlternative()) {
      throw PlanLimitExceededException();
    }
    // ... add logic
  }
}
```

Provider handles this via `Consumer` or `watch` pattern without creating circular dependencies.

---

## 4. Navigation & Routing Strategy

### 4.1 Routing Architecture

The app uses **basic MaterialApp routing** (not GoRouter at this stage) with a clear route hierarchy:

```
Splash ─→ Onboarding ─┐
                       │
                    Login/Register
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
    Dashboard ← Profile ← History
        │
        └─→ Create Decision Flow
            ├─→ Category Selection
            ├─→ Alternative Management
            ├─→ Criteria Selection
            ├─→ Priority Input
            ├─→ Result Screen
            │   ├─→ Result Details
            │   ├─→ Comparison View
            │   ├─→ What-If Simulation
            │   └─→ Save Decision
            └─→ Decision History
```

### 4.2 Route Protection

Routes are protected via middleware in `app.dart`:

```dart
// lib/app.dart
initialRoute: '/',
routes: {
  '/': (context) {
    // Splash → check if user authenticated
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) return DashboardScreen();
        return SplashScreen(); // Continue to onboarding/login
      },
    );
  },
  '/dashboard': (context) => _protectedRoute(DashboardScreen()),
  '/create-decision': (context) => _protectedRoute(CreateDecisionScreen()),
  // ...
}

Widget _protectedRoute(Widget screen) {
  return Consumer<AuthProvider>(
    builder: (context, auth, _) {
      if (!auth.isAuthenticated) {
        // Redirect to login
        Navigator.of(context).pushReplacementNamed('/login');
        return SizedBox.shrink();
      }
      return screen;
    },
  );
}
```

---

## 5. Domain Models & Data Structures

### 5.1 Core Entities

#### User Entity
```dart
class User {
  final String id;
  final String email;
  final String name;
  final DateTime dateOfBirth;
  final UserRole role; // guest, basic, premium, admin
  final UserPlan plan;
  final DateTime createdAt;
  
  User copyWith({
    String? id,
    String? email,
    String? name,
    // ...
  }) => User(
    id: id ?? this.id,
    // ...
  );
}

enum UserRole { guest, basic, premium, admin }
```

#### Session Entity
```dart
class Session {
  final String token;
  final String? refreshToken;
  final DateTime expiresAt;
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isExpiringSoon => 
    DateTime.now().add(Duration(hours: 1)).isAfter(expiresAt);
}
```

#### Decision-Related Entities

```dart
class Decision {
  final String id;
  final String userId;
  final String title;
  final Category category;
  final Subcategory subcategory;
  final List<Alternative> alternatives;
  final List<Criterion> criteria;
  final Map<String, double> weights; // criterionId -> weight (0-100)
  final DecisionMatrix? matrix;
  final DecisionResult? result;
  final DecisionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
}

enum DecisionStatus { draft, inProgress, completed }

class Category {
  final String id;
  final String name;
  final String iconPath;
  final List<Subcategory> subcategories;
}

class Subcategory {
  final String id;
  final String name;
  final String categoryId;
}

class Alternative {
  final String id;
  final String name;
  final AlternativeSource source; // catalog or custom
  final String? catalogId;
}

enum AlternativeSource { catalog, custom }

class Criterion {
  final String id;
  final String name;
  final CriterionType type; // benefit or cost
  final String source; // 'suggested', 'custom', 'ai_suggested'
}

enum CriterionType { benefit, cost }

class DecisionMatrix {
  final List<Alternative> alternatives;
  final List<Criterion> criteria;
  final Map<String, Map<String, double>> values;
  // values[altId][critId] = raw value
  
  double? getValue(String altId, String critId) =>
    values[altId]?[critId];
  
  void setValue(String altId, String critId, double value) {
    values[altId] ??= {};
    values[altId]![critId] = value;
  }
  
  bool isComplete() => criteria.every((crit) =>
    alternatives.every((alt) =>
      getValue(alt.id, crit.id) != null));
}
```

#### Decision Result Entities

```dart
class DecisionResult {
  final List<RankedAlternative> ranking;
  final Map<String, CalculationBreakdown> breakdown;
  final String algorithmVersion;
  final DateTime calculatedAt;
  final SAWConfiguration config;
}

class RankedAlternative {
  final int rank;
  final Alternative alternative;
  final double compositeScore; // 0-100
}

class CalculationBreakdown {
  final String alternativeId;
  final Map<String, NormalizedScore> criteria;
  // criteria[critId] = { normalized: 0.85, weight: 0.30, weighted: 0.255 }
}

class NormalizedScore {
  final double normalized; // 0-1
  final double weight; // 0-1 (percentage / 100)
  final double weighted; // normalized * weight
}

class SAWConfiguration {
  final String version; // '1.0'
  final double toleranceThreshold; // ±0.001
  final DateTime timestamp;
}
```

#### Plan & Quota Entities

```dart
class UserPlan {
  final UserRole tier;
  final int maxAlternativesPerDecision;
  final int maxCriteriaPerDecision;
  final int maxDecisionsPerMonth;
  final int maxWhatIfSimulations;
  final bool hasAIExplanations;
  final DateTime? upgradeEligibleDate;
  
  static UserPlan basic() => UserPlan(
    tier: UserRole.basic,
    maxAlternativesPerDecision: 3,
    maxCriteriaPerDecision: 3,
    maxDecisionsPerMonth: 5,
    maxWhatIfSimulations: 1,
    hasAIExplanations: true, // basic AI: 1-2 factors
  );
  
  static UserPlan premium() => UserPlan(
    tier: UserRole.premium,
    maxAlternativesPerDecision: 10,
    maxCriteriaPerDecision: 8,
    maxDecisionsPerMonth: null, // unlimited
    maxWhatIfSimulations: null, // unlimited
    hasAIExplanations: true, // detailed: 3-4 factors
  );
}
```

### 5.2 Validation Rules

```dart
// lib/core/validators/validation_rules.dart
class ValidationRules {
  static const String emailRegex =
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  static const int passwordMinLength = 8;
  static const String passwordRequirements =
    'At least 8 characters, 1 uppercase, 1 number';
  
  static const int textFieldMaxLength = 50;
  static const int alternativeNameMaxLength = 100;
  static const int decisionTitleMaxLength = 100;
  
  static bool isValidEmail(String email) =>
    RegExp(emailRegex).hasMatch(email);
  
  static bool isStrongPassword(String password) =>
    password.length >= passwordMinLength &&
    password.contains(RegExp(r'[A-Z]')) &&
    password.contains(RegExp(r'\d'));
  
  static ValidationResult validateAlternatives(
    List<Alternative> alts,
    UserPlan plan,
  ) {
    if (alts.length < 2) {
      return ValidationResult.error('At least 2 alternatives required');
    }
    if (alts.length > plan.maxAlternativesPerDecision) {
      return ValidationResult.error(
        'Maximum ${plan.maxAlternativesPerDecision} alternatives allowed'
      );
    }
    return ValidationResult.success();
  }
}
```

---

## 6. Decision Engine (SAW) Design

### 6.1 SAW Algorithm Contract

The Simple Additive Weighting algorithm follows this deterministic contract:

```
INPUT:
  - Decision Matrix: alternatives × criteria with raw values
  - Criterion types: benefit (↑ better) or cost (↓ better)
  - Weights: {criterion_id: percentage} summing to 100%

PROCESS:
  1. NORMALIZE each criterion value
     - Benefit: normalized[i] = raw[i] / MAX(raw[*])
     - Cost: normalized[i] = MIN(raw[*]) / raw[i]
  
  2. WEIGHT each normalized value
     - weighted[i][j] = normalized[i][j] × (weight[j] / 100)
  
  3. SUM weighted scores per alternative
     - score[i] = Σ weighted[i][j] for all j
  
  4. RANK alternatives by score (descending)
     - ranking = sort(score[], descending)

OUTPUT:
  - Scores: [0-1] or [0-100] (multiply by 100 for display)
  - Ranking: Ordered list of alternatives
  - Breakdown: Normalized + weighted values per alternative (for explanation)

DETERMINISM GUARANTEE:
  - Same inputs always produce same output (within floating-point tolerance)
  - No random number generation
  - No external API calls
  - Reproducible at any future time
```

### 6.2 SAW Calculator Implementation

```dart
// lib/features/decision_engine/data/datasources/saw_calculator.dart

class SAWCalculator {
  static const double _tolerance = 0.001;
  static const String _version = '1.0';
  
  /// Calculate SAW result deterministically
  static DecisionResult calculate({
    required DecisionMatrix matrix,
    required Map<String, Criterion> criteriaMap,
    required Map<String, double> weights,
  }) {
    // Step 1: Normalize
    final normalized = _normalize(matrix, criteriaMap);
    
    // Step 2: Weight
    final weighted = _applyWeights(normalized, weights);
    
    // Step 3: Sum & Rank
    final scores = _sumScores(weighted);
    final ranking = _rankAlternatives(scores, matrix.alternatives);
    
    // Step 4: Build breakdown for transparency
    final breakdown = _buildBreakdown(
      normalized,
      weighted,
      weights,
      matrix.alternatives,
      criteriaMap,
    );
    
    return DecisionResult(
      ranking: ranking,
      breakdown: breakdown,
      algorithmVersion: _version,
      calculatedAt: DateTime.now(),
      config: SAWConfiguration(
        version: _version,
        toleranceThreshold: _tolerance,
        timestamp: DateTime.now(),
      ),
    );
  }
  
  /// Normalize values per criterion (Step 1)
  static Map<String, Map<String, double>> _normalize(
    DecisionMatrix matrix,
    Map<String, Criterion> criteriaMap,
  ) {
    final result = <String, Map<String, double>>{};
    
    for (final crit in matrix.criteria) {
      final values = <double>[];
      for (final alt in matrix.alternatives) {
        final val = matrix.getValue(alt.id, crit.id);
        if (val != null) values.add(val);
      }
      
      if (values.isEmpty) continue;
      
      final max = values.reduce((a, b) => a > b ? a : b);
      final min = values.reduce((a, b) => a < b ? a : b);
      
      for (final alt in matrix.alternatives) {
        result[alt.id] ??= {};
        final rawValue = matrix.getValue(alt.id, crit.id);
        
        if (rawValue == null) continue;
        
        double normalized;
        if (crit.type == CriterionType.benefit) {
          normalized = max > 0 ? rawValue / max : 0.0;
        } else {
          // Cost criterion
          normalized = min > 0 ? min / rawValue : 0.0;
        }
        
        result[alt.id]![crit.id] = normalized.clampToDecimal(3);
      }
    }
    
    return result;
  }
  
  /// Apply weights (Step 2)
  static Map<String, Map<String, double>> _applyWeights(
    Map<String, Map<String, double>> normalized,
    Map<String, double> weights,
  ) {
    final result = <String, Map<String, double>>{};
    
    for (final altId in normalized.keys) {
      result[altId] = {};
      for (final critId in normalized[altId]!.keys) {
        final normValue = normalized[altId]![critId]!;
        final weight = (weights[critId] ?? 0) / 100;
        result[altId]![critId] = (normValue * weight).clampToDecimal(4);
      }
    }
    
    return result;
  }
  
  /// Sum to get scores (Step 3)
  static Map<String, double> _sumScores(
    Map<String, Map<String, double>> weighted,
  ) {
    final result = <String, double>{};
    
    for (final altId in weighted.keys) {
      final sum = weighted[altId]!.values.fold<double>(
        0.0,
        (prev, val) => prev + val,
      );
      result[altId] = (sum * 100).clampToDecimal(2); // Convert to 0-100 scale
    }
    
    return result;
  }
  
  /// Rank alternatives (Step 4)
  static List<RankedAlternative> _rankAlternatives(
    Map<String, double> scores,
    List<Alternative> alternatives,
  ) {
    final entries = scores.entries
        .map((e) => MapEntry(
          alternatives.firstWhere((a) => a.id == e.key),
          e.value,
        ))
        .toList();
    
    entries.sort((a, b) => b.value.compareTo(a.value));
    
    return entries.asMap().entries.map((e) {
      return RankedAlternative(
        rank: e.key + 1,
        alternative: e.value.key,
        compositeScore: e.value.value,
      );
    }).toList();
  }
  
  /// Build detailed breakdown for display/explanation
  static Map<String, CalculationBreakdown> _buildBreakdown(
    Map<String, Map<String, double>> normalized,
    Map<String, Map<String, double>> weighted,
    Map<String, double> weights,
    List<Alternative> alternatives,
    Map<String, Criterion> criteriaMap,
  ) {
    final result = <String, CalculationBreakdown>{};
    
    for (final alt in alternatives) {
      final criteria = <String, NormalizedScore>{};
      
      for (final critId in normalized[alt.id]?.keys ?? []) {
        criteria[critId] = NormalizedScore(
          normalized: normalized[alt.id]![critId]!,
          weight: (weights[critId] ?? 0) / 100,
          weighted: weighted[alt.id]![critId]!,
        );
      }
      
      result[alt.id] = CalculationBreakdown(
        alternativeId: alt.id,
        criteria: criteria,
      );
    }
    
    return result;
  }
}

/// Helper extension for rounding to N decimal places
extension DoubleRounding on double {
  double clampToDecimal(int places) {
    final multiplier = pow(10, places);
    return (this * multiplier).round() / multiplier;
  }
}
```

### 6.3 SAW Calculation Determinism Tests

```dart
// test/features/decision_engine/saw_calculator_test.dart

void main() {
  group('SAWCalculator - Determinism', () {
    test('Same inputs produce same output', () {
      // Fixture: Decision matrix with 3 laptops, 3 criteria
      final matrix = _buildTestMatrix();
      final criteriaMap = _buildTestCriteria();
      final weights = {'price': 30, 'ram': 40, 'battery': 30};
      
      // Calculate twice
      final result1 = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );
      
      final result2 = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );
      
      // Results must be identical
      expect(result1.ranking, equals(result2.ranking));
      expect(result1.breakdown, equals(result2.breakdown));
    });
    
    test('Benefit normalization (higher is better)', () {
      // RAM: 8GB, 16GB, 32GB
      final values = [8.0, 16.0, 32.0];
      final max = 32.0;
      
      expect(values[0] / max, closeTo(0.25, 0.001));
      expect(values[1] / max, closeTo(0.50, 0.001));
      expect(values[2] / max, closeTo(1.00, 0.001));
    });
    
    test('Cost normalization (lower is better)', () {
      // Price: $800, $1000, $1200
      final values = [800.0, 1000.0, 1200.0];
      final min = 800.0;
      
      expect(min / values[0], closeTo(1.00, 0.001));
      expect(min / values[1], closeTo(0.80, 0.001));
      expect(min / values[2], closeTo(0.67, 0.001));
    });
    
    test('Weight application (30% + 40% + 30% = 100%)', () {
      final normalizedScore = 0.85;
      final weight = 0.30;
      final weighted = normalizedScore * weight;
      
      expect(weighted, closeTo(0.255, 0.001));
    });
  });
}
```

---

## 7. Role & Plan Policy Engine

### 7.1 PlanPolicy Interface

```dart
// lib/features/access_control/domain/repositories/plan_policy.dart

class PlanPolicy {
  final UserPlan plan;
  
  PlanPolicy({required this.plan});
  
  // Quotas
  bool canAddAlternative(int currentCount) =>
    currentCount < plan.maxAlternativesPerDecision;
  
  bool canAddCriterion(int currentCount) =>
    currentCount < plan.maxCriteriaPerDecision;
  
  bool canCreateDecision(int decisionsThisMonth) =>
    plan.maxDecisionsPerMonth == null ||
    decisionsThisMonth < plan.maxDecisionsPerMonth!;
  
  bool canCreateWhatIf(int simulationsCreated) =>
    plan.maxWhatIfSimulations == null ||
    simulationsCreated < plan.maxWhatIfSimulations!;
  
  bool hasAIFeatures() => plan.hasAIExplanations;
  
  // Quota messages
  String getAlternativeQuotaMessage() =>
    'Maximum ${plan.maxAlternativesPerDecision} alternatives. Upgrade to Premium for 10.';
  
  String getCriterionQuotaMessage() =>
    'Maximum ${plan.maxCriteriaPerDecision} criteria. Upgrade to Premium for 8.';
  
  String getWhatIfQuotaMessage() =>
    'Limited to ${plan.maxWhatIfSimulations} simulations. Upgrade to Premium for unlimited.';
}
```

### 7.2 RoleGuard for Navigation

```dart
// lib/features/access_control/domain/usecases/check_role_access_usecase.dart

class CheckRoleAccessUseCase {
  final AccessControlRepository _repository;
  
  Future<bool> call({
    required String routeName,
    required User user,
  }) async {
    // Guest cannot access authenticated screens
    if (user.role == UserRole.guest) {
      return false;
    }
    
    // Basic tier cannot access premium features
    if (user.plan.tier == UserRole.basic) {
      final premiumOnlyRoutes = ['/what-if', '/ai-explanation'];
      if (premiumOnlyRoutes.contains(routeName)) {
        return false;
      }
    }
    
    return true;
  }
}
```

### 7.3 Plan Limit Enforcement

```dart
// lib/features/alternative_management/domain/usecases/add_alternative_usecase.dart

class AddAlternativeUseCase {
  final AlternativeRepository _repository;
  final AccessControlRepository _accessControl;
  
  Future<void> call(Alternative alternative) async {
    final user = _accessControl.getCurrentUser();
    final currentAlts = _repository.getSelectedAlternatives().length;
    
    if (!user.plan.policy.canAddAlternative(currentAlts)) {
      throw PlanLimitExceededException(
        message: user.plan.policy.getAlternativeQuotaMessage(),
        tier: user.plan.tier,
      );
    }
    
    await _repository.addAlternative(alternative);
  }
}
```

---

## 8. API Contract & Integration Boundaries

### 8.1 Repository Interfaces (Domain Layer)

All external integrations are defined as interfaces in the domain layer. Implementations are in the data layer.

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(RegistrationData data);
  Future<void> logout();
  Future<Session> refreshToken(String refreshToken);
  Future<Session?> getStoredSession();
}

// lib/features/decision_engine/domain/repositories/decision_engine_repository.dart
abstract class DecisionEngineRepository {
  Future<DecisionResult> calculate(DecisionMatrix matrix);
  Future<void> cacheResult(String decisionId, DecisionResult result);
  Future<DecisionResult?> getCachedResult(String decisionId);
}

// lib/features/decision_history/domain/repositories/decision_history_repository.dart
abstract class DecisionHistoryRepository {
  Future<void> saveDecision(Decision decision);
  Future<Decision?> getDecision(String decisionId);
  Future<List<Decision>> listDecisions(int page, {String? category});
  Future<void> deleteDecision(String decisionId);
}
```

### 8.2 What's Mocked vs. Unimplemented

| Integration | Status | Implementation |
|-------------|--------|-----------------|
| **Local Auth** | Mocked | Returns dummy token, no validation |
| **User Profile API** | Mocked | Returns hardcoded user data |
| **Category Catalog** | Implemented | Load from assets/JSON |
| **Alternative Catalog** | Implemented | Load from assets/JSON |
| **Criteria Suggestions** | Unimplemented | Will call backend AI service |
| **SAW Calculation** | Implemented | Pure function in data layer |
| **AI Explanations** | Unimplemented | Will call LLM backend service |
| **Decision History** | Unimplemented | Will use SQLite or backend API |
| **Push Notifications** | Unimplemented | Placeholder icon only |
| **Payment Processing** | Unimplemented | Deferred to Phase 2 |

### 8.3 Blocked Integrations (Product Decisions Required)

The following integrations are blocked pending product/backend decisions:

1. **Authentication Provider**
   - Current: Accepts any credentials (mock)
   - Required: Firebase, Auth0, or custom JWT
   - Impact: Entire auth flow

2. **AI Services**
   - Criteria suggestions API URL
   - Result explanation LLM (OpenAI, Anthropic, etc.)
   - Rate limiting and quota management
   - Impact: Premium features

3. **Decision Database**
   - Backend API schema for storing decisions
   - Caching strategy (Redis TTL)
   - Impact: History, persistence

---

## 9. AI Integration Guardrails

### 9.1 AI Service Interfaces

```dart
// lib/features/ai_explanation/domain/repositories/ai_explanation_repository.dart
abstract class AIExplanationRepository {
  Future<AIExplanation> generateExplanation(DecisionResult result);
}

// lib/features/criteria_selection/domain/repositories/ai_suggestion_repository.dart
abstract class AISuggestionRepository {
  Future<List<AISuggestion>> suggestCriteria({
    required String categoryName,
    required String subcategoryName,
    required List<Alternative> alternatives,
  });
}

// Data models
class AIExplanation {
  final String text;
  final List<String> topFactors; // Top 3 factors driving recommendation
  final List<String>? tradeoffs; // Optional competing dimensions
  final double confidence; // 0-1
  final String model; // e.g., 'gpt-4'
  final DateTime generatedAt;
}

class AISuggestion {
  final String criterionName;
  final CriterionType type;
  final double confidence; // 0-1
}
```

### 9.2 Guardrail Enforcement

```dart
// lib/features/ai_explanation/data/datasources/ai_explanation_datasource.dart

class AIExplanationDataSource {
  static const int _maxExplanationLength = 300;
  static const double _minConfidenceThreshold = 0.5;
  static const Duration _timeout = Duration(seconds: 5);
  
  Future<AIExplanation> generateExplanation(
    DecisionResult result,
  ) async {
    try {
      // Call backend (timeout after 5 seconds)
      final response = await _apiClient.post(
        '/api/ai/explain',
        data: {
          'ranking': result.ranking.map((r) => {
            'rank': r.rank,
            'alternative': r.alternative.name,
            'score': r.compositeScore,
          }).toList(),
          'factors': result.breakdown.entries.map((e) => {
            'alternative': e.value.alternativeId,
            'scores': e.value.criteria,
          }).toList(),
        },
      ).timeout(_timeout);
      
      final explanation = AIExplanation.fromJson(response.data);
      
      // Validate guardrails
      if (explanation.text.length > _maxExplanationLength) {
        throw AIValidationException(
          'Explanation exceeds maximum length'
        );
      }
      
      if (explanation.confidence < _minConfidenceThreshold) {
        // Return low-confidence response differently
        explanation = explanation.copyWith(isLowConfidence: true);
      }
      
      // Verify explanation references actual top factors
      _validateExplanationGrounding(explanation, result);
      
      return explanation;
      
    } on TimeoutException {
      // Return fallback static explanation
      return _generateFallbackExplanation(result);
    }
  }
  
  void _validateExplanationGrounding(
    AIExplanation explanation,
    DecisionResult result,
  ) {
    // Ensure explanation doesn't fabricate insights
    final topRanked = result.ranking.first.alternative.name;
    if (!explanation.text.contains(topRanked)) {
      throw AIValidationException(
        'Explanation does not reference top-ranked alternative'
      );
    }
  }
  
  AIExplanation _generateFallbackExplanation(DecisionResult result) {
    final topRanked = result.ranking.first;
    return AIExplanation(
      text: '${topRanked.alternative.name} scored highest overall with a composite score of ${topRanked.compositeScore.toStringAsFixed(1)}%.',
      topFactors: [],
      tradeoffs: null,
      confidence: 0.0,
      model: 'fallback_static',
      generatedAt: DateTime.now(),
    );
  }
}
```

### 9.3 Guardrail Rules Enforced

1. **No Final Recommendations**: System never says "You should choose X"
2. **Grounded in Calculation**: All factors reference actual SAW scores
3. **Low Confidence Transparency**: Low-confidence suggestions marked as such
4. **No Dark Patterns**: Upgrade prompts are honest, not manipulative
5. **No Data Training**: User decisions not used for model training
6. **Timeout Fallback**: AI explanations degrade gracefully if slow

---

## 10. What-If Simulation Design

### 10.1 In-Memory Simulation Model

```dart
// lib/features/what_if_simulation/domain/entities/simulation_state.dart

class SimulationState {
  final Decision originalDecision;
  final Map<String, double> originalWeights;
  final Map<String, double> simulatedWeights;
  final DecisionResult? simulatedResult;
  
  // Never mutate original decision
  bool get isSimulationModified =>
    !mapEquals(originalWeights, simulatedWeights);
  
  SimulationState copyWith({
    DecisionResult? newResult,
    Map<String, double>? newWeights,
  }) => SimulationState(
    originalDecision: originalDecision,
    originalWeights: originalWeights,
    simulatedWeights: newWeights ?? simulatedWeights,
    simulatedResult: newResult ?? simulatedResult,
  );
}
```

### 10.2 Real-Time Recalculation

```dart
// lib/features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart

class RecalculateSimulationUseCase {
  final DecisionEngineRepository _engine;
  
  Future<DecisionResult> call({
    required SimulationState state,
    required String criterionId,
    required double newWeight,
  }) async {
    // Update weights (ensure they stay at 100% total)
    final updated = Map<String, double>.from(state.simulatedWeights);
    updated[criterionId] = newWeight;
    
    // Recalculate using original decision matrix with new weights
    final result = await _engine.calculate(
      matrix: state.originalDecision.matrix!,
      weights: updated,
    );
    
    return result;
  }
}
```

### 10.3 Cache Invalidation Strategy

```dart
// lib/features/what_if_simulation/data/datasources/simulation_datasource.dart

class SimulationDataSource {
  final DecisionEngineRepository _engine;
  
  Future<DecisionResult> recalculateWithDebounce({
    required SimulationState state,
    required String criterionId,
    required double newWeight,
    Duration debounce = const Duration(milliseconds: 300),
  }) async {
    // Debounce rapid slider adjustments
    // Only recalculate if user stops adjusting for 300ms
    
    // Clear previous cache
    _cache.invalidate(state.originalDecision.id);
    
    // Recalculate
    return _engine.calculate(
      matrix: state.originalDecision.matrix!,
      weights: {...state.simulatedWeights, criterionId: newWeight},
    );
  }
}
```

---

## 11. Design System Token Implementation

### 11.1 Material Design 3 Theme

```dart
// lib/core/theme/app_theme.dart

class AppTheme {
  // Brand Colors (from design system)
  static const Color primaryColor = Color(0xFF6366F1); // Indigo-500
  static const Color secondaryColor = Color(0xFF10B981); // Emerald-500
  static const Color tertiaryColor = Color(0xFFF59E0B); // Amber-500
  
  // Semantic Colors
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFEF2F2); // Red
  
  // Neutral Colors (Light Mode)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceVariant = Color(0xFFE2E8F0); // Slate-200
  
  // Text Colors (Light Mode)
  static const Color onSurface = Color(0xFF0F172A); // Slate-900
  static const Color onSurfaceVariant = Color(0xFF475569); // Slate-600
  static const Color onSurfaceDisabled = Color(0xFFA1A5AB); // Slate-400
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        error: errorColor,
        surface: surface,
        onSurface: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: onSurfaceVariant,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: surfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    // Similar structure with dark-appropriate colors
    // Implement dark mode (deferred to Phase 2 if needed)
    return lightTheme; // Placeholder
  }
}
```

### 11.2 Typography Scale

```dart
// lib/core/theme/app_typography.dart

class AppTypography {
  static const String primaryFont = 'Poppins'; // From google_fonts
  static const String secondaryFont = 'Inter'; // Fallback
  
  // Display (32px, bold) - Large headlines
  static TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: primaryFont,
    height: 1.2,
  );
  
  // Heading 1 (28px, semibold) - Section titles
  static TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    height: 1.25,
  );
  
  // Heading 2 (24px, semibold) - Subsection titles
  static TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    height: 1.3,
  );
  
  // Heading 3 (20px, semibold) - Card titles
  static TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    height: 1.4,
  );
  
  // Body Large (16px, regular) - Main body text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.5,
  );
  
  // Body Medium (14px, regular) - Secondary body text
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.5,
  );
  
  // Caption (12px, regular) - Small labels and hints
  static TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: primaryFont,
    height: 1.4,
  );
  
  // Button (16px, semibold) - Button labels
  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    height: 1.5,
    letterSpacing: 0.5,
  );
}
```

### 11.3 Spacing & Layout Tokens

```dart
// lib/core/theme/app_spacing.dart

class AppSpacing {
  // Base 8px grid system
  static const double xs = 4.0;     // Micro spacing
  static const double sm = 8.0;     // Small margins
  static const double md = 16.0;    // Standard margin
  static const double lg = 24.0;    // Large margin
  static const double xl = 32.0;    // Extra large
  static const double xxl = 48.0;   // Double extra large
  
  // Common edge insets
  static const EdgeInsets paddingSm = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMd = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLg = EdgeInsets.all(24.0);
  
  // Corner radius
  static const double radiusSm = 4.0;   // Subtle rounding
  static const double radiusMd = 8.0;   // Standard rounding
  static const double radiusLg = 12.0;  // Generous rounding
  static const double radiusXl = 16.0;  // Extra rounded
  static const double radiusFull = 999.0; // Pill-shaped
  
  // Elevation/Shadow
  static const double shadowSm = 2.0;
  static const double shadowMd = 4.0;
  static const double shadowLg = 8.0;
}
```

---

## 12. Platform-Specific Considerations

### 12.1 Android Material Design 3

- **Target**: Material Design 3 (already configured in pubspec.yaml with `useMaterial3: true`)
- **Navigation**: Bottom navigation bar (5 tabs), back button in AppBar
- **Gestures**: Back button (hardware), swipe back from edge
- **Typography**: Poppins font family with Material 3 scale
- **Density**: Compact spacing optimized for thumb reach on 5-6" screens

### 12.2 iOS Human Interface Guidelines

- **Safe Area Handling**: Use `MediaQuery.of(context).padding` to account for notch
- **Navigation**: Back gesture from left edge (handled by Navigator.pop())
- **Status Bar**: Transparent with dark icons (configured in main.dart)
- **Haptics**: Vibration feedback on button press (via `HapticFeedback.mediumImpact()`)

### 12.3 Responsive Layout

```dart
// lib/core/extensions/context_extensions.dart

extension BuildContextExtensions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  bool get isSmallScreen => screenWidth < 450; // 4.5" phone
  bool get isLargeScreen => screenWidth > 600;  // Tablet-sized
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;
  EdgeInsets get padding => MediaQuery.of(this).padding;
}

// Usage in screens
if (context.isSmallScreen) {
  // Compact layout for small phones
} else {
  // Expanded layout for larger screens
}
```

---

## 13. Error Handling Strategy

### 13.1 Exception Hierarchy

```dart
// lib/core/errors/app_exception.dart

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => 'AppException: [$code] $message';
}

class ValidationError extends AppException {
  ValidationError({required String message}) : super(message: message);
}

class AuthenticationError extends AppException {
  AuthenticationError({required String message}) : super(message: message);
}

class CalculationError extends AppException {
  CalculationError({required String message}) : super(message: message);
}

class DataMissingError extends AppException {
  final String fieldName;
  DataMissingError({required this.fieldName})
    : super(message: '$fieldName is required');
}

class NetworkError extends AppException {
  NetworkError({required String message}) : super(message: message);
}

class TimeoutError extends AppException {
  TimeoutError({String message = 'Request timed out'})
    : super(message: message);
}

class PlanLimitExceededException extends AppException {
  final UserRole tier;
  PlanLimitExceededException({
    required String message,
    required this.tier,
  }) : super(message: message);
}
```

### 13.2 Error Handler & User Messages

```dart
// lib/core/errors/error_handler.dart

class ErrorHandler {
  static String getUserFriendlyMessage(Exception error) {
    if (error is ValidationError) {
      return error.message;
    } else if (error is AuthenticationError) {
      return 'Invalid email or password. Please try again.';
    } else if (error is DataMissingError) {
      return '${error.fieldName} is required.';
    } else if (error is TimeoutError) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error is NetworkError) {
      return 'Connection error. Please check your internet and try again.';
    } else if (error is PlanLimitExceededException) {
      return error.message;
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
  
  static void handleError(
    BuildContext context,
    Exception error, {
    VoidCallback? onRetry,
  }) {
    final message = getUserFriendlyMessage(error);
    
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: 'Error',
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
```

---

## 14. Offline & Edge Cases

### 14.1 Caching Strategy

```dart
// lib/core/utils/cache_manager.dart

class CacheManager {
  static const Duration categoryTTL = Duration(days: 30);
  static const Duration subcategoryTTL = Duration(days: 30);
  static const Duration catalogTTL = Duration(days: 7);
  
  Future<T?> get<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(key);
    if (json == null) return null;
    
    final cached = jsonDecode(json) as Map<String, dynamic>;
    final expiresAt = DateTime.parse(cached['expiresAt'] as String);
    
    if (DateTime.now().isAfter(expiresAt)) {
      await prefs.remove(key);
      return null;
    }
    
    return cached['data'] as T?;
  }
  
  Future<void> set<T>(
    String key,
    T value,
    Duration ttl,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode({
      'data': value,
      'expiresAt': DateTime.now().add(ttl).toIso8601String(),
    });
    await prefs.setString(key, json);
  }
}
```

### 14.2 Offline Decision Viewing

```dart
// lib/features/decision_history/presentation/providers/history_provider.dart

class HistoryProvider extends ChangeNotifier {
  Future<Decision?> getDecision(String decisionId) async {
    try {
      // Try remote first
      return await _repository.getDecision(decisionId);
    } on NetworkError {
      // Fall back to cache
      return await _cacheManager.get<Decision>('decision_$decisionId');
    }
  }
}
```

### 14.3 Session Expiration & Re-authentication

```dart
// lib/features/auth/presentation/providers/auth_provider.dart

class AuthProvider extends ChangeNotifier {
  Future<void> validateSession() async {
    final session = await _repository.getStoredSession();
    
    if (session == null || session.isExpired) {
      _state = AuthState.unauthenticated;
      notifyListeners();
      // Navigate to login
    } else if (session.isExpiringSoon) {
      // Attempt silent refresh
      try {
        await _repository.refreshToken(session.refreshToken!);
      } catch (e) {
        _state = AuthState.unauthenticated;
        notifyListeners();
      }
    }
  }
}
```

---

## 15. Implementation Phases

### Phase 0: Reconnaissance Checklist

- [ ] Verify Flutter environment (SDK version, device emulators)
- [ ] Check pubspec.yaml dependencies are correct
- [ ] Confirm directory structure matches design
- [ ] Verify asset folders exist (images/, icons/, data/)
- [ ] Test basic app launch (Splash → Login/Dashboard)
- [ ] Confirm Material Design 3 theme applies
- [ ] Check orientation lock (portrait-only)

### Phase 1: App Shell, Design Tokens, Routing Skeleton

**Deliverables**:
- App theme with colors, typography, spacing tokens
- Bottom navigation bar (5 tabs, not functional yet)
- Route skeleton with placeholder screens
- Splash screen with 3-second animated logo
- Basic AppBar and dialog components

**Files to create**:
- `lib/core/theme/*` (all theme files)
- `lib/core/widgets/navigation/bottom_nav_bar.dart`
- All screen skeletons (empty StatelessWidget)
- Asset files (images, icons)

**Tests**: Visual inspection only

### Phase 2: Domain Models, SAW Engine, Validators (Unit Tested)

**Deliverables**:
- All entity classes (User, Decision, Alternative, etc.)
- SAW calculator with determinism tests
- Validation use cases with unit tests
- Error exception hierarchy

**Files to create**:
- `lib/features/*/domain/entities/*.dart`
- `lib/features/decision_engine/data/datasources/saw_calculator.dart`
- `test/features/decision_engine/saw_calculator_test.dart`
- `lib/core/errors/*`

**Tests**: 100+ property-based tests for SAW determinism, unit tests for validators

### Phase 3: Public Pages (Guest Home, Catalog, Auth)

**Deliverables**:
- Splash screen with logo animation
- Onboarding (5 screens)
- Login & registration screens with validation
- Password reset flow (placeholder)
- Catalog browsing (categories, subcategories)

**Files to create**:
- `lib/features/auth/presentation/screens/*.dart`
- `lib/features/category_selection/presentation/screens/*.dart`
- Providers for auth, category selection

**Tests**: Widget tests for form validation, navigation tests

### Phase 4: Decision Creation Flow (Category → Alternatives → Criteria)

**Deliverables**:
- Category & subcategory selection screen
- Alternative management (catalog + custom entry)
- Criteria selection with AI suggestions (placeholder)
- Real-time validation of count limits

**Files to create**:
- `lib/features/alternative_management/presentation/screens/*.dart`
- `lib/features/criteria_selection/presentation/screens/*.dart`
- Providers for alternatives, criteria

**Tests**: Widget tests for quota enforcement, alternative addition/removal

### Phase 5: SAW Calculation, Results Display

**Deliverables**:
- Priority input screen with weight sliders (total % indicator)
- Result screen with ranked alternatives and scores
- Expandable result detail view
- Calculation breakdown transparency

**Files to create**:
- `lib/features/priority_setting/presentation/screens/*.dart`
- `lib/features/decision_engine/presentation/screens/result_screen.dart`
- ResultProvider for calculation state

**Tests**: Unit tests for calculation, widget tests for result display

### Phase 6: Comparison, What-If, AI Explanation Interface

**Deliverables**:
- Side-by-side comparison screen (horizontal scrollable table)
- What-If simulation screen with live recalculation
- AI explanation display (placeholder + real integration point)
- Simulation comparison view

**Files to create**:
- `lib/features/comparison/presentation/screens/*.dart`
- `lib/features/what_if_simulation/presentation/screens/*.dart`
- Providers for simulation state, comparison

**Tests**: Widget tests for UI responsiveness, unit tests for recalculation logic

### Phase 7: History, Premium Insights

**Deliverables**:
- History list with pagination/search
- Decision detail view
- Delete decision with confirmation
- Plan tier info on profile screen
- Upgrade prompts for Basic tier limits

**Files to create**:
- `lib/features/decision_history/presentation/screens/*.dart`
- `lib/features/profile/presentation/screens/*.dart`
- HistoryProvider, ProfileProvider

**Tests**: Widget tests for history navigation, unit tests for pagination

### Phase 8: Admin Features (Backend Only)

- Catalog management (deferred to backend)
- User management (deferred to backend)
- Plan tier configuration (deferred to backend)

### Phase 9: Accessibility, Tests, Hardening

**Deliverables**:
- Semantic labels on all interactive elements
- Focus order correct
- Color contrast verified (4.5:1 WCAG AA)
- Keyboard navigation tested
- Accessibility audit

**Files**: Update all screens with `Semantics` widgets

**Tests**: Accessibility tests with `flutter test` a11y plugin

---

## 16. Database & Persistence Strategy (Blocked)

**Status**: Blocked pending backend decisions

**Current Options**:
1. **SQLite Local** (sqlite3 package)
   - Pros: Offline-first, encrypted, no backend needed
   - Cons: Sync logic complex, no cloud backup
   
2. **Firebase Firestore**
   - Pros: Real-time sync, cloud storage, authentication
   - Cons: Vendor lock-in, cost structure
   
3. **Backend REST API**
   - Pros: Full control, custom auth
   - Cons: Requires backend infrastructure
   
4. **Hybrid** (SQLite + Backend sync)
   - Pros: Offline-first with cloud backup
   - Cons: Most complex implementation

**Decision needed**: Which persistence layer for decision history?

---

## 17. Testing Strategy

### 17.1 Unit Tests

**Decision Engine (Determinism)**:
```
- Same inputs → same output
- Normalization (benefit & cost)
- Weight application
- Ranking order
- Edge cases (zero values, all same values)
- Decimal precision
- Algorithm version tracking
```

**Validators**:
```
- Email validation (RFC 5322)
- Password complexity
- Plan limits (3 alts, 3 criteria, etc.)
- Weight sum = 100%
- Text field length limits
```

**Plan Policy**:
```
- Basic tier quota enforcement
- Premium tier unlimited features
- Guest tier access restrictions
- Tier upgrade eligibility
```

### 17.2 Widget Tests

**Critical Screens**:
```
- Category selection (tap category, subcategories appear)
- Alternative management (add/remove, count validation)
- Weight slider (total % recalculates)
- Result display (ranking order, scores shown)
- Error dialogs (validation errors, API errors)
```

### 17.3 Property-Based Tests (if applicable)

**Determinism Property**:
```
for_all inputs in decision_matrices:
  calculate(inputs) == calculate(inputs)
```

**Normalization Property**:
```
for_all benefit_values in [0, 1000]:
  normalized_value in [0, 1]
  
for_all cost_values in [0, 1000]:
  normalized_value in [0, 1]
  lower_cost => higher_normalized
```

**Weight Property**:
```
for_all weights summing to 100%:
  sum(weights) == 100.0 (±0.001 tolerance)
```

### 17.4 Test Coverage Goals

- **Decision Engine**: 95%+ (pure logic, highly testable)
- **Domain Models**: 90%+ (entities, use cases)
- **Providers**: 70%+ (state management)
- **Screens**: 50%+ (critical flows only, UI testing is fragile)
- **Overall**: 80%+ target

---

## 18. Blocked Decisions & Open Questions

### Product Decisions Needed

1. **Authentication Provider**
   - Firebase Auth? Custom JWT? Third-party?
   - Affects: Entire auth flow, token management, security

2. **AI Service Integration**
   - Which LLM (OpenAI, Anthropic, Google)?
   - Criteria suggestions? Result explanations?
   - Rate limiting and pricing model?
   - Affects: Premium feature availability, cost structure

3. **Database & Persistence**
   - Local SQLite? Backend API? Firebase?
   - Decision history storage strategy?
   - Sync logic for offline-first?
   - Affects: Architecture, scalability, maintenance

4. **Payment Processing** (Phase 2+)
   - Stripe? Apple In-App Purchase? Google Play Billing?
   - Subscription or one-time?
   - Free trial period?
   - Affects: Monetization, user acquisition

5. **Analytics & Monitoring**
   - What to track? Which tool (Firebase, Mixpanel)?
   - GDPR compliance for data collection?
   - Affects: Business insights, debugging

### Technical Questions

1. Should alternative catalog come from assets (JSON) or backend API?
   - Current design assumes JSON assets (easier deployment)
   
2. Is offline decision creation allowed, or only viewing?
   - Current design allows offline viewing of cached decisions
   
3. What precision is acceptable for SAW calculations (decimal places)?
   - Current design uses 2 decimal places (0.00 format)
   
4. Should What-If simulations be saved as new decisions or temporary only?
   - Current design allows "Save as New Decision"

---

## 19. Success Criteria

Design is considered complete when:

1. **Architecture is Clear**
   - Feature modules are well-defined
   - Dependency graph is acyclic (no circular imports)
   - Layer boundaries are respected (presentation → domain → data)

2. **Data Models are Complete**
   - All entities have proper immutability (copyWith)
   - Validation rules are specified
   - Relationships between entities are clear

3. **SAW Engine is Specified**
   - Algorithm is deterministic and testable
   - Calculation breakdown is transparent
   - Edge cases are handled

4. **Integration Points are Clear**
   - Repository interfaces are defined (not implementations)
   - Mock vs. unimplemented integrations are documented
   - Blocked decisions are explicitly flagged

5. **Testing Strategy is Concrete**
   - Unit tests for logic (decision engine, validators)
   - Widget tests for critical screens
   - Property-based tests for determinism
   - Coverage goals are realistic (80%+)

6. **Developers Can Implement**
   - Directory structure is ready to populate
   - Routing skeleton is in place
   - Theme tokens are defined
   - Clear path from design to code

---

## 18A. Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

This feature is **highly suitable for property-based testing (PBT)** because its core logic is composed of pure functions (SAW calculation, validation rules, tier quotas) with universal rules that must hold across large input spaces. The decision engine especially demands determinism verification through property-based testing.

### Property 1: SAW Calculation Determinism (Fundamental)

*For any decision matrix with identical alternatives, criteria, weights, and raw values, running the SAW calculation multiple times SHALL produce identical scores and rankings (within floating-point tolerance of ±0.001).*

**Validates**: Requirements 7.1, 7.2, 16.1, 16.2

**Rationale**: The SAW algorithm is pure logic with no randomness. Users depend on reproducible results. This property ensures calculations are deterministic—the same decision calculated today should produce the same result next week.

**Test Strategy**: Generate random decision matrices (3-5 alternatives, 2-4 criteria, varying benefit/cost types) and verify: `calculate(matrix) ≈ calculate(matrix)` for repeated calls.

### Property 2: Normalization Bounds and Direction

*For any alternative with any raw value in a criterion, the normalized value SHALL be in the range [0, 1]. Additionally, for Benefit criteria, higher raw values SHALL normalize to higher normalized values. For Cost criteria, lower raw values SHALL normalize to higher normalized values.*

**Validates**: Requirements 7.3 (normalization step), 16.3

**Rationale**: Normalization is the foundation of SAW. Any violation breaks the algorithm. This property ensures both the mathematical bounds and the directional semantics (more is better for benefits, less for costs) are always respected.

**Test Strategy**: Generate random raw values (0-10000, integers and decimals) for both Benefit and Cost criteria. Verify normalized values fall in [0, 1] and order is preserved: higher raw benefit → higher normalized benefit, lower raw cost → higher normalized cost.

### Property 3: Weighted Score Accumulation

*For any set of normalized values and weights (summing to 100%), the weighted sum of all weighted scores for an alternative SHALL be in the range [0, 1]. When weighted scores are multiplied by 100 for display, final scores SHALL be in range [0, 100].*

**Validates**: Requirements 7.4, 7.5

**Rationale**: Ensures final composite scores stay within the expected 0-100 scale. Any violation indicates a calculation error.

**Test Strategy**: Generate random normalized values and weights. Verify: `∑(normalized[i] × weight[i]) ≤ 1.0` for all alternatives, then verify displayed score `≤ 100`.

### Property 4: Email Validation (RFC 5322)

*For any string matching the RFC 5322 email pattern (user+tag@domain.co.uk format), the email validation SHALL return true. For any string that does not match this pattern, validation SHALL return false.*

**Validates**: Requirements 1.3, 1.4

**Rationale**: Email validation is a gate to account creation. Must be consistent and correct.

**Test Strategy**: Generate valid emails (various TLDs, subdomains, +tags) and invalid emails (missing @, invalid characters, spaces). Verify validation result matches expectation for each.

### Property 5: Password Strength Validation

*For any password containing ≥8 characters, ≥1 uppercase letter, and ≥1 digit, password validation SHALL return true. For any password missing any of these criteria, validation SHALL return false.*

**Validates**: Requirements 1.3, 1.4, 13.1

**Rationale**: Password complexity rules must be uniformly enforced. This property ensures no edge cases slip through.

**Test Strategy**: Generate passwords with combinations of: length ∈ [0, 20], uppercase count ∈ [0, 5], digit count ∈ [0, 5]. Verify validation matches the rules.

### Property 6: Weight Sum Validation

*For any set of criterion weights, if the sum equals 100% (±0.001 tolerance), weight validation SHALL return true and allow calculation. If sum ≠ 100%, validation SHALL return false and block calculation.*

**Validates**: Requirements 6.5, 6.11, 13.5

**Rationale**: SAW algorithm requires weights to sum to 100%. This property ensures the validation gate is never bypassed.

**Test Strategy**: Generate random weight distributions (each weight 0-100). Calculate sum. Verify: if sum ∈ [99.999, 100.001], validation passes; otherwise fails.

### Property 7: Alternative Count Limits - Basic Tier

*For any Basic-tier user with N alternatives already selected, adding an additional alternative SHALL succeed if N < 3, and SHALL fail with an upgrade prompt if N ≥ 3.*

**Validates**: Requirements 4.9, 12.6

**Rationale**: Plan quotas must be enforced uniformly. A Basic-tier user should never be allowed to create a 4-alternative decision.

**Test Strategy**: Simulate Basic-tier user state. For alternatives count 0, 1, 2 → add should succeed. For count 3, 4+ → add should fail. Verify error message prompts upgrade.

### Property 8: Criteria Count Limits - Basic Tier

*For any Basic-tier user with M criteria already selected, adding an additional criterion SHALL succeed if M < 3, and SHALL fail with an upgrade prompt if M ≥ 3.*

**Validates**: Requirements 5.7, 12.6

**Rationale**: Consistent quota enforcement for criteria as for alternatives.

**Test Strategy**: Similar to Property 7, but for criteria. Count 0-2 → success, count 3+ → failure.

### Property 9: Alternative Count Limits - Premium Tier

*For any Premium-tier user with N alternatives already selected, adding an additional alternative SHALL succeed if N < 10, and SHALL fail if N ≥ 10.*

**Validates**: Requirements 4.6, 12.4

**Rationale**: Premium tier has higher limits. Verify different quotas are enforced.

**Test Strategy**: Simulate Premium-tier user. For count 0-9 → success, count 10+ → failure.

### Property 10: Criteria Count Limits - Premium Tier

*For any Premium-tier user with M criteria already selected, adding an additional criterion SHALL succeed if M < 8, and SHALL fail if M ≥ 8.*

**Validates**: Requirements 5.8, 12.4

**Rationale**: Consistent Premium tier enforcement.

**Test Strategy**: For count 0-7 → success, count 8+ → failure.

### Property 11: Decision Save-Retrieve Round-Trip

*For any saved decision with alternatives, criteria, weights, and calculated results, retrieving the decision from storage SHALL return data identical to what was saved (down to floating-point precision).*

**Validates**: Requirements 11.1, 11.2, 11.3

**Rationale**: Ensures no data loss or corruption during persistence. This is a round-trip property: save → retrieve → data equals original.

**Test Strategy**: Create decision with random alternatives, criteria, weights. Save to storage (mock or SQLite). Retrieve and compare all fields. Verify equality.

### Property 12: What-If Simulation Immutability

*For any What-If simulation where weights are adjusted, the original decision object SHALL never be mutated. The original weights and alternatives SHALL remain unchanged after any simulation operations.*

**Validates**: Requirements 10.8, 10.9

**Rationale**: Critical safety property. Users must trust that running a simulation doesn't alter their original decision.

**Test Strategy**: Create decision with original weights. Create simulation and adjust weights. Verify original decision.weights is still equal to initial values (no shallow copy issues).

### Property 13: Comparison View Completeness

*For any decision result with N alternatives and M criteria, the comparison view SHALL display all N × M cells (one for each alternative-criterion pair), with no missing data.*

**Validates**: Requirements 9.2, 9.3, 9.4

**Rationale**: Users must see complete information. Missing cells would indicate a rendering bug.

**Test Strategy**: Generate decisions with varying N ∈ [2, 5] and M ∈ [2, 5]. Build comparison view. Verify cell count equals N × M and all cells have values.

### Property 14: AI Explanation Grounding in Actual Results

*For any AI-generated explanation, the explanation text SHALL reference the top-ranked alternative from the actual SAW calculation. The explanation SHALL NOT recommend an alternative that is not in the top 2 by score.*

**Validates**: Requirements 8.3, 17.4

**Rationale**: AI-generated content must be grounded in reality, not hallucinated. An explanation recommending a 4th-ranked alternative would mislead users.

**Test Strategy**: Generate decision result with known ranking. Generate AI explanation. Parse explanation for alternative names. Verify at least one of top 2 alternatives is mentioned. Verify no low-ranked alternative is promoted.

### Property 15: Confidence-Based Explanation Marking

*For any AI explanation with confidence < 0.5, the UI SHALL display a visual indicator (e.g., "Low confidence") or explanatory note. For any explanation with confidence ≥ 0.5, no low-confidence marking SHALL be present.*

**Validates**: Requirements 8.4, 17.5, 17.6

**Rationale**: Users need transparency about AI certainty. Low-confidence explanations should be visually distinguished.

**Test Strategy**: Generate explanations with confidence values: < 0.5 (should be marked) and ≥ 0.5 (should not be marked). Verify UI marking matches.

### Property 16: Session Expiration State Transition

*For any session with expiration timestamp T, the session.isExpired property SHALL be false before time T, and true after time T. Additionally, session.isExpiringSoon SHALL be true if current time is within 1 hour of T.*

**Validates**: Requirements 1.11, 1.12

**Rationale**: Session management must be reliable. Correct state transitions ensure timely re-authentication.

**Test Strategy**: Create sessions with various expiration times. Check isExpired before, at, and after expiration. Verify state is correct.

### Property 17: Category Selection Enables Subcategory Selection

*For any category selection, after selection, the list of available subcategories for that category SHALL be displayed and non-empty. If category changes, previous subcategory selection SHALL be reset.*

**Validates**: Requirements 3.3, 3.4, 3.7

**Rationale**: UI state should respond correctly to user input. Changing categories should clear old subcategory state.

**Test Strategy**: Select different categories. Verify subcategory list updates and is not empty. Change category and verify previous subcategory is deselected.

### Property 18: Normalized Values Consistency Across Recalculation

*For any alternative's criterion value, if recalculated 1000 times with identical inputs, the normalized value SHALL be identical every time (no floating-point drift over repeated calculations).*

**Validates**: Requirements 16.1, 16.2, 16.8

**Rationale**: Floating-point arithmetic can accumulate errors. This property verifies no drift occurs even with many recalculations.

**Test Strategy**: Pick a specific alternative-criterion pair. Normalize it 1000 times. Verify normalized value is identical each time.

### Property 19: Benefit vs. Cost Criterion Ordering Preservation

*For any criterion marked as Benefit with raw values [v1, v2, v3], if v1 < v2 < v3, then normalized[v1] < normalized[v2] < normalized[v3]. For any criterion marked as Cost, if v1 < v2 < v3, then normalized[v1] > normalized[v2] > normalized[v3] (inverse order).*

**Validates**: Requirements 7.3, 16.3

**Rationale**: Directional semantics must be preserved. A CPU with higher clock speed should normalize to a higher value, not lower.

**Test Strategy**: Generate three ordered values. Normalize as Benefit (check order preserved) and Cost (check order inverted). Verify both directions work correctly.

### Property 20: Zero and Edge Case Handling

*For any normalization scenario where all alternatives have the same raw value for a criterion (e.g., all prices = $1000), the normalized value for each SHALL be 1.0 for Benefit and 1.0 for Cost (since min = max = $1000). The algorithm SHALL not produce NaN, Infinity, or throw an error.*

**Validates**: Requirements 7.1, 16.4, 16.5

**Rationale**: Edge cases must be handled gracefully. No division by zero, no undefined behavior.

**Test Strategy**: Create decision matrices where multiple alternatives have identical values for a criterion. Verify normalization completes without error, producing reasonable values (1.0).

---

## 20. Design Document Sign-Off

**Document Status**: Complete & Ready for Implementation

**Version**: 1.0  
**Date**: January 2025  
**Architecture Pattern**: Clean Architecture + Feature-Oriented Modules  
**State Management**: Provider (ChangeNotifier)  
**Framework**: Flutter/Dart  

**Next Step**: Phase 1 Implementation (App Shell, Design Tokens, Routing Skeleton)

---

This design document is the definitive technical specification for the MyChoice Flutter Frontend. It translates all 17 requirement groups into concrete architectural decisions, making implementation straightforward and maintainable.
