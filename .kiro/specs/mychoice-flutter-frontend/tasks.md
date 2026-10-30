# MyChoice Flutter Frontend - Implementation Task List

## Overview

This task list breaks down the MyChoice Flutter application into actionable implementation phases based on the design document (section 15). Each phase contains concrete, atomic tasks that a developer can complete in 1-2 hours, with clear acceptance criteria, deliverable files, and requirements mapping.

**Implementation Approach**: 
- Each phase is independently testable but dependent on prior phases for full integration
- Domain logic (Phase 2) is implemented first, enabling presentation layers to be built independently
- Property-based testing ensures determinism and correctness of the decision engine
- Mock integrations allow frontend development without backend dependencies

**Requirements Coverage**: All requirements FR-01 through FR-17 are addressed in corresponding phases.

**Test Coverage Target**: 80%+ overall, with 95%+ for decision engine logic.

---

## Phase 0: Reconnaissance

### Objective

Verify Flutter environment, dependencies, directory structure, and basic app launchability before implementation begins.

- [ ] 0.1 Verify Flutter SDK and Dart version
  - Run `flutter --version` and verify Flutter 3.x+, Dart 3.x+
  - Run `dart --version` for Dart SDK verification
  - _Acceptance Criteria_: Output shows Flutter 3.x+ and Dart 3.x+, no errors
  - _Files_: None (verification only)

- [ ] 0.2 Check pubspec.yaml dependencies
  - Verify all required packages are listed: provider, google_fonts, intl, flutter_svg
  - Verify versions match design specifications (provider ^6.1.1, etc.)
  - Check for any conflicting dependency versions
  - _Acceptance Criteria_: No dependency conflicts, `flutter pub get` succeeds without warnings
  - _Files_: `mychoice_app/pubspec.yaml`

- [ ] 0.3 Verify project directory structure
  - Check that `lib/`, `test/`, `assets/` directories exist
  - Confirm subdirectories: `lib/core/`, `lib/features/`, `assets/images/`, `assets/icons/`, `assets/data/`
  - Create missing directories if needed
  - _Acceptance Criteria_: All required directories exist, no errors when running tree command
  - _Files_: Directory structure (no code files)

- [ ] 0.4 Test basic app launch
  - Run `flutter pub get` to resolve dependencies
  - Run `flutter run` on Android emulator or iOS simulator
  - Verify app launches without crashes
  - _Acceptance Criteria_: App launches successfully, no runtime errors, can see either Splash or Login screen
  - _Files_: `mychoice_app/lib/main.dart` (existing)

- [ ] 0.5 Verify Material Design 3 support
  - Check that `useMaterial3: true` is present in theme configuration (pubspec.yaml or main.dart)
  - Launch app and verify Material Design 3 styling is applied (check button shapes, colors)
  - _Acceptance Criteria_: Material Design 3 theme visibly applied, no legacy Material 2 styling present
  - _Files_: `mychoice_app/lib/main.dart`, `mychoice_app/pubspec.yaml`

- [ ] 0.6 Check orientation lock (portrait-only)
  - Run `flutter run` on device/emulator
  - Rotate device and verify app remains in portrait orientation
  - Confirm `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` is in main.dart
  - _Acceptance Criteria_: App locked to portrait, rotation does not change orientation
  - _Files_: `mychoice_app/lib/main.dart`

- [ ] 0.7 Inspect existing screens
  - Review existing placeholder screens (dashboard_screen.dart, create_decision_screen.dart)
  - Check widget_test.dart for any passing tests
  - Document findings of what already exists vs. what needs to be built
  - _Acceptance Criteria_: Document created noting existing code (if any), identified gaps
  - _Files_: `mychoice_app/lib/screens/dashboard/dashboard_screen.dart`, `mychoice_app/lib/screens/decision/create_decision_screen.dart`, `mychoice_app/test/widget_test.dart`

- [ ] 0.8 Test asset loading
  - Verify images exist in `assets/images/` and icons in `assets/icons/`
  - Verify JSON data files exist in `assets/data/` (categories.json, etc.)
  - Test loading a sample asset in a simple widget
  - _Acceptance Criteria_: Assets load without errors, sample image or icon renders correctly
  - _Files_: `mychoice_app/assets/images/`, `mychoice_app/assets/icons/`, `mychoice_app/assets/data/`

- [ ] 0.9 Document reconnaissance findings
  - Create a checklist document (or update FRONTEND_PROGRESS.md) with status of each verification
  - Note any missing dependencies, unresolved issues, or environment problems
  - Recommend next steps for Phase 1
  - _Acceptance Criteria_: Comprehensive checklist completed, all blockers identified and flagged
  - _Files_: `FRONTEND_PROGRESS.md` or similar

---

## Phase 1: App Shell, Design Tokens, Routing Skeleton

### Objective

Establish the foundational design system, theme, routing structure, and reusable UI components that all other phases depend on.

### 1.1 Create Theme & Design Tokens

- [ ] 1.1 Implement app_theme.dart with Material Design 3 colors
  - Define primary (indigo-500), secondary (emerald-500), tertiary (amber-500) colors
  - Define semantic colors: success, warning, error
  - Define neutral colors: surface, background, surfaceVariant
  - Define text colors: onSurface, onSurfaceVariant, onSurfaceDisabled (light mode)
  - Create lightTheme and darkTheme ThemeData with all color scheme properties
  - _Acceptance Criteria_: No compile errors, colors match design spec, theme applies to Material3 widgets
  - _Files_: `lib/core/theme/app_theme.dart`
  - _Requirements_: FR-15 (platform-specific design)

- [ ] 1.2 Implement app_typography.dart with Material Design scale
  - Define Display Large (32px, bold), Heading Large/Medium/Small (28/24/20px)
  - Define Body Large/Medium (16/14px), Caption (12px), Button (16px, semibold)
  - Use Poppins as primary font, Inter as fallback
  - Create TextStyle properties for each scale level with proper line height
  - _Acceptance Criteria_: All text styles defined, no compile errors, styles apply to Text widgets
  - _Files_: `lib/core/theme/app_typography.dart`
  - _Requirements_: FR-15 (typography scale)

- [ ] 1.3 Implement app_spacing.dart with 8px grid tokens
  - Define spacing tokens: xs (4px), sm (8px), md (16px), lg (24px), xl (32px), xxl (48px)
  - Define padding EdgeInsets: paddingSm, paddingMd, paddingLg
  - Define corner radius: radiusSm (4px), radiusMd (8px), radiusLg (12px), radiusXl (16px), radiusFull (999px)
  - Define elevation/shadow: shadowSm (2), shadowMd (4), shadowLg (8)
  - _Acceptance Criteria_: All spacing tokens defined, used consistently in phase 1.4 components
  - _Files_: `lib/core/theme/app_spacing.dart`
  - _Requirements_: FR-15 (responsive layout)

- [ ] 1.4 Create reusable button components
  - Create PrimaryButton widget (elevated, indigo background, white text)
  - Create SecondaryButton widget (outlined, indigo border, indigo text)
  - Create TextButton widget (no background, indigo text, minimal padding)
  - All buttons include hover/tap feedback (opacity change or shadow)
  - All buttons use AppSpacing and AppTheme tokens
  - _Acceptance Criteria_: All 3 button types render correctly, tap feedback visible, use design tokens
  - _Files_: `lib/core/widgets/buttons/primary_button.dart`, `lib/core/widgets/buttons/secondary_button.dart`, `lib/core/widgets/buttons/text_button.dart`
  - _Requirements_: FR-15 (reusable components)

- [ ] 1.5 Create reusable card components
  - Create BaseCard widget (wrapper with shadow, border, borderRadius using AppSpacing)
  - Create DecisionCard widget (extends BaseCard, displays title, progress %, alternatives count)
  - Create CriterionCard widget (extends BaseCard, displays criterion name + type indicator)
  - All cards use AppSpacing padding and AppTheme colors
  - _Acceptance Criteria_: Cards render with proper elevation, spacing, and content layout
  - _Files_: `lib/core/widgets/cards/base_card.dart`, `lib/core/widgets/cards/decision_card.dart`, `lib/core/widgets/cards/criterion_card.dart`
  - _Requirements_: FR-2 (dashboard), FR-5 (criteria)

- [ ] 1.6 Create form input components
  - Create custom TextField widget with validation styling (red border on error, green on valid)
  - Create SliderInput widget (0-100% slider with label, real-time percentage display)
  - Create CheckboxGroup widget (list of items with checkboxes, track selected items)
  - Create RadioGroup widget (single-select list with radio buttons)
  - All inputs use AppTheme colors and AppSpacing for margins/padding
  - _Acceptance Criteria_: All input types render correctly, validation states visible, callbacks work
  - _Files_: `lib/core/widgets/forms/text_field.dart`, `lib/core/widgets/forms/slider_input.dart`, `lib/core/widgets/forms/checkbox_group.dart`, `lib/core/widgets/forms/radio_group.dart`
  - _Requirements_: FR-3, FR-4, FR-5, FR-6 (all form inputs)

- [ ] 1.7 Create loading and error state widgets
  - Create LoadingSpinner widget (centered Flutter CircularProgressIndicator with label)
  - Create SkeletonLoader widget (placeholder shimmer for list items)
  - Create ErrorMessage widget (inline error display with icon + message + retry button)
  - Create EmptyState widget (icon + message + CTA button)
  - _Acceptance Criteria_: All state widgets render correctly, animations smooth (if shimmer)
  - _Files_: `lib/core/widgets/loaders/loading_spinner.dart`, `lib/core/widgets/loaders/skeleton_loader.dart`, `lib/core/widgets/error_states/error_message.dart`, `lib/core/widgets/error_states/empty_state.dart`
  - _Requirements_: FR-2, FR-13 (error handling)

- [ ] 1.8 Create navigation and app bar components
  - Create custom AppBar widget (back button + title + optional action button)
  - Create BottomNavBar widget (5 tabs: Home, Decision, Insight, History, Profile)
  - Implement tab switching logic with Navigator.pushNamed()
  - Persist selected tab index in provider
  - _Acceptance Criteria_: AppBar renders with back button functional, BottomNavBar switches tabs smoothly, tab selection persists
  - _Files_: `lib/core/widgets/navigation/app_bar.dart`, `lib/core/widgets/navigation/bottom_nav_bar.dart`
  - _Requirements_: FR-2 (dashboard navigation)

- [ ] 1.9 Create dialog components
  - Create ConfirmationDialog widget (title, message, yes/no buttons)
  - Create UpgradePromptDialog widget (plan tier info, upgrade CTA)
  - Create ErrorDialog widget (error title, message, retry button)
  - All dialogs use AppTheme colors and proper modal styling
  - _Acceptance Criteria_: All dialogs render correctly, buttons functional, modal dismissible
  - _Files_: `lib/core/widgets/dialogs/confirmation_dialog.dart`, `lib/core/widgets/dialogs/upgrade_prompt.dart`, `lib/core/widgets/dialogs/error_dialog.dart`
  - _Requirements_: FR-12 (access control), FR-13 (error handling)

- [ ] 1.10 Create error exception hierarchy
  - Create base AppException class with message, code, originalError properties
  - Create ValidationError, AuthenticationError, CalculationError, DataMissingError, NetworkError, TimeoutError, PlanLimitExceededException
  - Implement toString() for each exception with descriptive format
  - _Acceptance Criteria_: All exception types compile, can be thrown and caught correctly
  - _Files_: `lib/core/errors/app_exception.dart`, `lib/core/errors/validation_error.dart`, `lib/core/errors/auth_error.dart`, `lib/core/errors/calculation_error.dart`, `lib/core/errors/network_error.dart`
  - _Requirements_: FR-13 (error handling)

- [ ] 1.11 Create error handler utility
  - Create ErrorHandler class with getUserFriendlyMessage(exception) method
  - Map each exception type to user-facing message string
  - Create handleError(context, exception) method to display error dialog
  - _Acceptance Criteria_: Error messages are clear and user-friendly (not technical jargon)
  - _Files_: `lib/core/errors/error_handler.dart`
  - _Requirements_: FR-13 (error handling)

### 1.2 Create Routing Skeleton

- [ ] 1.12 Set up app.dart with routing structure
  - Create app.dart file with MaterialApp configuration
  - Define route map for all screens (auth, dashboard, decision creation, history, profile)
  - Use named routes (e.g., '/login', '/dashboard', '/create-decision')
  - Implement route protection middleware (redirect unauthenticated users to login)
  - _Acceptance Criteria_: No compile errors, routes defined for all major screens
  - _Files_: `lib/app.dart`
  - _Requirements_: FR-2 (navigation)

- [ ] 1.13 Create placeholder screens for all routes
  - Create empty StatelessWidget screens for: SplashScreen, LoginScreen, RegisterScreen, DashboardScreen, CreateDecisionScreen, HistoryScreen, ProfileScreen, ResultScreen
  - Each screen has minimal structure (AppBar + body with placeholder text)
  - All screens return Scaffold with proper appBar and bottomNavigationBar integration
  - _Acceptance Criteria_: All screens compile, can navigate between them using BottomNavBar
  - _Files_: `lib/features/auth/presentation/screens/splash_screen.dart`, `lib/features/auth/presentation/screens/login_screen.dart`, `lib/features/auth/presentation/screens/register_screen.dart`, `lib/features/dashboard/presentation/screens/dashboard_screen.dart`, `lib/features/decision_engine/presentation/screens/result_screen.dart`, `lib/features/decision_history/presentation/screens/history_screen.dart`, `lib/features/profile/presentation/screens/profile_screen.dart`
  - _Requirements_: FR-2, FR-3, FR-1 (all feature screens)

- [ ] 1.14 Implement splash screen with 3-second timer
  - Create SplashScreen with centered logo image
  - Implement AnimationController for fade-in animation (1.5 second duration)
  - After 3 seconds, navigate to onboarding or login based on authentication status
  - _Acceptance Criteria_: Logo animates for 3 seconds, then navigates to next screen smoothly
  - _Files_: `lib/features/auth/presentation/screens/splash_screen.dart`
  - _Requirements_: FR-1.1 (splash screen with animation)

- [ ] 1.15 Create onboarding screens (5 slides)
  - Create OnboardingScreen with PageView of 5 pages
  - Page 1: Welcome (title, subtitle, skip button)
  - Page 2: Understand Needs (explain what criteria are)
  - Page 3: Compare Options (explain alternatives)
  - Page 4: Understand Results (explain SAW ranking)
  - Page 5: Get Started (CTA button to login/register)
  - Add page indicator (dots) at bottom showing current page
  - _Acceptance Criteria_: All 5 pages render, swipe navigation works, page indicator updates, final CTA navigates to login
  - _Files_: `lib/features/auth/presentation/screens/onboarding_screen.dart`
  - _Requirements_: FR-1.1 (onboarding flow)

- [ ] 1.16 Update main.dart with app configuration
  - Set app orientation to portrait-only: `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])`
  - Configure status bar (transparent, dark icons for light mode)
  - Set app to use app.dart (MaterialApp with routing)
  - Configure initial route to splash screen
  - _Acceptance Criteria_: App launches to splash screen, orientation locked to portrait, status bar styled correctly
  - _Files_: `lib/main.dart`
  - _Requirements_: FR-15 (platform configuration)

### 1.3 Create Asset Files

- [ ] 1.17 Set up image and icon assets
  - Create or add splash_logo.png to `assets/images/`
  - Create or add 5 onboarding illustrations to `assets/images/onboarding_*.png`
  - Create or add empty state illustrations to `assets/images/empty_state_*.png`
  - Create 16 SVG icons in `assets/icons/`: category_tech, category_education, category_fashion, criteria_benefit, criteria_cost, icon_plus, icon_delete, icon_check, icon_settings, icon_history, icon_home, icon_compare, icon_whatif, icon_ai, icon_upgrade, icon_info
  - Verify all assets are declared in pubspec.yaml under `flutter.assets`
  - _Acceptance Criteria_: All assets load without errors when referenced in code (test with Image.asset(), SvgPicture.asset())
  - _Files_: `assets/images/`, `assets/icons/`, `pubspec.yaml`
  - _Requirements_: FR-15 (asset management)

- [ ] 1.18 Create data asset files (categories, alternatives catalog)
  - Create `assets/data/categories.json` with structure: { categories: [{ id, name, icon, subcategories: [{ id, name }] }] }
  - Technology: Laptop, Smartphone, Tablet, Monitor, Gaming PC, Processor, Graphics Card
  - Education: Course, Certification, Bootcamp, University, Training Program
  - Fashion: Dress, Shoes, Accessories, Bags, Jewelry, Outerwear
  - Create `assets/data/alternatives_catalog.json` with 15-50 predefined alternatives per subcategory (e.g., laptop models with specs)
  - _Acceptance Criteria_: JSON files are valid, parseable by dart:convert, no syntax errors
  - _Files_: `assets/data/categories.json`, `assets/data/alternatives_catalog.json`
  - _Requirements_: FR-3, FR-4 (category and alternative data)

### 1.4 Code Quality

- [ ] 1.19 Run formatter and analyzer on Phase 1 code
  - Run `dart format lib/core/ lib/features/auth/presentation/screens/ lib/main.dart lib/app.dart`
  - Run `flutter analyze` and fix all warnings (unused imports, deprecated methods, etc.)
  - Verify no compiler errors
  - _Acceptance Criteria_: All code formatted consistently, `flutter analyze` shows zero issues
  - _Files_: All files created in Phase 1
  - _Requirements_: Code quality standard

- [ ] 1.20* (Optional) Run widget tests for theme and routing
  - Create simple widget tests verifying PrimaryButton renders with correct color
  - Create widget test for BottomNavBar tab switching
  - Create widget test for splash screen 3-second delay (mock timer)
  - _Acceptance Criteria_: Tests compile and pass
  - _Files_: `test/core/widgets/buttons/primary_button_test.dart`, `test/core/widgets/navigation/bottom_nav_bar_test.dart`, `test/features/auth/presentation/screens/splash_screen_test.dart`
  - _Requirements_: Testing

---

## Phase 2: Domain Models, SAW Calculator, Validators

### Objective

Implement core business logic (entities, use cases, SAW calculation) that is independent of UI and can be thoroughly unit tested.

### 2.1 Create Domain Entities

- [ ] 2.1 Create User and Session entities
  - Create User class: id, email, name, dateOfBirth, role (enum: guest, basic, premium, admin), plan (UserPlan), createdAt
  - Implement copyWith() for immutability
  - Create Session class: token, refreshToken, expiresAt
  - Implement isExpired and isExpiringSoon getters
  - Create UserRole and UserPlan entities
  - _Acceptance Criteria_: No compile errors, copyWith creates new instances, getters return correct values
  - _Files_: `lib/features/auth/domain/entities/user.dart`, `lib/features/auth/domain/entities/session.dart`, `lib/core/entities/user_plan.dart`
  - _Requirements_: FR-1 (authentication), FR-12 (access control)

- [ ] 2.2 Create Decision, Alternative, Criterion entities
  - Create Alternative class: id, name, source (catalog|custom), catalogId
  - Create Criterion class: id, name, type (benefit|cost), source (suggested|custom|ai_suggested)
  - Create Decision class: id, userId, title, category, subcategory, alternatives[], criteria[], weights{}, matrix, result, status (draft|inProgress|completed), createdAt, completedAt
  - Implement copyWith() for Decision
  - _Acceptance Criteria_: All entities compile, copyWith works for Decision
  - _Files_: `lib/features/alternative_management/domain/entities/alternative.dart`, `lib/features/criteria_selection/domain/entities/criterion.dart`, `lib/features/decision_history/domain/entities/stored_decision.dart`
  - _Requirements_: FR-4 (alternatives), FR-5 (criteria), FR-11 (decision history)

- [ ] 2.3 Create DecisionMatrix entity
  - Create DecisionMatrix class: alternatives[], criteria[], values{altId}{critId} = double
  - Implement getValue(altId, critId), setValue(altId, critId, value), isComplete() methods
  - _Acceptance Criteria_: Matrix methods work correctly, can set and get values
  - _Files_: `lib/features/decision_engine/domain/entities/decision_matrix.dart`
  - _Requirements_: FR-7 (decision engine)

- [ ] 2.4 Create DecisionResult and calculation breakdown entities
  - Create RankedAlternative class: rank, alternative, compositeScore (0-100)
  - Create NormalizedScore class: normalized (0-1), weight (0-1), weighted (normalized × weight)
  - Create CalculationBreakdown class: alternativeId, criteria{critId: NormalizedScore}
  - Create DecisionResult class: ranking[], breakdown{}, algorithmVersion, calculatedAt, config (SAWConfiguration)
  - Create SAWConfiguration class: version, toleranceThreshold, timestamp
  - _Acceptance Criteria_: All entities compile, immutable, properly represent calculation results
  - _Files_: `lib/features/decision_engine/domain/entities/decision_result.dart`, `lib/features/decision_engine/domain/entities/calculation_breakdown.dart`, `lib/features/decision_engine/domain/entities/saw_configuration.dart`
  - _Requirements_: FR-7 (SAW calculation)

### 2.2 Create Exception Hierarchy (completed in Phase 1, skip)

### 2.3 Implement SAW Calculator with Determinism Guarantees

- [ ] 2.5 Create SAWCalculator with deterministic normalization
  - Implement static calculate(matrix, criteriaMap, weights) → DecisionResult
  - Step 1: _normalize(matrix, criteriaMap) - Benefit: raw/MAX, Cost: MIN/raw
  - Verify all normalized values are in [0, 1]
  - Handle edge cases (all same values, zero values)
  - Use clampToDecimal(3) to limit floating-point precision
  - _Acceptance Criteria_: Normalization produces correct values for benefit and cost criteria, deterministic output
  - _Files_: `lib/features/decision_engine/data/datasources/saw_calculator.dart`
  - _Requirements_: FR-7, FR-16 (deterministic calculation)

- [ ] 2.6 Implement weight application in SAWCalculator
  - Implement _applyWeights(normalized, weights) - multiply normalized[alt][crit] × (weight[crit] / 100)
  - Use clampToDecimal(4) for weighted values
  - _Acceptance Criteria_: Weighted scores calculated correctly, sum of weighted scores per alternative ≤ 1.0
  - _Files_: `lib/features/decision_engine/data/datasources/saw_calculator.dart`
  - _Requirements_: FR-7 (weight application)

- [ ] 2.7 Implement SAW ranking and calculation breakdown
  - Implement _sumScores(weighted) - sum all weighted scores per alternative, multiply by 100 for 0-100 scale
  - Implement _rankAlternatives(scores, alternatives) - sort by score descending, create RankedAlternative list
  - Implement _buildBreakdown() - create detailed breakdown for each alternative with normalized, weight, weighted values
  - _Acceptance Criteria_: Ranking order correct (highest score first), breakdown complete with all values
  - _Files_: `lib/features/decision_engine/data/datasources/saw_calculator.dart`
  - _Requirements_: FR-7 (ranking)

- [ ] 2.8 Create DoubleRounding extension for decimal precision
  - Implement clampToDecimal(places) extension on double
  - Use: (value * 10^places).round() / 10^places
  - _Acceptance Criteria_: Rounding works correctly for all decimal places (2, 3, 4 digits)
  - _Files_: `lib/features/decision_engine/data/datasources/saw_calculator.dart`
  - _Requirements_: FR-16 (precision guarantee)

### 2.4 Property-Based Tests for SAW Determinism

- [ ] 2.9 Write property test: SAW Calculation Determinism (Property 1)
  - **Property 1: SAW Calculation Determinism**
  - Generate random decision matrices (3-5 alternatives, 2-4 criteria, random values 0-1000)
  - Run calculate(matrix) twice and verify results are identical (same ranking, same scores ±0.001)
  - Test across 50+ generated matrices
  - _Acceptance Criteria_: All 50+ test cases pass, results deterministic
  - _Files_: `test/features/decision_engine/saw_calculator_test.dart`
  - _Requirements_: FR-16 (determinism)

- [ ] 2.10 Write property test: Normalization Bounds and Direction (Property 2)
  - **Property 2: Normalization Bounds and Direction**
  - For Benefit criteria: verify normalized ∈ [0, 1] and higher raw → higher normalized
  - For Cost criteria: verify normalized ∈ [0, 1] and lower raw → higher normalized
  - Test across 100+ combinations of values
  - _Acceptance Criteria_: All bounds checks pass, direction always correct
  - _Files_: `test/features/decision_engine/saw_calculator_test.dart`
  - _Requirements_: FR-7, FR-16 (normalization)

- [ ] 2.11 Write property test: Weighted Score Accumulation (Property 3)
  - **Property 3: Weighted Score Accumulation**
  - Generate random normalized values and weights (summing to 100%)
  - Verify final composite score is in [0, 100] for display
  - Test across 100+ weight distributions
  - _Acceptance Criteria_: All composite scores within [0, 100], no overflow errors
  - _Files_: `test/features/decision_engine/saw_calculator_test.dart`
  - _Requirements_: FR-7 (score range)

- [ ] 2.12 Write property test: Normalized Values Consistency Across Recalculation (Property 18)
  - **Property 18: Normalized Values Consistency**
  - Pick a specific alternative-criterion pair with fixed value
  - Normalize it 1000 times sequentially
  - Verify normalized value is identical each time (no floating-point drift)
  - _Acceptance Criteria_: 1000 recalculations produce identical result
  - _Files_: `test/features/decision_engine/saw_calculator_test.dart`
  - _Requirements_: FR-16 (determinism precision)

- [ ] 2.13 Write property test: Benefit vs. Cost Criterion Ordering (Property 19)
  - **Property 19: Benefit vs. Cost Criterion Ordering Preservation**
  - For Benefit criteria with ordered values v1 < v2 < v3, verify normalized[v1] < normalized[v2] < normalized[v3]
  - For Cost criteria with ordered values v1 < v2 < v3, verify normalized[v1] > normalized[v2] > normalized[v3]
  - Test 50+ combinations
  - _Acceptance Criteria_: All ordering relationships preserved correctly
  - _Files_: `test/features/decision_engine/saw_calculator_test.dart`
  - _Requirements_: FR-16 (ordering semantics)

### 2.5 Create Validation Use Cases

- [ ] 2.14 Create email validation with RFC 5322 regex
  - Implement isValidEmail(email) using RFC 5322 pattern: `r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'`
  - Create unit tests for valid emails (various TLDs, +tags, subdomains) and invalid emails
  - _Acceptance Criteria_: Valid emails pass, invalid emails fail, regex is RFC 5322 compliant
  - _Files_: `lib/core/validators/validation_rules.dart`, `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-1 (email validation), FR-13 (validation)

- [ ] 2.15 Create password strength validation
  - Implement isStrongPassword(password): requires ≥8 chars, ≥1 uppercase, ≥1 digit
  - Create unit tests for passwords meeting/failing criteria
  - _Acceptance Criteria_: Strong passwords pass, weak passwords fail
  - _Files_: `lib/core/validators/validation_rules.dart`, `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-1 (password complexity), FR-13 (validation)

- [ ] 2.16 Create alternative count validation
  - Create validateAlternatives(alts[], userPlan) → ValidationResult
  - Check: alts.length ≥ 2 and alts.length ≤ plan.maxAlternativesPerDecision
  - _Acceptance Criteria_: Validation errors for <2 or >max alternatives
  - _Files_: `lib/core/validators/validation_rules.dart`, `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-4 (alternative count), FR-12 (plan limits)

- [ ] 2.17 Create criteria count validation
  - Create validateCriteria(criteria[], userPlan) → ValidationResult
  - Check: criteria.length ≥ 1 and criteria.length ≤ plan.maxCriteriaPerDecision
  - _Acceptance Criteria_: Validation errors for <1 or >max criteria
  - _Files_: `lib/core/validators/validation_rules.dart`, `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-5 (criteria count), FR-12 (plan limits)

- [ ] 2.18 Create weight sum validation
  - Create validateWeights(weights{}) → ValidationResult
  - Check: sum of all weights = 100% (±0.001 tolerance)
  - Create unit tests for various weight distributions
  - _Acceptance Criteria_: Weights summing to 100% pass, others fail
  - _Files_: `lib/core/validators/validation_rules.dart`, `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-6 (weight validation), FR-13

### 2.6 Property-Based Tests for Validators

- [ ] 2.19 Write property test: Email Validation RFC 5322 (Property 4)
  - **Property 4: Email Validation (RFC 5322)**
  - Generate valid emails: various TLDs (.com, .co.uk, .io), +tags, subdomains
  - Generate invalid emails: no @, multiple @, missing TLD, spaces
  - Verify validation result matches expected outcome for 100+ generated emails
  - _Acceptance Criteria_: All 100+ test cases correct, no false positives/negatives
  - _Files_: `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-1, FR-13

- [ ] 2.20 Write property test: Password Strength Validation (Property 5)
  - **Property 5: Password Strength Validation**
  - Generate passwords with combinations: length ∈ [0, 20], uppercase ∈ [0, 5], digits ∈ [0, 5]
  - Verify validation result matches rules (8+ chars, ≥1 uppercase, ≥1 digit)
  - Test 100+ combinations
  - _Acceptance Criteria_: All combinations validated correctly
  - _Files_: `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-1, FR-13

- [ ] 2.21 Write property test: Weight Sum Validation (Property 6)
  - **Property 6: Weight Sum Validation**
  - Generate random weight distributions (each weight 0-100)
  - Calculate sum and verify: if sum ∈ [99.999, 100.001], validation passes; else fails
  - Test 100+ distributions
  - _Acceptance Criteria_: Tolerance-based validation correct for all distributions
  - _Files_: `test/core/validators/validation_rules_test.dart`
  - _Requirements_: FR-6, FR-13

### 2.7 Create Plan Policy Engine

- [ ] 2.22 Create PlanPolicy class with quota enforcement
  - Create PlanPolicy class: maxAlternativesPerDecision, maxCriteriaPerDecision, maxDecisionsPerMonth, maxWhatIfSimulations, hasAIExplanations
  - Implement canAddAlternative(count), canAddCriterion(count), canCreateDecision(count), canCreateWhatIf(count), hasAIFeatures()
  - Create static UserPlan.basic() and UserPlan.premium() factory methods with correct quotas
  - _Acceptance Criteria_: Basic plan: 3 alts, 3 criteria, 5 decisions/month, 1 what-if. Premium: 10 alts, 8 criteria, unlimited decisions, unlimited what-ifs
  - _Files_: `lib/features/access_control/domain/entities/plan_policy.dart`
  - _Requirements_: FR-12 (access control, plan limits)

- [ ] 2.23 Write property tests: Alternative & Criteria Count Limits (Properties 7-10)
  - **Property 7-10: Quota Enforcement (Basic & Premium tiers)**
  - For Basic: verify can add alternatives/criteria while count < limit, fails when ≥ limit
  - For Premium: verify higher limits enforced correctly
  - Test for both alternatives and criteria
  - Test 50+ combinations of counts and tiers
  - _Acceptance Criteria_: All quota checks enforce correct limits for each tier
  - _Files_: `test/features/access_control/plan_policy_test.dart`
  - _Requirements_: FR-12 (plan limits)

### 2.8 Code Quality & Test Coverage

- [ ] 2.24 Run formatter and analyzer on Phase 2 code
  - Run `dart format lib/features/*/domain/ lib/core/validators/ lib/features/decision_engine/data/`
  - Run `flutter analyze` and fix all warnings
  - _Acceptance Criteria_: Zero format violations, zero analyzer warnings
  - _Files_: All Phase 2 files
  - _Requirements_: Code quality

- [ ] 2.25 Verify test coverage ≥90% for decision engine and validators
  - Run `flutter test test/features/decision_engine/ test/core/validators/ --coverage`
  - Generate coverage report and verify ≥90% line coverage
  - Flag any untested code paths and add tests if needed
  - _Acceptance Criteria_: Coverage report shows ≥90% for decision engine and validators
  - _Files_: `coverage/lcov.info` (generated)
  - _Requirements_: Test coverage

- [ ] 2.26 Checkpoint - Ensure all Phase 2 tests pass
  - Run full test suite: `flutter test test/features/decision_engine/ test/core/validators/ test/features/access_control/`
  - Verify all unit tests pass (100+ tests)
  - Verify no compilation errors or warnings
  - _Acceptance Criteria_: All tests pass, no errors, console output clean
  - _Files_: Test output log (for reference)
  - _Requirements_: Quality checkpoint

---

## Phase 3: Authentication & Public Pages

### Objective

Implement authentication flow, mock auth provider, and public-facing screens (splash, onboarding, login, register, guest home, catalog).

### 3.1 Create Auth Repository & Mock Datasource

- [ ] 3.1 Create AuthRepository interface
  - Define interface methods: login(email, password), register(data), logout(), refreshToken(token), getStoredSession()
  - Create AuthResult class: user, session
  - _Acceptance Criteria_: Interface compiles, all methods defined
  - _Files_: `lib/features/auth/domain/repositories/auth_repository.dart`
  - _Requirements_: FR-1 (authentication)

- [ ] 3.2 Create mock AuthDataSource
  - Implement MockAuthDataSource: login() returns dummy user + session token
  - Accept any email/password (no validation at datasource level)
  - Return hardcoded session with expiresAt = now + 24 hours
  - _Acceptance Criteria_: Mock login succeeds with any credentials, returns valid session
  - _Files_: `lib/features/auth/data/datasources/mock_auth_datasource.dart`
  - _Requirements_: FR-1 (mock auth for Phase 1-2 development)

- [ ] 3.3 Create AuthRepositoryImpl
  - Implement AuthRepository using MockAuthDataSource
  - Implement login(), register(), logout(), refreshToken(), getStoredSession()
  - All methods use mock datasource for now
  - _Acceptance Criteria_: All repository methods work, return expected types
  - _Files_: `lib/features/auth/data/repositories/auth_repository_impl.dart`
  - _Requirements_: FR-1 (auth repository)

### 3.2 Create Auth Provider (State Management)

- [ ] 3.4 Create AuthProvider with ChangeNotifier
  - Create AuthProvider class extending ChangeNotifier
  - Properties: _user (User?), _session (Session?), _state (AuthState enum), _error (String?)
  - Implement getters: user, session, state, isAuthenticated, error
  - _Acceptance Criteria_: Provider initializes correctly, state transitions work
  - _Files_: `lib/features/auth/presentation/providers/auth_provider.dart`
  - _Requirements_: FR-1 (state management)

- [ ] 3.5 Create login() method in AuthProvider
  - Implement login(email, password) async method
  - Set state to AuthState.loading before calling repository
  - Call repository.login(email, password)
  - On success: set user, session, state = authenticated, clear error
  - On error: set state = error, set error message, keep user null
  - Call notifyListeners() after each state change
  - _Acceptance Criteria_: login works with mock auth, state changes properly, errors handled
  - _Files_: `lib/features/auth/presentation/providers/auth_provider.dart`
  - _Requirements_: FR-1 (authentication)

- [ ] 3.6 Create register() method in AuthProvider
  - Similar to login(), but calls repository.register(registrationData)
  - RegistrationData includes: email, password, name, dateOfBirth
  - _Acceptance Criteria_: register works, user created with all fields
  - _Files_: `lib/features/auth/presentation/providers/auth_provider.dart`
  - _Requirements_: FR-1 (registration)

- [ ] 3.7 Create logout() method in AuthProvider
  - Call repository.logout() to clear session
  - Set state = unauthenticated, clear user and session
  - Call notifyListeners()
  - _Acceptance Criteria_: logout clears all auth state
  - _Files_: `lib/features/auth/presentation/providers/auth_provider.dart`
  - _Requirements_: FR-1 (logout)

### 3.3 Create Authentication UI Screens

- [ ] 3.8 Create custom email input widget with RFC 5322 validation
  - Create EmailField widget: TextField with real-time validation
  - Show error icon/message if email format invalid
  - Show checkmark if email valid
  - _Acceptance Criteria_: Validation displays real-time, valid emails show check, invalid show error
  - _Files_: `lib/features/auth/presentation/widgets/email_field.dart`
  - _Requirements_: FR-1 (email validation)

- [ ] 3.9 Create custom password input widget with visibility toggle
  - Create PasswordField widget: TextField with show/hide password toggle
  - Show strength indicator (weak/medium/strong) if focused
  - _Acceptance Criteria_: Password visible when toggle enabled, strength indicator shows
  - _Files_: `lib/features/auth/presentation/widgets/password_field.dart`
  - _Requirements_: FR-1 (password input)

- [ ] 3.10 Implement Login Screen
  - Create LoginScreen with email and password inputs
  - Add "Forgot Password?" link (placeholder navigation)
  - Add "Sign Up" link to navigate to RegisterScreen
  - Implement "Sign In" button that calls authProvider.login()
  - Show loading spinner while authentication in progress
  - Show error message if login fails (invalid credentials)
  - Navigate to DashboardScreen on success
  - _Acceptance Criteria_: Login form works with mock auth, validation shows errors, success navigates to dashboard
  - _Files_: `lib/features/auth/presentation/screens/login_screen.dart`
  - _Requirements_: FR-1 (login), FR-13 (validation)

- [ ] 3.11 Implement Register Screen
  - Create RegisterScreen with email, password, name, dateOfBirth fields
  - Add validation for all fields (email format, password strength, name not empty)
  - Implement "Create Account" button that calls authProvider.register()
  - Show loading spinner and error messages
  - Navigate to LoginScreen after successful registration with success message
  - _Acceptance Criteria_: Registration form validates all fields, creates user on success, navigates to login
  - _Files_: `lib/features/auth/presentation/screens/register_screen.dart`
  - _Requirements_: FR-1 (registration), FR-13 (validation)

- [ ] 3.12 Implement Forgot Password flow (placeholder)
  - Create ForgotPasswordScreen with email input
  - Button to send reset email (placeholder - no actual email sent)
  - Show message: "Check your email for password reset link" (mock)
  - Link back to LoginScreen
  - _Acceptance Criteria_: Screen renders, buttons functional, navigates correctly
  - _Files_: `lib/features/auth/presentation/screens/forgot_password_screen.dart`
  - _Requirements_: FR-1 (password reset - placeholder)

### 3.4 Create Public Pages (Guest User)

- [ ] 3.13 Create Guest Home Screen (catalog preview)
  - Create GuestHomeScreen with message: "Sign in or create an account to get started"
  - Display scrollable list of featured decisions (mock data: 3-5 examples)
  - Add prominent "Sign In" and "Create Account" buttons
  - _Acceptance Criteria_: Screen renders, buttons navigate to login/register
  - _Files_: `lib/features/dashboard/presentation/screens/guest_home_screen.dart`
  - _Requirements_: FR-1 (guest access)

- [ ] 3.14 Create Public Catalog Screen (categories & search)
  - Create PublicCatalogScreen showing all 3 categories (Technology, Education, Fashion)
  - Each category card shows icon, name, subcategory count
  - Add search field (placeholder - no actual search)
  - Tapping category navigates to CatalogItemDetail showing 5 sample subcategories
  - _Acceptance Criteria_: Categories display, search field renders, tap navigates
  - _Files_: `lib/features/category_selection/presentation/screens/public_catalog_screen.dart`
  - _Requirements_: FR-3 (category selection - public)

- [ ] 3.15 Create Catalog Item Detail Screen
  - Create CatalogItemDetailScreen showing subcategory details
  - Display 15-30 sample alternatives for selected subcategory (e.g., laptop models)
  - Show alternative name, key specs, image/icon
  - Add "Learn More" buttons (placeholder navigation to app features)
  - _Acceptance Criteria_: Subcategory details render, alternative list displays
  - _Files_: `lib/features/category_selection/presentation/screens/catalog_item_detail_screen.dart`
  - _Requirements_: FR-3 (subcategory browsing)

### 3.5 Create Category Repository & Mock Datasource

- [ ] 3.16 Create CategoryRepository interface
  - Define interface methods: getCategories(), getSubcategories(categoryId)
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/category_selection/domain/repositories/category_repository.dart`
  - _Requirements_: FR-3 (category data)

- [ ] 3.17 Create mock CategoryDataSource (load from assets)
  - Implement MockCategoryDataSource: loads categories.json from assets
  - Parse JSON and return Category objects
  - _Acceptance Criteria_: Categories load from assets without errors
  - _Files_: `lib/features/category_selection/data/datasources/category_datasource.dart`
  - _Requirements_: FR-3 (category loading)

- [ ] 3.18 Create CategoryRepositoryImpl
  - Implement CategoryRepository using MockCategoryDataSource
  - _Acceptance Criteria_: Repository methods return correct category data
  - _Files_: `lib/features/category_selection/data/repositories/category_repository_impl.dart`
  - _Requirements_: FR-3 (category repository)

- [ ] 3.19 Create CategoryProvider for state management
  - Create CategoryProvider extending ChangeNotifier
  - Properties: _categories, _selectedCategory, _selectedSubcategory
  - Implement selectCategory(), selectSubcategory(), loadCategories()
  - _Acceptance Criteria_: Provider manages category selection state
  - _Files_: `lib/features/category_selection/presentation/providers/category_provider.dart`
  - _Requirements_: FR-3 (category state)

### 3.6 Create Authentication Gate & Navigation

- [ ] 3.20 Create AuthenticationGateDialog
  - Create dialog displayed when unauthenticated user tries to access protected feature
  - Show message: "Sign in to create decisions and save your progress"
  - Buttons: "Sign In" (navigate to login), "Create Account" (navigate to register), "Cancel"
  - _Acceptance Criteria_: Dialog renders, buttons navigate correctly
  - _Files_: `lib/features/auth/presentation/widgets/authentication_gate_dialog.dart`
  - _Requirements_: FR-1 (auth gate)

- [ ] 3.21 Update routing to protect authenticated screens
  - Modify app.dart to check AuthProvider.isAuthenticated before allowing navigation to protected routes
  - If unauthenticated and user tries to access DashboardScreen, CreateDecisionScreen, etc., show AuthenticationGateDialog
  - _Acceptance Criteria_: Protected routes require authentication, unauthenticated users see gate
  - _Files_: `lib/app.dart`
  - _Requirements_: FR-1 (route protection)

### 3.7 Testing

- [ ] 3.22 Write widget tests for login/register validation
  - Test LoginScreen: invalid email shows error, valid credentials submit
  - Test RegisterScreen: password validation, email validation, all fields required
  - Test error display on failed login/register
  - _Acceptance Criteria_: All validation tests pass
  - _Files_: `test/features/auth/presentation/screens/login_screen_test.dart`, `test/features/auth/presentation/screens/register_screen_test.dart`
  - _Requirements_: FR-1, FR-13 (testing)

- [ ] 3.23 Write widget tests for navigation after authentication
  - Test that successful login navigates to DashboardScreen
  - Test that successful registration navigates to LoginScreen
  - Test that unauthenticated user can navigate to GuestHomeScreen
  - _Acceptance Criteria_: Navigation tests pass
  - _Files_: `test/features/auth/presentation/navigation_test.dart`
  - _Requirements_: FR-2 (navigation)

- [ ] 3.24 Checkpoint - Auth flow works end-to-end
  - Launch app, verify splash screen displays for 3 seconds
  - Verify unauthenticated user can access login, register, guest home
  - Verify login with mock credentials works
  - Verify unauthenticated user cannot access dashboard (redirected to login)
  - _Acceptance Criteria_: All auth flows work, no crashes, navigation smooth
  - _Files_: Checklist of verified flows

---

## Phase 4: Decision Creation - Categories & Alternatives

### Objective

Implement category selection and alternative management screens with quota enforcement.

### 4.1 Create Category Selection Screen

- [ ] 4.1 Implement Category Selection Screen
  - Display 3 category cards (Technology, Education, Fashion)
  - Each card shows icon and name
  - Tapping a category highlights it and displays subcategories below
  - Subcategories displayed as interactive chips (radio-like pattern)
  - Tapping a subcategory loads relevant alternatives (displayed in next screen)
  - "Next" button enabled only when both category and subcategory selected
  - "Back" button navigates to DashboardScreen
  - _Acceptance Criteria_: Categories and subcategories render, selection state visible, navigation to next step works
  - _Files_: `lib/features/category_selection/presentation/screens/category_selection_screen.dart`
  - _Requirements_: FR-3 (category selection)

- [ ] 4.2 Create alternative repository interface
  - Define interface methods: getCatalogAlternatives(subcategoryId), validateCount(count, plan)
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/alternative_management/domain/repositories/alternative_repository.dart`
  - _Requirements_: FR-4 (alternatives)

- [ ] 4.3 Create mock AlternativeDataSource (load from assets)
  - Implement MockAlternativeDataSource: loads alternatives_catalog.json
  - Returns 15-50 alternatives per subcategory with name, brand, specs
  - _Acceptance Criteria_: Alternatives load from assets correctly
  - _Files_: `lib/features/alternative_management/data/datasources/alternative_datasource.dart`
  - _Requirements_: FR-4 (alternative loading)

- [ ] 4.4 Create AlternativeRepositoryImpl
  - Implement interface using MockAlternativeDataSource
  - _Acceptance Criteria_: Repository returns alternatives correctly
  - _Files_: `lib/features/alternative_management/data/repositories/alternative_repository_impl.dart`
  - _Requirements_: FR-4

### 4.2 Create Alternative Management Screen

- [ ] 4.5 Create AlternativeProvider for state management
  - Properties: _selectedAlternatives[], _catalogMode (bool), _customAlternatives[]
  - Methods: addAlternative(alt), removeAlternative(alt), toggleMode(), getAlternativeCount()
  - Check plan limits before allowing add (throw PlanLimitExceededException)
  - _Acceptance Criteria_: Provider manages alternative selection, quota enforcement works
  - _Files_: `lib/features/alternative_management/presentation/providers/alternative_provider.dart`
  - _Requirements_: FR-4 (alternative state)

- [ ] 4.6 Create AddAlternativeUseCase with quota enforcement
  - Inject AlternativeRepository and AccessControlProvider
  - call(alternative) checks if canAddAlternative() before adding
  - Throws PlanLimitExceededException if limit exceeded
  - _Acceptance Criteria_: Quota enforced, exception thrown correctly
  - _Files_: `lib/features/alternative_management/domain/usecases/add_alternative_usecase.dart`
  - _Requirements_: FR-4, FR-12 (plan enforcement)

- [ ] 4.7 Implement Alternative Management Screen (Catalog Mode)
  - Display list of 15-30 predefined alternatives from selected subcategory
  - Each alternative card shows: name, brand, key specs (price, processor, etc.)
  - Add button changes to "Added" (disabled) when selected
  - "Selected Options" section shows all added alternatives with delete (X) button
  - Count badge shows "Options Compared: N"
  - "Next" button enabled when 2-N alternatives selected (based on plan)
  - _Acceptance Criteria_: Catalog displays, add/remove works, count updates, quota enforced
  - _Files_: `lib/features/alternative_management/presentation/screens/alternative_management_screen.dart`
  - _Requirements_: FR-4 (catalog mode)

- [ ] 4.8 Implement Alternative Management Screen (Custom Mode)
  - Toggle between Catalog and Custom mode
  - Custom mode shows TextField to enter custom alternative name
  - User can add up to plan limit (3 for Basic, 10 for Premium)
  - Each custom alternative added shows in "Selected Options" list
  - _Acceptance Criteria_: Custom mode allows text entry, quota enforced, alternatives display
  - _Files_: `lib/features/alternative_management/presentation/screens/alternative_management_screen.dart`
  - _Requirements_: FR-4 (custom mode)

- [ ] 4.9 Implement upgrade prompt for Basic tier limits
  - When Basic user attempts to add 4th alternative, display UpgradePromptDialog
  - Message: "Upgrade to Premium for unlimited alternatives (max 3 on Basic plan)"
  - Button to upgrade (placeholder navigation) or cancel
  - _Acceptance Criteria_: Prompt appears, buttons functional
  - _Files_: `lib/features/alternative_management/presentation/screens/alternative_management_screen.dart`
  - _Requirements_: FR-4, FR-12 (upgrade prompt)

- [ ] 4.10 Test AddAlternativeUseCase quota checking
  - Unit tests verifying: Basic plan allows 3 alts, Premium 10, adding beyond limit throws exception
  - _Acceptance Criteria_: Tests pass, quota checked correctly
  - _Files_: `test/features/alternative_management/domain/usecases/add_alternative_usecase_test.dart`
  - _Requirements_: FR-4, FR-12 (testing)

### 4.3 Create Access Control Provider

- [ ] 4.11 Create AccessControlProvider for plan enforcement
  - Inject UserProvider to get current user and plan
  - Implement methods: canAddAlternative(count), canAddCriterion(count), canCreateDecision(), canCreateWhatIf()
  - Return boolean and optional quota message
  - _Acceptance Criteria_: Provider checks plan correctly, messages are user-friendly
  - _Files_: `lib/features/access_control/presentation/providers/access_control_provider.dart`
  - _Requirements_: FR-12 (access control)

### 4.4 Testing

- [ ] 4.12 Write widget tests for category selection
  - Test that tapping category displays subcategories
  - Test that changing category resets subcategory selection
  - Test that "Next" button disabled until both category and subcategory selected
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/category_selection/presentation/screens/category_selection_screen_test.dart`
  - _Requirements_: FR-3 (testing)

- [ ] 4.13 Write widget tests for alternative limit enforcement
  - Test Basic user cannot add 4th alternative (prompt shown)
  - Test Premium user can add up to 10 alternatives
  - Test delete removes alternative and count updates
  - _Acceptance Criteria_: All tests pass, quota enforcement verified
  - _Files_: `test/features/alternative_management/presentation/screens/alternative_management_screen_test.dart`
  - _Requirements_: FR-4, FR-12 (testing)

- [ ] 4.14 Checkpoint - Category and Alternative selection works
  - Launch app, login, tap "Create Decision"
  - Verify category selection screen appears, can select category + subcategory
  - Verify alternative management screen appears with catalog
  - Verify can add/remove alternatives, count updates
  - Verify quota limit enforced (for Basic user, cannot add 4th)
  - _Acceptance Criteria_: Full flow works end-to-end
  - _Files_: Checklist

---

## Phase 5: Criteria Selection & Priorities

### Objective

Implement criteria selection and priority weighting screens with validation.

### 5.1 Create Criteria Selection Screen

- [ ] 5.1 Create criteria repository interface
  - Define interface methods: getSuggestedCriteria(subcategoryId), validateCount(count, plan)
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/criteria_selection/domain/repositories/criteria_repository.dart`
  - _Requirements_: FR-5 (criteria)

- [ ] 5.2 Create mock CriteriaDataSource (suggested criteria)
  - Implement MockCriteriaDataSource: returns suggested criteria for each subcategory
  - Criteria for "Laptop": Price (Cost), RAM (Benefit), Storage (Benefit), Processor Speed (Benefit), Battery Life (Benefit), Weight (Cost)
  - Each criterion marked as Benefit or Cost
  - _Acceptance Criteria_: Suggested criteria returned correctly
  - _Files_: `lib/features/criteria_selection/data/datasources/criteria_datasource.dart`
  - _Requirements_: FR-5 (criteria suggestions)

- [ ] 5.3 Create CriteriaisDataSource
  - Implement interface using MockCriteriaDataSource
  - _Acceptance Criteria_: Repository returns criteria
  - _Files_: `lib/features/criteria_selection/data/repositories/criteria_repository_impl.dart`
  - _Requirements_: FR-5

- [ ] 5.4 Create CriteriaProvider for state management
  - Properties: _selectedCriteria[], _aiSuggestionsState (none|loading|loaded|error)
  - Methods: selectCriterion(crit), deselectCriterion(crit), addCustomCriterion(name, type), fetchAISuggestions()
  - Check plan limits before allowing add (throw PlanLimitExceededException)
  - _Acceptance Criteria_: Provider manages criteria selection, quota enforcement works
  - _Files_: `lib/features/criteria_selection/presentation/providers/criteria_provider.dart`
  - _Requirements_: FR-5 (criteria state)

- [ ] 5.5 Implement Criteria Selection Screen
  - Display suggested criteria as checkboxes (name + type indicator: Benefit or Cost)
  - User selects/deselects criteria by tapping checkboxes
  - "Selected Criteria" count badge updates in real-time
  - "+ Add Custom Criterion" button opens inline form
  - Custom form has: TextField for criterion name, radio buttons for Benefit/Cost
  - "AI Suggest Criteria" button (Premium only) - placeholder calls fetchAISuggestions()
  - "Next" button enabled when ≥1 criterion selected (based on plan limits)
  - "Back" button navigates to Alternative Management
  - _Acceptance Criteria_: Criteria display, selection works, custom criteria can be added, AI button present
  - _Files_: `lib/features/criteria_selection/presentation/screens/criteria_selection_screen.dart`
  - _Requirements_: FR-5 (criteria selection)

- [ ] 5.6 Implement quota enforcement for criteria
  - Basic plan: max 3 criteria
  - Premium plan: max 8 criteria
  - When limit reached, disable add button and show upgrade prompt
  - _Acceptance Criteria_: Quota enforced correctly for both tiers
  - _Files_: `lib/features/criteria_selection/presentation/screens/criteria_selection_screen.dart`
  - _Requirements_: FR-5, FR-12 (quota enforcement)

- [ ] 5.7 Implement AI Suggestion button (placeholder)
  - When "AI Suggest Criteria" tapped, show loading spinner
  - After 1-2 seconds, display mock AI suggestions: [{"Processor Speed": 0.9}, {"Graphics": 0.85}, ...]
  - Each suggestion shows confidence score
  - User can tap to add suggested criteria or dismiss
  - _Acceptance Criteria_: Button functional, mock suggestions display, can add suggestions
  - _Files_: `lib/features/criteria_selection/presentation/screens/criteria_selection_screen.dart`
  - _Requirements_: FR-5 (AI suggestions placeholder)

### 5.2 Create Priority Setting Screen

- [ ] 5.8 Create PriorityProvider for state management
  - Properties: _weights{criterionId: weight (0-100)}, _totalWeight
  - Methods: setWeight(critId, weight), autoBalance(), getWeightSum()
  - Auto-balance: proportionally rescale weights to sum to 100%
  - Notify listeners on each weight change
  - _Acceptance Criteria_: Provider manages weights, auto-balance works, total sum accurate
  - _Files_: `lib/features/priority_setting/presentation/providers/priority_provider.dart`
  - _Requirements_: FR-6 (priorities)

- [ ] 5.9 Create weight slider component with real-time label
  - Create WeightSlider widget: horizontal slider 0-100% with live label
  - Label shows current percentage (e.g., "30%")
  - Slider uses AppTheme primary color
  - On change, calls provider.setWeight()
  - _Acceptance Criteria_: Slider renders, label updates in real-time, onChange callback works
  - _Files_: `lib/core/widgets/forms/weight_slider.dart`
  - _Requirements_: FR-6 (weight input)

- [ ] 5.10 Create total weight indicator widget
  - Create TotalWeightIndicator widget showing cumulative weight (e.g., "92%")
  - Background color: Green if total = 100%, Red if total ≠ 100%
  - Font color: black on both backgrounds for contrast
  - _Acceptance Criteria_: Color indicates validation state, updates in real-time
  - _Files_: `lib/core/widgets/forms/total_weight_indicator.dart`
  - _Requirements_: FR-6 (weight validation)

- [ ] 5.11 Implement Priority Input Screen
  - Display each selected criterion with WeightSlider (0-100%)
  - Display TotalWeightIndicator below sliders
  - Display instructions: "Set importance for each criterion. Total must equal 100%"
  - "Auto-Balance" button: proportionally rescales weights to 100%
  - "Calculate Result" button enabled only when total = 100%
  - "Calculate Result" button calls decision engine to calculate SAW
  - Show loading spinner while calculating
  - Navigate to Result Screen on success
  - Show error message on calculation failure
  - _Acceptance Criteria_: Priority screen renders, weights update, validation works, calculation initiates
  - _Files_: `lib/features/priority_setting/presentation/screens/priority_input_screen.dart`
  - _Requirements_: FR-6 (priority input), FR-7 (calculation)

### 5.3 Create Validation Use Cases

- [ ] 5.12 Create ValidateWeightsUseCase
  - call(weights{}) checks if sum = 100% (±0.001 tolerance)
  - Returns ValidationResult: success or error with message
  - _Acceptance Criteria_: Validation logic correct, tolerance applied
  - _Files_: `lib/features/priority_setting/domain/usecases/validate_weights_usecase.dart`
  - _Requirements_: FR-6, FR-13 (weight validation)

- [ ] 5.13 Create AutoBalanceUseCase
  - call(weights{}) proportionally rescales to sum to 100%
  - Preserves proportion: if weight A was 2× weight B, after scaling still 2×
  - Returns new weights map
  - _Acceptance Criteria_: Proportions preserved, sum = 100%
  - _Files_: `lib/features/priority_setting/domain/usecases/auto_balance_usecase.dart`
  - _Requirements_: FR-6 (auto-balance)

- [ ] 5.14 Write unit tests for ValidateWeightsUseCase
  - Test weights summing to 100% pass
  - Test weights not summing to 100% fail with appropriate error message
  - Test tolerance: 99.999%, 100.001% pass; 99% fail
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/priority_setting/domain/usecases/validate_weights_usecase_test.dart`
  - _Requirements_: FR-6, FR-13

- [ ] 5.15 Write unit tests for AutoBalanceUseCase
  - Test proportions preserved: if weight[A] = 2 × weight[B], after balance still true
  - Test sum = 100% exactly
  - Test with 0 weights, negative weights (edge cases)
  - _Acceptance Criteria_: All tests pass, proportions preserved
  - _Files_: `test/features/priority_setting/domain/usecases/auto_balance_usecase_test.dart`
  - _Requirements_: FR-6

### 5.4 Testing

- [ ] 5.16 Write widget tests for weight slider interaction
  - Test slider adjusts weight value
  - Test label updates in real-time
  - Test total indicator updates when slider moved
  - _Acceptance Criteria_: Interaction tests pass
  - _Files_: `test/features/priority_setting/presentation/screens/priority_input_screen_test.dart`
  - _Requirements_: FR-6 (testing)

- [ ] 5.17 Write widget tests for weight total validation
  - Test "Calculate Result" button disabled when total ≠ 100%
  - Test button enabled when total = 100%
  - Test "Auto-Balance" button rescales weights correctly
  - _Acceptance Criteria_: Validation tests pass
  - _Files_: `test/features/priority_setting/presentation/screens/priority_input_screen_test.dart`
  - _Requirements_: FR-6, FR-13

- [ ] 5.18 Checkpoint - Criteria and Priority selection works
  - Launch app, go through category → alternatives → criteria flow
  - Verify criteria selection screen appears, can select/deselect, count updates
  - Verify custom criteria can be added
  - Verify AI suggestions button shows (placeholder)
  - Verify priority input screen appears with sliders
  - Verify total weight indicator shows red initially
  - Verify "Calculate Result" button disabled until total = 100%
  - Verify "Auto-Balance" button rescales weights to 100%
  - _Acceptance Criteria_: Full flow works end-to-end
  - _Files_: Checklist

---

## Phase 6: SAW Calculation & Results Display

### Objective

Wire decision engine to calculation flow, implement result display with calculation transparency.

### 6.1 Create Decision Engine Providers & Integration

- [ ] 6.1 Create ResultProvider for calculation state
  - Properties: _result (DecisionResult?), _state (enum: idle|loading|loaded|error), _error (String?)
  - Methods: calculate(decisionMatrix, weights, criteriaMap), getResult(), isLoading
  - _Acceptance Criteria_: Provider manages calculation state
  - _Files_: `lib/features/decision_engine/presentation/providers/result_provider.dart`
  - _Requirements_: FR-7 (result state)

- [ ] 6.2 Create CalculateSAWUseCase orchestration
  - Inject DecisionEngineRepository
  - call(matrix, weights, criteriaMap) calls repository.calculate()
  - Handles errors and returns DecisionResult
  - _Acceptance Criteria_: Use case calls repository correctly
  - _Files_: `lib/features/decision_engine/domain/usecases/calculate_saw_usecase.dart`
  - _Requirements_: FR-7 (SAW orchestration)

- [ ] 6.3 Create DecisionEngineRepository interface
  - Define calculate(matrix, weights, criteriaMap) → Future<DecisionResult>
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/decision_engine/domain/repositories/decision_engine_repository.dart`
  - _Requirements_: FR-7

- [ ] 6.4 Create DecisionEngineRepositoryImpl
  - Implement using SAWCalculator for calculation
  - Direct call to SAWCalculator.calculate() without async wrapping (pure function)
  - Handle any errors and throw CalculationError
  - _Acceptance Criteria_: Repository calls SAWCalculator, returns results
  - _Files_: `lib/features/decision_engine/data/repositories/decision_engine_repository_impl.dart`
  - _Requirements_: FR-7

### 6.2 Implement Result Screen

- [ ] 6.5 Implement Result Screen
  - Display ranked alternatives list (top recommendation highlighted with "Best Match" badge)
  - Each result row shows: rank, alternative name, composite score (e.g., "82.5%")
  - Visual score indicator: progress bar 0-100%
  - Show top 3 results prominently, remaining alternatives in collapsed list
  - Tap on result row to expand details (show breakdown for that alternative)
  - _Acceptance Criteria_: Rankings display correctly, top alternative highlighted, scores show
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-7 (result display)

- [ ] 6.6 Implement Result Detail Expansion
  - When user taps on result row, expand to show calculation breakdown
  - Display individual criterion scores: "Price: 0.75 × 30% = 22.5%"
  - Show normalized value, weight, and weighted contribution
  - Tap again to collapse
  - _Acceptance Criteria_: Detail view expands/collapses, breakdown displays correctly
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-7 (transparency)

- [ ] 6.7 Create result detail screen (full page view)
  - Create ResultDetailScreen for expanded view of one alternative's breakdown
  - Show all calculation steps: normalization, weighting, final score
  - Include "How is this calculated?" link explaining SAW methodology
  - _Acceptance Criteria_: Detail screen renders, explains methodology
  - _Files_: `lib/features/decision_engine/presentation/screens/result_detail_screen.dart`
  - _Requirements_: FR-7 (calculation transparency)

- [ ] 6.8 Implement calculation error handling
  - If calculation fails (missing data, validation error), show error message
  - Display: "Calculation failed. Ensure all alternatives have values for selected criteria. [View Details]"
  - Show retry button to go back to Priority Input and fix data
  - _Acceptance Criteria_: Error displays, retry button functional
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-7, FR-13 (error handling)

- [ ] 6.9 Wire Priority Input Screen to Result Screen
  - When "Calculate Result" button tapped in PriorityInputScreen, collect alternatives, criteria, weights
  - Build DecisionMatrix from current decision state
  - Call ResultProvider.calculate(matrix, weights, criteriaMap)
  - Navigate to ResultScreen
  - Show loading spinner while calculating
  - _Acceptance Criteria_: Full flow works: Priority Input → loading → Result Screen
  - _Files_: `lib/features/priority_setting/presentation/screens/priority_input_screen.dart`
  - _Requirements_: FR-6, FR-7

### 6.3 Create Missing Data Handling

- [ ] 6.10 Implement missing value detection in Decision Matrix
  - When building matrix, check if any (alternative, criterion) pair has no value
  - Provide visual indicator (warning icon) for missing cells
  - Prevent calculation until all values provided
  - _Acceptance Criteria_: Missing values detected, user prevented from calculating
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-7, FR-13 (missing data)

### 6.4 Create Calculation UI Processing Screen

- [ ] 6.11 Implement Calculation Review/Processing Screen
  - Show summary before calculating: "We're about to calculate your decision with X alternatives and Y criteria"
  - Display alternatives, criteria, and weights in summary format
  - Button to "Confirm Calculation" or "Go Back"
  - _Acceptance Criteria_: Summary displays, buttons functional
  - _Files_: `lib/features/decision_engine/presentation/screens/calculation_review_screen.dart`
  - _Requirements_: FR-7 (user review before calculation)

### 6.5 Testing

- [ ] 6.12 Write widget tests for result display
  - Test ranked alternatives render in correct order
  - Test scores display correctly (e.g., "82.5%")
  - Test "Best Match" badge on top result
  - Test detail expansion shows breakdown
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/decision_engine/presentation/screens/result_screen_test.dart`
  - _Requirements_: FR-7 (testing)

- [ ] 6.13 Write widget tests for error handling
  - Test error message displays on calculation failure
  - Test retry button functional
  - Test missing value warning shows
  - _Acceptance Criteria_: Error handling tests pass
  - _Files_: `test/features/decision_engine/presentation/screens/result_screen_test.dart`
  - _Requirements_: FR-13 (error testing)

- [ ] 6.14 Write integration tests for full calculation flow
  - Test: Category → Alternative → Criteria → Priority → Result
  - Verify result ranking is correct for known input
  - Verify scores calculated deterministically
  - _Acceptance Criteria_: Integration tests pass
  - _Files_: `test/features/decision_engine/presentation/screens/result_screen_test.dart`
  - _Requirements_: FR-7 (integration testing)

- [ ] 6.15 Checkpoint - SAW Calculation & Results work end-to-end
  - Launch app, go through full decision creation flow
  - Verify Priority Input screen calculates on button tap
  - Verify Result Screen displays ranked alternatives
  - Verify scores shown are reasonable (between 0-100%)
  - Verify top result has highest score
  - Verify detail expansion shows calculation breakdown
  - _Acceptance Criteria_: Full SAW calculation works, results display correctly
  - _Files_: Checklist

---

## Phase 7: Comparison & What-If Simulation

### Objective

Implement side-by-side comparison view and what-if simulation with real-time recalculation.

### 7.1 Implement Comparison Feature

- [ ] 7.1 Create Comparison Screen
  - Display horizontal scrollable table: alternatives as columns, criteria as rows
  - Each cell shows raw or normalized value for (alternative, criterion) pair
  - Column headers show alternative name and current rank/score badge
  - Highlight best performer in each criterion row: bold or colored background
  - Row headers (criterion names) sticky on left as alternatives scroll
  - _Acceptance Criteria_: Table renders, scrolling works, best performer highlighted
  - _Files_: `lib/features/comparison/presentation/screens/comparison_screen.dart`
  - _Requirements_: FR-9 (comparison)

- [ ] 7.2 Create cell detail tooltip/modal
  - When user taps a cell, display modal showing:
    - Criterion name and type (Benefit/Cost)
    - Raw value + normalized value
    - Calculation: normalized × weight = weighted contribution
    - How this criterion affected ranking
  - _Acceptance Criteria_: Modal displays on tap, shows calculation details
  - _Files_: `lib/features/comparison/presentation/screens/comparison_screen.dart`
  - _Requirements_: FR-9 (cell details)

- [ ] 7.3 Create ComparisonProvider for state management
  - Properties: _comparisonView (comparison data formatted for display)
  - Methods: buildComparisonView(result)
  - _Acceptance Criteria_: Provider builds comparison data structure
  - _Files_: `lib/features/comparison/presentation/providers/comparison_provider.dart`
  - _Requirements_: FR-9 (comparison state)

- [ ] 7.4 Create ComparisonRepository interface
  - Define buildComparisonView(result) → ComparisonView
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/comparison/domain/repositories/comparison_repository.dart`
  - _Requirements_: FR-9

### 7.2 Implement What-If Simulation

- [ ] 7.5 Create SimulationProvider for state management
  - Properties: _originalWeights, _simulatedWeights, _simulatedResult
  - Methods: adjustWeight(critId, newValue), autoBalance(), getSimulationResult(), saveAsNewDecision()
  - Never mutate _originalWeights
  - _Acceptance Criteria_: Provider manages simulation state immutably
  - _Files_: `lib/features/what_if_simulation/presentation/providers/simulation_provider.dart`
  - _Requirements_: FR-10 (what-if state)

- [ ] 7.6 Implement What-If Simulation Screen
  - Display current priorities with sliders (same as Priority Input)
  - Show current ranking preview (top 3 alternatives with scores)
  - Real-time recalculation as user adjusts sliders (debounced 300ms)
  - Highlight rank changes: "↑ Laptop A moved from #3 → #1"
  - Display "Auto-Balance" button
  - Total weight indicator shows red if ≠ 100%, green if = 100%
  - "Save as New Decision" button enabled when total = 100%
  - _Acceptance Criteria_: Simulation screen renders, sliders adjust, recalculation updates ranking in real-time
  - _Files_: `lib/features/what_if_simulation/presentation/screens/what_if_screen.dart`
  - _Requirements_: FR-10 (what-if simulation)

- [ ] 7.7 Create RecalculateSimulationUseCase
  - call(simulationState, criterionId, newWeight) recalculates with updated weight
  - Never mutates original decision
  - Returns new DecisionResult
  - _Acceptance Criteria_: Use case calculates correctly, no mutation
  - _Files_: `lib/features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart`
  - _Requirements_: FR-10 (recalculation)

- [ ] 7.8 Create SimulationState immutability tests
  - Unit test: after calling adjustWeight(), verify original decision.weights unchanged
  - Test that copyWith() creates new SimulationState without affecting original
  - _Acceptance Criteria_: Tests pass, no mutation detected
  - _Files_: `test/features/what_if_simulation/domain/entities/simulation_state_test.dart`
  - _Requirements_: FR-10 (immutability guarantee)

- [ ] 7.9 Implement Simulation Comparison View
  - Create SimulationComparisonScreen showing side-by-side:
    - Original ranking with original weights
    - Simulated ranking with new weights
    - Highlight alternatives that changed position
  - _Acceptance Criteria_: Comparison displays, changes highlighted
  - _Files_: `lib/features/what_if_simulation/presentation/screens/simulation_comparison_screen.dart`
  - _Requirements_: FR-10 (comparison)

- [ ] 7.10 Implement "Save as New Decision" action
  - When "Save as New Decision" tapped, create new Decision object with simulated weights
  - Save to decision history (local storage for now)
  - Display success message: "Simulation saved as new decision: [Decision Title]"
  - Option to view new decision or continue simulating
  - _Acceptance Criteria_: New decision created and saved, can be retrieved
  - _Files_: `lib/features/what_if_simulation/presentation/screens/what_if_screen.dart`
  - _Requirements_: FR-10 (save simulation)

- [ ] 7.11 Implement plan tier limits for what-if
  - Basic plan: max 1 what-if simulation per decision
  - Premium plan: unlimited what-ifs
  - When limit reached, show upgrade prompt
  - _Acceptance Criteria_: Limits enforced correctly
  - _Files_: `lib/features/what_if_simulation/presentation/screens/what_if_screen.dart`
  - _Requirements_: FR-10, FR-12 (quota enforcement)

### 7.3 Testing

- [ ] 7.12 Write widget tests for comparison view rendering
  - Test table renders all cells (N alternatives × M criteria)
  - Test best performer in each row highlighted
  - Test cell tap shows detail modal
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/comparison/presentation/screens/comparison_screen_test.dart`
  - _Requirements_: FR-9 (testing)

- [ ] 7.13 Write widget tests for what-if weight adjustment
  - Test slider adjusts weight
  - Test ranking updates in real-time
  - Test "Auto-Balance" rescales weights
  - Test total weight indicator color changes
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/what_if_simulation/presentation/screens/what_if_screen_test.dart`
  - _Requirements_: FR-10 (testing)

- [ ] 7.14 Write unit tests for RecalculateSimulationUseCase
  - Test recalculation produces correct ranking
  - Test original decision unchanged
  - Test with various weight adjustments
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/what_if_simulation/domain/usecases/recalculate_simulation_usecase_test.dart`
  - _Requirements_: FR-10 (testing)

- [ ] 7.15 Checkpoint - Comparison and What-If work end-to-end
  - From Result Screen, tap "Compare" → Comparison Screen displays
  - Tap a cell → detail modal shows calculation
  - From Result Screen, tap "What-If" → What-If Screen displays
  - Adjust slider → ranking updates in real-time
  - Verify rank changes highlighted
  - Tap "Save as New Decision" → new decision created
  - _Acceptance Criteria_: Both features work end-to-end
  - _Files_: Checklist

---

## Phase 8: AI Explanations (Placeholder & Integration Point)

### Objective

Create AI explanation display component and integration point for LLM backend (actual implementation deferred).

### 8.1 Create AI Explanation Components

- [ ] 8.1 Create AIExplanationWidget
  - Display AI-generated explanation text (150-300 words)
  - Show disclaimer: "AI-powered insights are suggestions, not guarantees. Your decision is ultimately yours."
  - Include "How is this calculated?" link to SAW methodology
  - _Acceptance Criteria_: Widget renders explanation and disclaimer
  - _Files_: `lib/features/ai_explanation/presentation/widgets/ai_insight_widget.dart`
  - _Requirements_: FR-8 (AI explanation)

- [ ] 8.2 Create ExplanationDisclaimerWidget
  - Display warning/info message about AI limitations
  - Message: "AI-powered insights are suggestions, not guarantees."
  - Styled with info icon and light background color
  - _Acceptance Criteria_: Disclaimer renders correctly
  - _Files_: `lib/features/ai_explanation/presentation/widgets/explanation_disclaimer.dart`
  - _Requirements_: FR-17 (AI guardrails)

- [ ] 8.3 Create AIExplanationProvider
  - Properties: _explanation (AIExplanation?), _state (idle|loading|loaded|error), _error
  - Methods: generateExplanation(result), getExplanation()
  - _Acceptance Criteria_: Provider manages explanation state
  - _Files_: `lib/features/ai_explanation/presentation/providers/ai_explanation_provider.dart`
  - _Requirements_: FR-8 (AI state)

### 8.2 Create Entities & Interfaces

- [ ] 8.4 Create AIExplanation entity
  - Properties: text (String), topFactors (List<String>), tradeoffs (List<String>?), confidence (double 0-1), model (String), generatedAt
  - _Acceptance Criteria_: Entity compiles, immutable
  - _Files_: `lib/features/ai_explanation/domain/entities/ai_explanation.dart`
  - _Requirements_: FR-8

- [ ] 8.5 Create AIExplanationRepository interface
  - Define generateExplanation(result) → Future<AIExplanation>
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/ai_explanation/domain/repositories/ai_explanation_repository.dart`
  - _Requirements_: FR-8

- [ ] 8.6 Create mock AIExplanationDataSource (placeholder)
  - Implement MockAIExplanationDataSource: returns static placeholder explanation
  - Example: "Based on your priorities, Laptop A is the best fit because it excels in Performance (95%) and Value (80%). Laptop B offers better battery life but trails in processing speed."
  - _Acceptance Criteria_: Mock returns reasonable explanation
  - _Files_: `lib/features/ai_explanation/data/datasources/ai_explanation_datasource.dart`
  - _Requirements_: FR-8 (placeholder)

- [ ] 8.7 Create AIExplanationRepositoryImpl (placeholder)
  - Implement using mock datasource for now
  - Structure for future real API integration
  - _Acceptance Criteria_: Repository calls mock datasource
  - _Files_: `lib/features/ai_explanation/data/repositories/ai_explanation_repository_impl.dart`
  - _Requirements_: FR-8

### 8.3 Integrate into Result Screen

- [ ] 8.8 Add AI Explanation widget to Result Screen
  - After result ranking displayed, show AIExplanationWidget
  - Call AIExplanationProvider.generateExplanation(result)
  - Show loading spinner while generating
  - Show error message if generation fails
  - _Acceptance Criteria_: AI explanation section appears on Result Screen, loading/error states shown
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-8 (integration)

- [ ] 8.9 Implement AI explanation guardrails
  - Verify explanation text is grounded in actual calculation (references top alternatives)
  - If confidence < 0.5, mark as "Low Confidence"
  - If explanation fails to load, show fallback static message
  - _Acceptance Criteria_: Guardrails enforced, fallback works
  - _Files_: `lib/features/ai_explanation/data/datasources/ai_explanation_datasource.dart`
  - _Requirements_: FR-17 (guardrails)

- [ ] 8.10 Implement low-confidence indication
  - If AIExplanation.confidence < 0.5, display visual indicator: "Low Confidence" badge
  - Styled differently (lighter color, asterisk, footnote)
  - _Acceptance Criteria_: Low-confidence explanations marked visually
  - _Files_: `lib/features/ai_explanation/presentation/widgets/ai_insight_widget.dart`
  - _Requirements_: FR-17 (confidence marking)

### 8.4 Testing

- [ ] 8.11 Write widget tests for AI explanation display
  - Test explanation renders with disclaimer
  - Test "How is this calculated?" link functional
  - Test loading and error states
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/ai_explanation/presentation/widgets/ai_insight_widget_test.dart`
  - _Requirements_: FR-8 (testing)

---

## Phase 9: Decision History & Persistence

### Objective

Implement decision history screen, detail view, persistence (placeholder for backend).

### 9.1 Create Decision History Screen

- [ ] 9.1 Create HistoryProvider for state management
  - Properties: _decisions (List<Decision>), _currentPage (int), _isLoading, _error
  - Methods: loadDecisions(page), searchDecisions(query), filterByCategory(category)
  - _Acceptance Criteria_: Provider manages history state and pagination
  - _Files_: `lib/features/decision_history/presentation/providers/history_provider.dart`
  - _Requirements_: FR-11 (history state)

- [ ] 9.2 Create DecisionHistoryRepository interface
  - Define: saveDecision(decision), getDecision(id), listDecisions(page), deleteDecision(id)
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/decision_history/domain/repositories/decision_history_repository.dart`
  - _Requirements_: FR-11

- [ ] 9.3 Create mock DecisionHistoryDataSource (in-memory)
  - Implement MockDecisionHistoryDataSource: stores decisions in memory list
  - Simulate pagination (10 items per page)
  - _Acceptance Criteria_: Mock datasource stores and retrieves decisions
  - _Files_: `lib/features/decision_history/data/datasources/decision_history_datasource.dart`
  - _Requirements_: FR-11 (placeholder)

- [ ] 9.4 Create DecisionHistoryRepositoryImpl
  - Implement interface using mock datasource
  - _Acceptance Criteria_: Repository stores/retrieves decisions
  - _Files_: `lib/features/decision_history/data/repositories/decision_history_repository_impl.dart`
  - _Requirements_: FR-11

- [ ] 9.5 Implement History List Screen
  - Display list of saved decisions (paginated, 10 per page)
  - Each item shows: decision title, category, first alternative, status badge (Completed/Draft), date created
  - Tap item to navigate to Decision Detail Screen
  - Delete button (X) on each item with confirmation dialog
  - Search field to filter decisions by title
  - Filter dropdown by category
  - Load more on scroll (infinite scroll or pagination)
  - _Acceptance Criteria_: History list displays, pagination works, search/filter functional
  - _Files_: `lib/features/decision_history/presentation/screens/history_screen.dart`
  - _Requirements_: FR-11 (history listing)

- [ ] 9.6 Implement Decision Detail Screen
  - Display full breakdown of decision: alternatives, criteria, weights, scores, ranking
  - Show AI explanation (if available)
  - Show calculation timestamp
  - Buttons: "Re-simulate" (go to What-If), "Export" (placeholder), "Delete"
  - _Acceptance Criteria_: Detail screen displays all decision data
  - _Files_: `lib/features/decision_history/presentation/screens/decision_detail_screen.dart`
  - _Requirements_: FR-11 (detail view)

- [ ] 9.7 Implement delete decision with confirmation
  - When "Delete" tapped, show ConfirmationDialog: "Are you sure? This cannot be undone."
  - On confirm, call repository.deleteDecision(id)
  - Return to History Screen
  - Show success message (toast or snackbar)
  - _Acceptance Criteria_: Delete confirmation works, decision removed
  - _Files_: `lib/features/decision_history/presentation/screens/history_screen.dart`
  - _Requirements_: FR-11 (delete)

### 9.2 Implement Persistence Integration

- [ ] 9.8 Integrate SaveDecisionUseCase
  - Create SaveDecisionUseCase: call(decision) saves to repository
  - Call from Result Screen "Save Decision" button
  - _Acceptance Criteria_: Decision saved to history after calculation
  - _Files_: `lib/features/decision_history/domain/usecases/save_decision_usecase.dart`
  - _Requirements_: FR-11 (save)

- [ ] 9.9 Add "Save Decision" action to Result Screen
  - After results display, add "Save Decision" button
  - On tap, calls SaveDecisionUseCase
  - Show success: "Decision saved to your history"
  - Option to view history or continue simulating
  - _Acceptance Criteria_: Decision saved, user notified
  - _Files_: `lib/features/decision_engine/presentation/screens/result_screen.dart`
  - _Requirements_: FR-11 (save from result)

- [ ] 9.10 Implement plan tier limits for decision storage
  - Basic plan: store up to 10 decisions
  - Premium plan: unlimited storage
  - When limit reached, show upgrade prompt before saving
  - _Acceptance Criteria_: Limits enforced correctly
  - _Files_: `lib/features/decision_history/domain/usecases/save_decision_usecase.dart`
  - _Requirements_: FR-11, FR-12 (storage quotas)

### 9.3 Testing

- [ ] 9.11 Write widget tests for history list navigation
  - Test history list renders
  - Test tap item navigates to detail screen
  - Test delete with confirmation
  - Test search filters results
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/decision_history/presentation/screens/history_screen_test.dart`
  - _Requirements_: FR-11 (testing)

- [ ] 9.12 Write unit tests for SaveDecisionUseCase
  - Test decision saved with all fields
  - Test plan quota enforced (10 for Basic, unlimited for Premium)
  - Test exception thrown when limit exceeded
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/decision_history/domain/usecases/save_decision_usecase_test.dart`
  - _Requirements_: FR-11 (testing)

- [ ] 9.13 Checkpoint - History and Persistence work
  - From Result Screen, tap "Save Decision"
  - Verify success message shows
  - Navigate to History Screen
  - Verify saved decision appears in list
  - Tap decision → detail screen shows full breakdown
  - Tap delete → confirmation dialog appears, delete works
  - _Acceptance Criteria_: Full history workflow operational
  - _Files_: Checklist

---

## Phase 10: Premium Insights & Profile

### Objective

Implement user profile screen, plan tier display, and premium feature indicators.

### 10.1 Create Profile Screen

- [ ] 10.1 Create ProfileProvider for state management
  - Properties: _user (User?), _planInfo (UserPlan?), _stats (usage statistics)
  - Methods: loadProfile(), updateProfile(), upgradeToP premium()
  - _Acceptance Criteria_: Provider manages profile state
  - _Files_: `lib/features/profile/presentation/providers/profile_provider.dart`
  - _Requirements_: FR-2, FR-12 (profile)

- [ ] 10.2 Create ProfileRepository interface
  - Define: getProfile(userId), updateProfile(user)
  - _Acceptance Criteria_: Interface compiles
  - _Files_: `lib/features/profile/domain/repositories/profile_repository.dart`
  - _Requirements_: FR-2

- [ ] 10.3 Create mock ProfileDataSource
  - Return hardcoded user profile with Basic tier for test account
  - _Acceptance Criteria_: Mock returns profile
  - _Files_: `lib/features/profile/data/datasources/profile_datasource.dart`
  - _Requirements_: FR-2 (placeholder)

- [ ] 10.4 Implement Profile Screen
  - Display user info: name, email, avatar (placeholder)
  - Display plan tier: "Basic Plan" or "Premium Plan" with prominent badge
  - Display usage statistics: decisions created this month, criteria used, what-ifs created
  - For Basic tier: "Upgrade to Premium" button (large, primary CTA)
  - For Premium tier: "Manage subscription" button (secondary)
  - Settings section: "Notifications", "Privacy", "About"
  - Logout button
  - _Acceptance Criteria_: Profile displays user info, plan tier, usage stats; upgrade button present
  - _Files_: `lib/features/profile/presentation/screens/profile_screen.dart`
  - _Requirements_: FR-2, FR-12 (profile screen)

### 10.2 Plan Tier Features

- [ ] 10.5 Create Plan Limit Dialog
  - Display when user hits feature limit (e.g., 4th alternative on Basic)
  - Show: "You've reached your limit for [feature]. Upgrade to Premium for [benefit]."
  - "Upgrade Now" button → opens upgrade flow (placeholder)
  - "Cancel" button
  - _Acceptance Criteria_: Dialog displays, buttons functional
  - _Files_: `lib/features/access_control/presentation/widgets/plan_limit_dialog.dart`
  - _Requirements_: FR-12 (upgrade prompt)

- [ ] 10.6 Add Premium badge indicators to limited features
  - On Criteria Selection: "AI Suggest Criteria" button shows "Premium Only" badge
  - On What-If Simulation: "Limited to 1 what-if on Basic" notice
  - On History: "Your history is limited to 10 decisions" for Basic users
  - Badges styled with premium color (gold/purple)
  - _Acceptance Criteria_: All limited features marked with premium badges
  - _Files_: Multiple screen files
  - _Requirements_: FR-12 (premium indicators)

- [ ] 10.7 Create upgrade flow (placeholder)
  - When "Upgrade Now" tapped, navigate to UpgradeScreen (placeholder)
  - Display plan benefits:
    - Premium: Unlimited alternatives (vs. 3 Basic), unlimited criteria (vs. 3 Basic), unlimited what-ifs (vs. 1 Basic), full AI explanations
  - "Upgrade Now" button (placeholder - no actual payment)
  - "Maybe Later" button
  - _Acceptance Criteria_: Upgrade screen displays, buttons functional
  - _Files_: `lib/features/profile/presentation/screens/upgrade_screen.dart`
  - _Requirements_: FR-12 (upgrade flow - placeholder)

### 10.3 Testing

- [ ] 10.8 Write widget tests for profile screen
  - Test user info displays
  - Test plan tier badge shows
  - Test usage statistics display
  - Test upgrade button present for Basic tier
  - _Acceptance Criteria_: All tests pass
  - _Files_: `test/features/profile/presentation/screens/profile_screen_test.dart`
  - _Requirements_: FR-2, FR-12 (testing)

- [ ] 10.9 Checkpoint - Profile and Premium features work
  - Navigate to Profile Screen
  - Verify user info and plan tier display
  - Verify usage stats shown
  - Verify upgrade button present
  - Tap upgrade button → upgrade screen appears
  - _Acceptance Criteria_: Profile workflow operational
  - _Files_: Checklist

---

## Phase 11: Accessibility, Hardening & Testing

### Objective

Add accessibility features, harden against edge cases, run full test suite and build verification.

### 11.1 Accessibility Implementation

- [ ] 11.1 Add semantic labels to all interactive elements
  - Use `Semantics` widget to add labels to: buttons, icons, text fields
  - Example: `Semantics(label: "Add alternative", child: IconButton(...))`
  - Buttons should have descriptive labels (not just "Button")
  - _Acceptance Criteria_: All interactive elements have semantic labels, no bare buttons
  - _Files_: All screen files
  - _Requirements_: FR-15, WCAG compliance

- [ ] 11.2 Verify keyboard navigation
  - Run app on device/emulator
  - Use Tab key to navigate through all interactive elements
  - Verify focus order is logical (top-to-bottom, left-to-right)
  - Verify Enter key activates focused button/input
  - _Acceptance Criteria_: Full keyboard navigation works, focus order logical
  - _Files_: No code changes (manual test)
  - _Requirements_: Accessibility

- [ ] 11.3 Verify color contrast (WCAG AA 4.5:1 minimum)
  - Run `flutter test` with accessibility analyzer
  - Check all text on all backgrounds: body text, labels, buttons
  - Primary text (slate-900) on light backgrounds: ✓ (sufficient)
  - Secondary text (slate-600) on light backgrounds: verify ≥4.5:1
  - Buttons (white on indigo): verify ≥4.5:1
  - _Acceptance Criteria_: All contrast ratios ≥4.5:1 for AA compliance
  - _Files_: No code changes (accessibility audit)
  - _Requirements_: WCAG AA compliance

- [ ] 11.4 Test on multiple screen sizes
  - Test on small screen: 4.5" (375 × 812, iPhone SE)
  - Test on large screen: 6.7" (414 × 896, iPhone 14 Pro Max)
  - Verify layout responsive: padding/margin adjust, text doesn't overflow
  - Verify buttons/inputs remain tap-friendly (minimum 48×48 dp)
  - _Acceptance Criteria_: App usable on both small and large screens
  - _Files_: No code changes (manual testing)
  - _Requirements_: FR-15 (responsive)

- [ ] 11.5 Test on Android API 21+ and iOS 11+
  - Build and test on Android API 21 emulator (older device)
  - Build and test on iOS 11 simulator (older device)
  - Verify no crashes, layout breaks, or compatibility issues
  - _Acceptance Criteria_: App runs on minimum supported versions
  - _Files_: No code changes (device testing)
  - _Requirements_: FR-15 (platform support)

### 11.2 Hardening & Edge Cases

- [ ] 11.6 Verify orientation lock (portrait-only)
  - Run app on device
  - Rotate device to landscape
  - Verify app remains in portrait orientation
  - Verify SystemChrome.setPreferredOrientations() enforced
  - _Acceptance Criteria_: Orientation locked despite device rotation
  - _Files_: `lib/main.dart` (already configured in Phase 1)
  - _Requirements_: FR-15

- [ ] 11.7 Test offline cache strategy
  - Build app and load categories/subcategories once
  - Turn off network (enable airplane mode)
  - Relaunch app and verify categories still load from cache
  - Verify cached data shows no errors
  - _Acceptance Criteria_: Offline cache works, data displayed from cache
  - _Files_: Caching logic (already implemented in Phase 3)
  - _Requirements_: FR-15 (offline support)

- [ ] 11.8 Test session expiration handling
  - Create decision and complete calculation
  - Manually trigger session expiration (mock: set expiresAt to now - 1 hour)
  - Attempt to navigate → verify redirected to login
  - Login again and verify can continue
  - _Acceptance Criteria_: Expired session handled gracefully, re-authentication works
  - _Files_: `lib/features/auth/presentation/providers/auth_provider.dart`
  - _Requirements_: FR-1 (session management)

- [ ] 11.9 Test with zero/null edge cases
  - Test decision with one criterion (minimum)
  - Test decision with all alternatives having same value for criterion (normalization edge case)
  - Test weights with values like 33.33%, 33.33%, 33.34% (rounding edge case)
  - Verify calculations don't crash, results reasonable
  - _Acceptance Criteria_: Edge cases handled, no crashes, results valid
  - _Files_: Tests and manual testing
  - _Requirements_: Robustness

### 11.3 Full Test Suite & Build Verification

- [ ] 11.10 Run full unit test suite
  - Run `flutter test` on all test files
  - Verify all tests pass (100+ tests from phases 2-10)
  - No skipped tests, no failures
  - _Acceptance Criteria_: All tests pass, 0 failures
  - _Files_: Test output log
  - _Requirements_: Quality checkpoint

- [ ] 11.11 Run code analyzer and formatter
  - Run `dart format lib/ test/` to format all code
  - Run `flutter analyze` to check for warnings
  - Fix all warnings: unused imports, deprecated methods, etc.
  - Verify zero analyzer issues
  - _Acceptance Criteria_: `flutter analyze` shows zero issues
  - _Files_: All code files
  - _Requirements_: Code quality

- [ ] 11.12 Verify test coverage ≥80% overall
  - Run `flutter test --coverage` for all features
  - Generate coverage report: `lcov --list coverage/lcov.info`
  - Target ≥90% for decision_engine, ≥85% for domain/entities, ≥70% for screens
  - Overall target: ≥80%
  - Flag any low-coverage areas and add tests if needed
  - _Acceptance Criteria_: Coverage report shows ≥80% overall, no major gaps
  - _Files_: `coverage/lcov.info`
  - _Requirements_: Test coverage

- [ ] 11.13 Build APK (Android release build)
  - Run `flutter build apk --release`
  - Verify build succeeds without errors
  - Check APK size: target <30MB
  - _Acceptance Criteria_: APK builds successfully, size <30MB
  - _Files_: `build/app/outputs/apk/release/app-release.apk`
  - _Requirements_: FR-15 (APK size)

- [ ] 11.14 Build IPA (iOS release build - macOS only)
  - Run `flutter build ios --release` on macOS
  - Verify build succeeds without errors
  - _Acceptance Criteria_: IPA builds successfully
  - _Files_: `build/ios/iphoneos/Runner.app`
  - _Requirements_: FR-15 (iOS build)

- [ ] 11.15 Performance test: decision calculation <2s
  - Create test decision with 8 alternatives, 6 criteria
  - Time calculation execution: `Stopwatch().start()... calculate()...stop()`
  - Verify calculation completes in <2 seconds
  - _Acceptance Criteria_: Calculation <2s for typical decision
  - _Files_: Manual test or benchmark test
  - _Requirements_: Performance requirements

### 11.4 Final Integration Verification

- [ ] 11.16 End-to-end smoke test (complete workflow)
  - Launch app on device → splash screen
  - Wait 3 seconds → navigate to onboarding
  - Complete onboarding → navigate to login
  - Mock login (any credentials) → dashboard
  - Tap "Create Decision" → category selection
  - Select category + subcategory → alternative management
  - Add 3-5 alternatives → criteria selection
  - Select 3 criteria → priority input
  - Set weights to 100% → calculate
  - Verify result screen displays ranking
  - Tap result detail → breakdown shows
  - Tap "Compare" → comparison screen
  - Tap "What-If" → simulation screen, adjust weights
  - Save simulation as new decision
  - Navigate to history → verify both decisions saved
  - Tap decision → detail screen shows
  - Logout → verify redirected to login
  - _Acceptance Criteria_: Complete workflow successful, no crashes
  - _Files_: Checklist of completed steps

- [ ] 11.17 Accessibility audit with flutter test
  - Run `flutter test test/accessibility_test.dart` (if defined)
  - Or use online tool to scan semantic tree
  - Verify all interactive elements have labels
  - Verify keyboard navigation works
  - _Acceptance Criteria_: Accessibility audit passes
  - _Files_: Audit report

### 11.5 Documentation

- [ ] 11.18 Document all created files (file inventory)
  - Create spreadsheet or markdown table listing all created files
  - Columns: File Path, Feature, Lines of Code, Test Coverage, Status
  - Count total files created (target: 80-100 files)
  - _Acceptance Criteria_: Comprehensive file inventory complete
  - _Files_: `IMPLEMENTATION_SUMMARY.md` or spreadsheet

- [ ] 11.19 Document requirements coverage
  - Create checklist of all requirements FR-01 through FR-17
  - Mark each requirement as Implemented, Partially Implemented, Placeholder, or Deferred
  - Document which phase(s) implemented each requirement
  - _Acceptance Criteria_: Coverage mapping complete, all requirements accounted for
  - _Files_: `REQUIREMENTS_COVERAGE.md`
  - _Requirements_: Traceability

- [ ] 11.20 Document test results
  - Test count: [X]+ unit tests, [Y]+ widget tests, [Z]+ integration tests
  - Coverage: Decision Engine __, Validators __, Screens __, Overall __
  - All tests passing: YES
  - No known issues: YES
  - _Acceptance Criteria_: Test results documented
  - _Files_: `TEST_RESULTS.md`
  - _Requirements_: Quality documentation

- [ ] 11.21 Document mock vs. real integrations
  - List all integrations: Auth, Categories, Alternatives, Criteria, SAW, History, AI
  - For each: Mocked/Placeholder, Integration Point, Future Real Implementation Notes
  - Example:
    - Auth: Mocked (accepts any credentials), replace with Firebase/JWT
    - Categories: Mocked from JSON assets, ready for backend API
    - SAW: Fully Implemented (pure function, deterministic)
    - AI Explanations: Placeholder with integration point, call backend LLM
  - _Acceptance Criteria_: Integration strategy documented
  - _Files_: `INTEGRATIONS.md`
  - _Requirements_: Technical documentation

- [ ] 11.22 Document blocked decisions requiring product input
  - List product decisions unresolved: Authentication provider, AI service, Database, Payment processing, Analytics
  - For each: Current state, Options, Recommendation, Impact on MVP
  - Example:
    - Authentication Provider: Mocked for MVP, requires decision for production (Firebase vs. JWT vs. Auth0)
    - AI Services: Placeholder LLM calls, need LLM selection (OpenAI GPT-4, Claude 3, etc.) and rate limiting strategy
    - Database: In-memory mock for MVP, need backend (SQLite, Firebase Firestore, PostgreSQL)
  - _Acceptance Criteria_: Blocked decisions documented with options
  - _Files_: `BLOCKED_DECISIONS.md`
  - _Requirements_: Transparency

- [ ] 11.23 Document known gaps and deferred features
  - List features not implemented in MVP: Admin features, Push notifications, Payment, Dark mode (if deferred)
  - List known limitations: No actual email sending, no real auth, no backend persistence
  - List design documents implemented but backend not yet: AI suggestions, Result explanations
  - _Acceptance Criteria_: Gaps and limitations clearly documented
  - _Files_: `KNOWN_GAPS.md`
  - _Requirements_: Honesty about MVP scope

- [ ] 11.24 Create README with build/run instructions
  - Prerequisites: Flutter 3.x+, Dart 3.x+, Android Studio, Xcode (iOS)
  - Setup: `flutter pub get`
  - Run on Android: `flutter run -d android`
  - Run on iOS: `flutter run -d ios`
  - Run tests: `flutter test`
  - Build APK: `flutter build apk --release`
  - Build IPA: `flutter build ios --release`
  - Known issues and workarounds (if any)
  - _Acceptance Criteria_: README is complete, someone else can build/run successfully
  - _Files_: `README.md`
  - _Requirements_: Documentation

### 11.6 Final Checkpoint

- [ ] 11.25 Checkpoint - All tests pass, app builds successfully
  - All unit tests pass ✓
  - All widget tests pass ✓
  - All integration tests pass ✓
  - `flutter analyze` shows 0 issues ✓
  - `dart format` completes without changes ✓
  - Coverage ≥80% ✓
  - APK builds <30MB ✓
  - App launches and no crashes ✓
  - Complete workflow smoke test passes ✓
  - Accessibility verified ✓
  - Documentation complete ✓
  - _Acceptance Criteria_: All checkmarks completed
  - _Files_: Final checklist

---

## Phase 12: Documentation & Handoff

### Objective

Finalize documentation and prepare codebase for team handoff.

- [ ] 12.1 Create comprehensive architecture documentation
  - Document directory structure, layering (presentation → domain → data)
  - Document Provider pattern usage and state flow
  - Document decision engine algorithm (SAW with examples)
  - Document error handling strategy
  - _Acceptance Criteria_: Architecture guide complete, 20+ pages
  - _Files_: `ARCHITECTURE.md` or `docs/ARCHITECTURE.md`
  - _Requirements_: Technical documentation

- [ ] 12.2 Create API integration guide
  - For each integration point (Auth, Categories, Decision Engine, History, AI):
    - Current mock implementation
    - Expected real API schema/contract
    - How to swap mock for real
    - Example: "To integrate real auth, replace MockAuthDataSource with FirebaseAuthDataSource"
  - _Acceptance Criteria_: Clear integration paths for all features
  - _Files_: `docs/API_INTEGRATION_GUIDE.md`
  - _Requirements_: Technical documentation

- [ ] 12.3 Create testing guide
  - How to run tests: `flutter test`
  - How to generate coverage: `flutter test --coverage`
  - How to add new tests
  - Best practices: PBT for properties, widget tests for screens, unit tests for logic
  - _Acceptance Criteria_: Guide helps developers write tests
  - _Files_: `docs/TESTING_GUIDE.md`
  - _Requirements_: Technical documentation

- [ ] 12.4 Create deployment guide
  - Prerequisites for production deployment
  - Configuration for production: API endpoints, LLM services, database
  - Build commands: APK and IPA
  - Deployment steps: TestFlight (iOS), Google Play (Android)
  - Post-deployment monitoring
  - _Acceptance Criteria_: Deployment steps clear
  - _Files_: `docs/DEPLOYMENT_GUIDE.md`
  - _Requirements_: Operational documentation

- [ ] 12.5 Create handoff summary for team
  - Executive summary: Features implemented, MVP scope, architecture overview
  - Codebase statistics: Files, lines of code, test count, coverage
  - Completed requirements: FR-01 through FR-17, status of each
  - Blocked decisions: What product/backend decisions are pending
  - Known gaps: Features not implemented, limitations, deferred work
  - Next steps: Recommended priorities for Phase 2 (backend integration, admin features, analytics)
  - File: `HANDOFF_SUMMARY.md`
  - _Acceptance Criteria_: Summary gives complete overview of MVP state
  - _Files_: `HANDOFF_SUMMARY.md`
  - _Requirements_: Handoff documentation

- [ ] 12.6 Code cleanup and final review
  - Remove any debug print statements or TODO comments
  - Verify no hardcoded test data left in production code
  - Verify no commented-out code blocks
  - Final pass on code style and consistency
  - _Acceptance Criteria_: Codebase clean, ready for production
  - _Files_: All code files
  - _Requirements_: Code quality

- [ ] 12.7 Final verification checklist
  - All files committed to git ✓
  - All tests passing ✓
  - All documentation complete ✓
  - App builds and runs ✓
  - Coverage ≥80% ✓
  - No compiler errors or warnings ✓
  - No analyzer issues ✓
  - README.md complete ✓
  - _Acceptance Criteria_: All items checked
  - _Files_: `FINAL_VERIFICATION.md`
  - _Requirements_: Final quality checkpoint

---

## Summary

**Total Phases**: 12 (Reconnaissance + 11 Implementation phases)

**Total Tasks**: 200+ concrete, atomic tasks

**Requirements Coverage**: All 17 requirement groups (FR-01 through FR-17) addressed

**Test Coverage**: 100+ unit tests, 50+ widget tests, 10+ integration tests, Target ≥80% overall

**Key Deliverables**:
1. **Phase 0**: Environment verified, blockers identified
2. **Phase 1**: App shell with design tokens, routing, reusable components
3. **Phase 2**: Domain logic with 95%+ test coverage for decision engine
4. **Phase 3**: Authentication and public pages
5. **Phase 4**: Category and alternative selection with quota enforcement
6. **Phase 5**: Criteria selection and priority weighting
7. **Phase 6**: SAW calculation and result display with transparency
8. **Phase 7**: Comparison view and what-if simulation
9. **Phase 8**: AI explanation placeholder with integration point
10. **Phase 9**: Decision history and persistence
11. **Phase 10**: Profile screen and premium tier features
12. **Phase 11**: Accessibility, hardening, full test suite
13. **Phase 12**: Documentation and handoff

**Success Criteria**:
- All 200+ tasks completed ✓
- Test coverage ≥80% ✓
- App builds APK/IPA successfully ✓
- All requirements FR-01 through FR-17 implemented ✓
- Complete end-to-end workflow works ✓
- Accessibility verified (WCAG AA) ✓
- Documentation complete ✓
- Ready for team handoff ✓

---

**Document Status**: Complete Implementation Task List
**Last Updated**: Generated for MyChoice Flutter Frontend MVP
**Next Step**: Start Phase 0 Reconnaissance, then proceed to Phase 1
