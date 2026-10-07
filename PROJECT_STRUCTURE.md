# MyChoice - Project Structure & Preparation Checklist

## 📁 Struktur Folder yang Perlu Disiapkan

```
mychoice/
│
├── docs/                           # Dokumentasi
│   ├── SRS.md                      # Software Requirement Specifications
│   ├── PRD.md                      # Product Requirement Document
│   ├── TDD.md                      # Technical Design Document
│   └── API.md                      # API Documentation
│
├── frontend/                       # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/                # Halaman UI
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── dashboard/
│   │   │   │   └── dashboard_screen.dart
│   │   │   ├── decision/
│   │   │   │   ├── category_selection_screen.dart
│   │   │   │   ├── choice_management_screen.dart
│   │   │   │   ├── criteria_input_screen.dart
│   │   │   │   └── result_screen.dart
│   │   │   ├── comparison/
│   │   │   │   └── comparison_screen.dart
│   │   │   ├── simulation/
│   │   │   │   └── whatif_simulation_screen.dart
│   │   │   ├── history/
│   │   │   │   └── decision_history_screen.dart
│   │   │   └── admin/
│   │   │       ├── user_management_screen.dart
│   │   │       └── catalog_management_screen.dart
│   │   │
│   │   ├── widgets/                # Reusable Components
│   │   │   ├── buttons/
│   │   │   ├── cards/
│   │   │   ├── forms/
│   │   │   └── navigation/
│   │   │
│   │   ├── models/                 # Data Models
│   │   │   ├── user.dart
│   │   │   ├── decision.dart
│   │   │   ├── alternative.dart
│   │   │   ├── criteria.dart
│   │   │   └── category.dart
│   │   │
│   │   ├── services/               # API & Business Logic
│   │   │   ├── auth_service.dart
│   │   │   ├── decision_service.dart
│   │   │   ├── api_service.dart
│   │   │   └── storage_service.dart
│   │   │
│   │   ├── providers/              # State Management
│   │   │   ├── auth_provider.dart
│   │   │   ├── decision_provider.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   ├── utils/                  # Utilities & Helpers
│   │   │   ├── constants.dart
│   │   │   ├── colors.dart
│   │   │   ├── validators.dart
│   │   │   └── helpers.dart
│   │   │
│   │   └── routes/                 # Navigation
│   │       └── app_routes.dart
│   │
│   ├── assets/                     # Static Assets
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   │
│   ├── test/                       # Unit & Widget Tests
│   │
│   ├── pubspec.yaml                # Flutter Dependencies
│   └── README.md
│
├── backend/                        # Node.js Backend (Future)
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   │   ├── decision_engine/
│   │   │   │   └── saw_calculator.js
│   │   │   └── ai_service/
│   │   │       └── llm_integration.js
│   │   └── middleware/
│   │
│   ├── package.json
│   └── README.md
│
├── design/                         # UI/UX Design Files
│   ├── figma/
│   ├── wireframes/
│   └── mockups/
│
└── README.md                       # Main Documentation

```

## ✅ Checklist Persiapan Sebelum Frontend Development

### 1. **Environment Setup**
- [ ] Install Flutter SDK (latest stable version)
- [ ] Install Dart SDK
- [ ] Install Android Studio + Android SDK
- [ ] Setup Android Emulator atau Physical Device
- [ ] Install VS Code + Flutter Extension
- [ ] Configure Git & GitHub

### 2. **Design System Review**
- [ ] Review Figma prototype
- [ ] Identifikasi color palette
- [ ] Identifikasi typography (fonts)
- [ ] Dokumentasi component library
- [ ] Export assets (icons, images)

### 3. **Dependencies Planning**

**Essential Flutter Packages:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1              # State management
  
  # UI Components
  google_fonts: ^6.1.0          # Typography
  flutter_svg: ^2.0.9           # SVG icons
  
  # Navigation
  go_router: ^12.1.1            # Navigation
  
  # Backend Integration
  http: ^1.1.0                  # API calls
  supabase_flutter: ^2.0.0      # Supabase client
  
  # Storage
  shared_preferences: ^2.2.2    # Local storage
  
  # Forms & Validation
  formz: ^0.6.1                 # Form validation
  
  # Charts (for comparison/visualization)
  fl_chart: ^0.65.0             # Charts library
  
  # Utilities
  intl: ^0.18.1                 # Internationalization
  logger: ^2.0.2                # Logging

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1         # Linting
  mockito: ^5.4.4               # Testing
```

### 4. **Design Tokens to Define**

```dart
// colors.dart
class AppColors {
  // Primary Colors
  static const primary = Color(0xFF...);
  static const secondary = Color(0xFF...);
  
  // Status Colors
  static const success = Color(0xFF...);
  static const warning = Color(0xFF...);
  static const error = Color(0xFF...);
  
  // Neutral Colors
  static const background = Color(0xFF...);
  static const surface = Color(0xFF...);
  static const textPrimary = Color(0xFF...);
  static const textSecondary = Color(0xFF...);
  
  // Category Colors
  static const technology = Color(0xFF...);
  static const education = Color(0xFF...);
  static const fashion = Color(0xFF...);
}

// typography.dart
class AppTypography {
  static const displayLarge = TextStyle(...);
  static const headlineLarge = TextStyle(...);
  static const titleLarge = TextStyle(...);
  static const bodyLarge = TextStyle(...);
  static const labelLarge = TextStyle(...);
}

// spacing.dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}
```

### 5. **Data Models to Create**

```dart
// 1. User Model
class User {
  String id;
  String email;
  String name;
  String role;  // 'user' or 'admin'
  String plan;  // 'basic' or 'premium'
}

// 2. Category Model
class Category {
  String id;
  String name;          // 'Technology', 'Education', 'Fashion'
  String description;
  String iconPath;
  Color color;
}

// 3. Alternative Model
class Alternative {
  String id;
  String name;
  String categoryId;
  Map<String, dynamic> attributes;  // Dynamic attributes
  String source;        // 'catalog' or 'custom'
}

// 4. Criteria Model
class Criteria {
  String id;
  String name;
  String type;          // 'benefit' or 'cost'
  String unit;
  double weight;        // 0-100
}

// 5. Decision Model
class Decision {
  String id;
  String userId;
  String categoryId;
  List<Alternative> alternatives;
  List<Criteria> criterias;
  Map<String, Map<String, double>> decisionMatrix;  // [alternativeId][criteriaId] = value
  DateTime createdAt;
  String status;        // 'draft', 'completed'
}

// 6. Result Model
class DecisionResult {
  String decisionId;
  List<RankedAlternative> ranking;
  String aiExplanation;
  Map<String, double> normalizedMatrix;
  Map<String, double> weightedMatrix;
  DateTime calculatedAt;
}

class RankedAlternative {
  Alternative alternative;
  double finalScore;
  int rank;
}
```

### 6. **API Endpoints Planning**

```
Auth:
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
GET    /api/auth/profile

Decisions:
GET    /api/decisions                 # List user decisions
POST   /api/decisions                 # Create new decision
GET    /api/decisions/:id             # Get decision detail
PUT    /api/decisions/:id             # Update decision
DELETE /api/decisions/:id             # Delete decision

Categories:
GET    /api/categories                # List all categories
GET    /api/categories/:id            # Get category detail

Alternatives:
GET    /api/alternatives?category=:id # List alternatives by category
POST   /api/alternatives              # Add custom alternative
GET    /api/alternatives/:id          # Get alternative detail

Criteria:
GET    /api/criteria?category=:id     # List criteria by category
POST   /api/criteria                  # Add custom criteria

Decision Engine:
POST   /api/decision-engine/calculate # Calculate SAW result
POST   /api/decision-engine/simulate  # What-if simulation

AI Service:
POST   /api/ai/suggest-criteria       # AI suggest criteria
POST   /api/ai/explain-result         # AI explain result
POST   /api/ai/explain-change         # AI explain simulation change

Admin:
GET    /api/admin/users               # List users
PUT    /api/admin/users/:id           # Update user
DELETE /api/admin/users/:id           # Deactivate user
POST   /api/admin/catalog             # Add catalog item
PUT    /api/admin/catalog/:id         # Update catalog item
DELETE /api/admin/catalog/:id         # Delete catalog item
```

### 7. **Component Library to Build**

**Atoms (Basic Components):**
- [ ] AppButton (primary, secondary, outline)
- [ ] AppTextField
- [ ] AppDropdown
- [ ] AppSlider (for weight input)
- [ ] AppCheckbox
- [ ] AppRadio
- [ ] AppIcon
- [ ] AppBadge
- [ ] AppChip

**Molecules (Composite Components):**
- [ ] CategoryCard
- [ ] AlternativeCard
- [ ] CriteriaRow
- [ ] WeightSlider (with percentage)
- [ ] RankingCard
- [ ] ComparisonTable
- [ ] EmptyState
- [ ] LoadingState
- [ ] ErrorState

**Organisms (Complex Components):**
- [ ] AppNavBar
- [ ] DecisionStepper (progress indicator)
- [ ] AlternativeList
- [ ] CriteriaManager
- [ ] ResultDashboard
- [ ] SimulationPanel

### 8. **Screen Flow to Implement**

**Phase 1: Authentication & Dashboard**
1. Splash Screen
2. Login Screen
3. Register Screen
4. Dashboard Screen

**Phase 2: Decision Making Core**
5. Category Selection Screen
6. Choice Management Screen
7. Criteria Input Screen
8. Result Screen

**Phase 3: Advanced Features**
9. Comparison Screen
10. What-If Simulation Screen
11. Decision History Screen

**Phase 4: Admin**
12. User Management Screen
13. Catalog Management Screen

### 9. **State Management Strategy**

```dart
// Provider Structure
DecisionProvider {
  - currentDecision
  - selectedCategory
  - alternatives[]
  - criteria[]
  - decisionMatrix{}
  - result
  
  Methods:
  - createDecision()
  - addAlternative()
  - addCriteria()
  - updateWeight()
  - calculateResult()
  - saveDecision()
}

AuthProvider {
  - currentUser
  - isAuthenticated
  - isLoading
  
  Methods:
  - login()
  - register()
  - logout()
  - checkAuth()
}

HistoryProvider {
  - decisions[]
  - isLoading
  
  Methods:
  - fetchHistory()
  - getDecisionById()
  - deleteDecision()
}
```

### 10. **Testing Strategy**

- [ ] Unit Tests for models
- [ ] Unit Tests for services
- [ ] Widget Tests for components
- [ ] Integration Tests for user flows
- [ ] E2E Tests for critical paths

### 11. **Performance Considerations**

- [ ] Lazy loading for decision history
- [ ] Image optimization
- [ ] API response caching
- [ ] Debouncing for search/filter
- [ ] Pagination for large lists

### 12. **Accessibility**

- [ ] Semantic labels for screen readers
- [ ] Sufficient color contrast (WCAG AA)
- [ ] Touch target size (min 44x44)
- [ ] Keyboard navigation support
- [ ] Error messages in English

---

## 🎨 Yang Saya Butuhkan dari Anda:

1. **Desain Figma/UI/UX** untuk semua halaman
2. **Color Palette** yang akan digunakan
3. **Typography** (font family, sizes)
4. **Icon Set** (custom atau library seperti Heroicons)
5. **Logo & Branding Assets**
6. **Sample Data** untuk kategori, alternatif, dan kriteria

---

## ⚡ Siap Lanjut!

Semua struktur dan persiapan sudah terdokumentasi. Kirimkan desain UI/UX Anda dan saya akan mulai implementasi frontend Flutter! 🚀
