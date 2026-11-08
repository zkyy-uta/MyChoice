# MyChoice Flutter Revisions — Bugfix Design

## Overview

This document formalizes the fix design for 8 bugs identified in the MyChoice Flutter frontend.
Each bug is analysed using the bug-condition methodology: the exact set of inputs that trigger
the defect (C), the desired behavior for those inputs (P), and the inputs that must remain
unchanged (¬C). The document covers:

1. What-If Simulation — `_getDisplayName()` returns Indonesian strings
2. History Detail — review section is read-only with hardcoded data
3. Resume Navigation — `_resumeDecision()` passes no route arguments
4. Criteria–Subcategory Sync — criteria list is hardcoded; changing subcategory has no effect
5. Priority–Criteria Sync — checkbox toggles do not add/remove priority sliders immediately
6. Manual Option + Admin Request — no "request to catalog" button after custom option entry
7. Option Specifications — `Alternative.specs` not rendered in `create_decision_screen.dart`
8. Admin Naming Consistency — `AdminUser.plan` is a free-form `String` with no validation

---

## Glossary

- **Bug_Condition (C)**: The set of inputs that trigger the defective behavior.
- **Property (P)**: The correct behavior the fixed function must exhibit when C holds.
- **Preservation (¬C)**: Inputs for which the original behavior must be unchanged.
- **`_getDisplayName`**: Private method in `WhatIfScreen` (`what_if_screen.dart`) that maps a criterion ID to a human-readable label.
- **`_resumeDecision`**: Private method in `_ContinueDecisionScreenState` (`continue_decision_screen.dart`) that navigates to the Create Decision screen.
- **`_selectedCriteria`**: `Map<String, bool>` in `_CreateDecisionScreenState` tracking which criteria are checked.
- **`_priorities`**: `Map<String, double>` in `_CreateDecisionScreenState` tracking weight per criterion.
- **`InProgressDecision`**: Value object in `continue_decision_screen.dart` carrying the draft decision data.
- **`HistoryDecision`**: Value object in `history_detail_screen.dart` carrying completed decision data including optional review/rating.
- **`AdminUser`**: Model in `admin_user.dart` representing a user record in the admin panel.
- **`UserPlanTier`**: Enum in `user_plan.dart` with values `guest`, `basic`, `premium`, `admin`.
- **`Alternative.specs`**: Optional `Map<String, dynamic>` on the `Alternative` entity holding key-value spec data.

---

## Bug Details

### Issue 1 — What-If Simulation: Language

#### Bug Condition

The bug manifests when `_getDisplayName` is called with any of the known criterion IDs.
Every branch in the current `switch` statement hard-returns an Indonesian string, even
when the input is the canonical English ID.

```
FUNCTION isBugCondition_issue1(critId)
  INPUT:  critId of type String
  OUTPUT: boolean

  RETURN critId.toLowerCase() IN
           ['price', 'harga', 'performance', 'performa',
            'battery', 'battery life', 'baterai',
            'storage', 'penyimpanan', 'weight', 'berat']
END FUNCTION
```

#### Examples

| Input (`critId`) | Current output (defective) | Expected output |
|------------------|---------------------------|-----------------|
| `'price'`        | `'Harga'`                 | `'Price'`       |
| `'performance'`  | `'Performa'`              | `'Performance'` |
| `'battery'`      | `'Baterai'`               | `'Battery Life'`|
| `'storage'`      | `'Penyimpanan'`           | `'Storage'`     |
| `'weight'`       | `'Berat'`                 | `'Weight'`      |
| `'custom_crit'`  | `'custom_crit'`           | `'custom_crit'` |

---

### Issue 2 — History Detail: Review Section

#### Bug Condition

The bug manifests when the `HistoryDetailScreen` renders the "Your Review" section.
The current implementation always renders the review text and star rating as static
`Text` and `Icon` widgets — there is no `TextField`, no star-rating selector, and no
submit action.

```
FUNCTION isBugCondition_issue2(decision)
  INPUT:  decision of type HistoryDecision
  OUTPUT: boolean

  RETURN true   // every call to HistoryDetailScreen is affected;
                // the review section is always read-only
END FUNCTION
```

#### Examples

- A decision with `review = ''` and `rating = 0`: the screen shows an empty text and
  zero stars with no way to add a review.
- A decision with `review = 'Performance sesuai dengan kebutuhan.'` and `rating = 5`:
  the screen shows the text as a static label with no edit affordance.

---

### Issue 3 — Resume Navigation

#### Bug Condition

The bug manifests when `_resumeDecision` is called. The method calls
`Navigator.of(context).pushNamed('/create-decision')` without passing
any arguments, so the `CreateDecisionScreen` initializes with all-null
`initialCategory`, `initialSubcategory`, `initialOptions`, and `initialPriorities`.

```
FUNCTION isBugCondition_issue3(decision)
  INPUT:  decision of type InProgressDecision
  OUTPUT: boolean

  RETURN true   // every call to _resumeDecision is affected;
                // no arguments are ever passed
END FUNCTION
```

#### Examples

- Tap "Resume Decision" on the Laptop draft → Create Decision screen opens with
  category = null, blank options list, default criteria.
- Tap "Resume Decision" on the Course draft → same blank state, ignoring the
  `Education` category and course options.

---

### Issue 4 — Criteria–Subcategory Sync

#### Bug Condition

The bug manifests when a user selects any subcategory in `CreateDecisionScreen`.
`_selectSubcategory` only sets `_selectedSubcategory`; it never updates
`_selectedCriteria` or `_priorities`.  Those maps are initialised once at
declaration time with a fixed Technology-Laptop set
(`Price`, `Performance`, `Battery`, `Weight`, `Storage`).

```
FUNCTION isBugCondition_issue4(subcategory)
  INPUT:  subcategory of type String
  OUTPUT: boolean

  RETURN subcategory != null
         AND criteriaAreStillHardcodedTechSet(_selectedCriteria)
END FUNCTION
```

#### Examples

- Select "Fashion" → criteria list still shows Price/Performance/Battery/Weight/Storage
  instead of Style/Design, Comfort, Durability, Material Quality.
- Switch from "Laptop" to "Smartphone" → `Storage` and `Battery` remain; there is
  no `Display Size` or `Camera` criterion.
- Select "Course" (Education) → criteria list still shows hardware specs like Battery.

---

### Issue 5 — Priority–Criteria Sync

#### Bug Condition

Three sub-cases all stem from the same root: `_priorities` is not kept in sync with
`_selectedCriteria`.

```
FUNCTION isBugCondition_issue5(action)
  INPUT:  action of type {CHECK | UNCHECK | ADD_AND_SELECT}
  OUTPUT: boolean

  IF action == UNCHECK
    RETURN _priorities still contains the criterion key after uncheck
  IF action == ADD_AND_SELECT
    RETURN _priorities does NOT contain the new criterion after it is
           added via dialog AND immediately checked
  RETURN false
END FUNCTION
```

#### Examples

- Uncheck "Battery" → the Battery slider remains visible in the Priority section.
- Add custom criterion "Durability", then check it → no slider appears until the user
  leaves and returns to the section.
- `_saveNewCriteria` adds to `_priorities` with weight 0 regardless of whether the
  user selected it; `_toggleCriteria` never touches `_priorities`.

---

### Issue 6 — Manual Option + Admin Request

#### Bug Condition

The bug manifests when a user types a custom option name in the "Not in the list?"
inline text field inside `_buildOptionsSection` of `CreateDecisionScreen` and taps "+".
After the option is added to `_selectedOptions`, there is no "Request to catalog" button
shown and no network/notification path to the admin panel.

```
FUNCTION isBugCondition_issue6(option)
  INPUT:  option of type String with source == 'custom'
  OUTPUT: boolean

  RETURN option was just added to _selectedOptions
         AND no catalog-request UI was presented to the user
END FUNCTION
```

#### Examples

- User types "Samsung Galaxy Tab S9 FE" (not in Tablet catalog) and taps "+":
  item appears in selected list but there is no "Request to add to catalog" affordance.
- User types a completely new product name: same — no request mechanism exists.

---

### Issue 7 — Option Specifications

#### Bug Condition

Two sub-cases:

```
FUNCTION isBugCondition_issue7(alternative, screen)
  INPUT:  alternative of type Alternative, screen of type String
  OUTPUT: boolean

  RETURN (screen == 'create_decision_screen'
          AND alternative.source == 'catalog'
          AND alternative.specs != null
          AND alternative.specs.isNotEmpty
          AND specsNotRendered(screen, alternative))
         OR
         (alternative.source == 'catalog'
          AND alternative.specs == null OR alternative.specs.isEmpty)
END FUNCTION
```

#### Examples

- In `create_decision_screen.dart` the available-options list renders each option
  as a plain `Text` widget. Even if the `Alternative` object in mock data has
  `specs: {'processor': 'M3', 'ram': '36GB', ...}`, none of that is shown.
- Subcategories like `bags`, `shoes`, `dress`, `accessories` have no entries in
  `MockAlternativeDataSource._getMockAlternatives`, so they fall through to an
  empty list and could never show specs.

---

### Issue 8 — Admin Naming Consistency

#### Bug Condition

```
FUNCTION isBugCondition_issue8(adminUser)
  INPUT:  adminUser of type AdminUser
  OUTPUT: boolean

  RETURN NOT (adminUser.plan IN ['Guest', 'Basic', 'Premium', 'Admin'])
         OR adminUser.recentDecisionSubcategory == null
END FUNCTION
```

#### Examples

- A developer adds `plan: 'premium'` (lower-case) to `demoAdminUsers` — the
  badge renders inconsistently but no compile-time or run-time error is thrown.
- The `_UserDetailsDialog` shows `user.plan` as a raw string but never cross-checks
  it against `UserPlanTier`.
- The `_UserCard` shows no decision history or subcategory context, so an admin
  cannot verify that a "Laptop" user's plan limits are being respected.

---

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**

3.1 WHEN a user adjusts What-If sliders, the ranking recalculation and original/simulated
comparison modal MUST continue to work correctly.

3.2 WHEN the Continue Decision screen has no drafts, the empty-state UI with
"Create New Decision" MUST continue to be shown.

3.3 WHEN a completed decision is viewed in History, the Decision Date, Final Score,
Your Priorities, and Decision Status sections MUST remain read-only.

3.4 WHEN a category is selected but no subcategory has been chosen yet, the subcategory
chip selector MUST continue to appear without loading criteria or options.

3.5 WHEN a user toggles criteria checkboxes (for any subcategory's criteria), the
checkbox visual state MUST continue to update immediately.

3.6 WHEN a user adds a custom alternative via the inline field in Create Decision, it
MUST continue to appear in `_selectedOptions` just as it does today.

3.7 WHEN the AlternativeManagementScreen renders catalog alternatives that have a
non-null, non-empty `specs` map, it MUST continue to show the first two spec entries as
secondary text in the list item.

3.8 WHEN an admin deactivates a user account via the confirmation dialog, the status
MUST continue to update to `inactive` and the confirmation snackbar MUST be shown.

3.9 WHEN the admin applies Active/Inactive status filters, the user list MUST continue
to filter without resetting other state.

3.10 WHEN the Create Decision flow completes with priorities summing to 100%, navigation
to the Result screen MUST continue to work with the correct ranked choices.

**Note:** Expected correct behaviors for each bug condition are defined individually in
the Correctness Properties section below.

---

## Hypothesized Root Cause

### Issue 1 — `_getDisplayName`

The switch-case was written returning Indonesian strings throughout, most likely when the
app was prototyped for a local audience. No mapping to English was ever added, and the
`default` branch (which correctly returns `critId` unchanged) was never used for the
known IDs.

### Issue 2 — History Detail Review

`HistoryDecision` stores `review` and `rating` as constructor fields with defaults.
`HistoryDetailScreen` is a `StatelessWidget` and simply reads those fields as text. No
`StatefulWidget` or text-editing state was ever introduced. The screen was likely built
as a read-only display first, with the intent to add editing later — but that step was
never completed.

### Issue 3 — Resume Navigation

`_resumeDecision` calls `pushNamed('/create-decision')` without a second `arguments`
argument. While `CreateDecisionScreen` already has `initialCategory`,
`initialSubcategory`, `initialOptions`, and `initialPriorities` constructor parameters,
the route in `app.dart` instantiates it without reading `RouteSettings.arguments`, so
even if arguments were passed they would be silently dropped.

### Issue 4 — Criteria–Subcategory Sync

`_selectSubcategory` only assigns `_selectedSubcategory`. There is no
`_criteriaBySubcategory` map, and `_selectedCriteria` / `_priorities` are top-level
`final` fields initialised with a hard-coded Technology set. There was never any code
that resets them when the subcategory changes.

### Issue 5 — Priority–Criteria Sync

`_toggleCriteria` only flips the boolean in `_selectedCriteria`. It never updates
`_priorities`. `_buildPrioritySliders` iterates over `_priorities.entries`, so it will
only show sliders for keys that already exist in `_priorities` — unchecked criteria are
never removed, and newly-checked criteria that were added with `false` via
`_saveNewCriteria` have a `_priorities` entry (at weight 0) but one that is only
correctly connected once the user manually sliders.  The real-time removal on uncheck is
missing because `_toggleCriteria` does not call `_priorities.remove(key)`.

### Issue 6 — Manual Option + Admin Request

The inline custom-entry UI in `_buildOptionsSection` was built to satisfy the local
"add custom option" requirement only. No admin notification subsystem or catalog-request
UI flow was ever designed for this screen. The `AlternativeManagementScreen` flow also
lacks this button, confirming it was out of scope originally.

### Issue 7 — Option Specifications

`create_decision_screen.dart` owns its own `_optionsBySubcategory` map of plain
`List<String>` and renders each option as a plain `Text` widget. It never uses the
`Alternative` entity or its `specs` field — the two screens (`alternative_management_screen`
and `create_decision_screen`) implement option listing independently. Furthermore,
the `MockAlternativeDataSource` only covers `laptop`, `smartphone`, `course`, and a few
others; Fashion, Accessories, Bags, Shoes, Dress, Outerwear, Jewelry have no entries and
no spec data.

### Issue 8 — Admin Naming Consistency

`AdminUser.plan` is declared as `String`, making it impossible for the compiler to
catch typos or casing mismatches against `UserPlanTier`. `demoAdminUsers` happens to
use `'Basic'` and `'Premium'` which match `UserPlan.name`, but there is no runtime
assertion or enum constraint. Additionally, `AdminUser` carries no decision-history or
subcategory fields at all, so the admin screen cannot display that context.

---

## Correctness Properties

Property 1: Bug Condition — `_getDisplayName` returns English labels

_For any_ criterion ID where `isBugCondition_issue1(critId)` is true (i.e., the ID is
one of the known criterion keys), the fixed `_getDisplayName` function SHALL return the
canonical English display name: `'price'` → `'Price'`, `'performance'` → `'Performance'`,
`'battery'`/`'battery life'` → `'Battery Life'`, `'storage'` → `'Storage'`,
`'weight'` → `'Weight'`. For any unknown ID the function SHALL return the ID unchanged.

**Validates: Requirements 2.1, 2.2**

---

Property 2: Preservation — What-If slider behavior unchanged

_For any_ user interaction that does NOT involve reading criterion labels (slider drags,
total-weight validation, "Run Simulation" tap, modal display), the fixed `WhatIfScreen`
SHALL produce exactly the same behavior as the original screen.

**Validates: Requirements 3.1**

---

Property 3: Bug Condition — History Detail review is editable when no review exists

_For any_ `HistoryDecision` where `review` is empty or the decision has not been reviewed
yet, the fixed `HistoryDetailScreen` SHALL display a `TextFormField` for review text and
an interactive star-rating widget, along with a "Submit Review" button that saves the
review text and rating back to the decision object.

**Validates: Requirements 2.3, 2.4**

---

Property 4: Bug Condition — History Detail shows saved review with edit option

_For any_ `HistoryDecision` where a non-empty `review` and a positive `rating` are
already saved, the fixed screen SHALL display them as before AND additionally provide an
"Edit" button that switches the section into editable mode.

**Validates: Requirements 2.5**

---

Property 5: Preservation — History Detail read-only sections unchanged

_For any_ `HistoryDecision`, the Decision Date, Final Score, Your Priorities, and
Decision Status sections SHALL remain read-only and visually identical to the current
implementation.

**Validates: Requirements 3.3**

---

Property 6: Bug Condition — `_resumeDecision` passes full draft data

_For any_ `InProgressDecision` object passed to `_resumeDecision`, the fixed method
SHALL navigate to `/create-decision` with a `RouteArguments` object containing
`category`, `subcategory`, `options`, and `priorities` from that draft. The
`CreateDecisionScreen` SHALL read those arguments in `didChangeDependencies` (or
`initState` after extracting from `ModalRoute`) and initialise its state accordingly.

**Validates: Requirements 2.6, 2.7**

---

Property 7: Preservation — Resume navigation empty-state unchanged

_For any_ scenario where `_draftDecisions` is empty, the empty-state UI and the
"Create New Decision" button SHALL continue to navigate to `/create-decision` with no
arguments, resulting in a blank form as before.

**Validates: Requirements 3.2**

---

Property 8: Bug Condition — Criteria reset on subcategory change

_For any_ subcategory selection event where the new subcategory differs from the
previously selected one, the fixed `_selectSubcategory` SHALL replace `_selectedCriteria`
with the default criteria map for the new subcategory and SHALL clear `_priorities` to
match (retaining only keys that are selected by default in the new subcategory).

**Validates: Requirements 2.8, 2.9**

---

Property 9: Preservation — Category/subcategory chip behavior unchanged

_For any_ user interaction with category cards or subcategory chips that does NOT
trigger a criteria reset (e.g., selecting the same subcategory again, or selecting a
category before choosing a subcategory), the visual state update behavior SHALL remain
unchanged.

**Validates: Requirements 3.4**

---

Property 10: Bug Condition — Checkbox toggle immediately syncs priority sliders

_For any_ criterion key K in `_selectedCriteria`:
- If `_selectedCriteria[K]` transitions from `false` → `true`, the fixed `_toggleCriteria`
  SHALL immediately add `K: 0.0` to `_priorities` so a slider appears.
- If `_selectedCriteria[K]` transitions from `true` → `false`, the fixed `_toggleCriteria`
  SHALL immediately call `_priorities.remove(K)` so the slider disappears.

**Validates: Requirements 2.10, 2.11**

---

Property 11: Bug Condition — New custom criterion slider appears when selected

_For any_ custom criterion added via `_saveNewCriteria` with an initial value of
`_selectedCriteria[name] = false`, if the user subsequently checks that criterion, the
slider SHALL appear immediately (covered by Property 10). The `_saveNewCriteria` method
SHALL NOT add the key to `_priorities` at insertion time — only the checkbox toggle does.

**Validates: Requirements 2.12**

---

Property 12: Preservation — Existing criteria checkbox visual state unchanged

_For any_ criterion that was already in `_selectedCriteria` before the fix, toggling
its checkbox SHALL continue to update the checkbox visual state in real time as before.

**Validates: Requirements 3.5**

---

Property 13: Bug Condition — "Request to catalog" button appears after custom option add

_For any_ custom option string submitted in `_buildOptionsSection` (i.e., an option not
found in `_optionsBySubcategory`), immediately after the option is added to
`_selectedOptions`, the fixed UI SHALL display a "Request to add to catalog" button (or
snackbar action) adjacent to that option's row. Tapping it SHALL send a catalog-request
payload (at minimum: `{optionName, category, subcategory, userId, timestamp}`) to the
admin notification system and SHALL show a confirmation message to the user.

**Validates: Requirements 2.13, 2.14**

---

Property 14: Preservation — Custom option add continues to work

_For any_ custom option submission, the option SHALL continue to be added to
`_selectedOptions` exactly as before. The catalog-request button is additive and SHALL
NOT block or modify the existing add behavior.

**Validates: Requirements 3.6**

---

Property 15: Bug Condition — Specs rendered in `create_decision_screen`

_For any_ alternative in `_availableOptions` that has a corresponding `Alternative`
entity with a non-empty `specs` map, the fixed option list item in
`_buildOptionsSection` SHALL render the top 2–3 spec entries as secondary text beneath
the option name, matching the existing `_AlternativeListItem` style in
`alternative_management_screen.dart`.

**Validates: Requirements 2.15, 2.16**

---

Property 16: Bug Condition — All catalog subcategories have spec data

_For any_ subcategory available in the Create Decision screen
(`Laptop`, `Smartphone`, `Tablet`, `Monitor`, `Gaming PC`, `Processor`, `Graphics Card`,
`Course`, `Certification`, `Bootcamp`, `University`, `Training Program`,
`Dress`, `Shoes`, `Accessories`, `Bags`, `Jewelry`, `Outerwear`), the
`MockAlternativeDataSource._getMockAlternatives` SHALL return at least 2 `Alternative`
entries, each with a non-empty `specs` map containing attributes appropriate to the
subcategory.

**Validates: Requirements 2.17**

---

Property 17: Preservation — Existing catalog specs rendering in AlternativeManagementScreen

_For any_ alternative displayed in `AlternativeManagementScreen` that already has a
non-null, non-empty `specs` map, the `_AlternativeListItem` widget SHALL continue to
render the first two spec entries as secondary text exactly as before.

**Validates: Requirements 3.7**

---

Property 18: Bug Condition — `AdminUser.plan` validated against `UserPlanTier`

_For any_ `AdminUser` record, `AdminUser.plan` SHALL be typed as `UserPlanTier` (the
enum) rather than `String`. All existing `demoAdminUsers` entries that use string
literals (`'Basic'`, `'Premium'`) SHALL be updated to use the enum values
(`UserPlanTier.basic`, `UserPlanTier.premium`). Display formatting (capitalising the
first letter for the badge) SHALL be derived from the enum at render time.

**Validates: Requirements 2.18, 2.20**

---

Property 19: Bug Condition — Admin user record shows recent decision subcategory

_For any_ `AdminUser` record displayed in the User Management screen, the fixed
`_UserCard` and `_UserDetailsDialog` SHALL show the subcategory (or decision category)
associated with the user's most recent decision activity. This field SHALL be stored as
`recentDecisionSubcategory` on `AdminUser` (nullable `String`) and populated in
`demoAdminUsers`.

**Validates: Requirements 2.19**

---

Property 20: Preservation — Admin deactivation and filter flows unchanged

_For any_ admin deactivation action or status-filter application that does NOT involve
the plan-label display, the behavior SHALL remain identical to the current
implementation.

**Validates: Requirements 3.8, 3.9**

---

## Fix Implementation

### Issue 1 — `_getDisplayName` in `what_if_screen.dart`

**File**: `mychoice_app/lib/screens/user/decision/what_if_screen.dart`
**Function**: `_WhatIfScreenState._getDisplayName`

**Specific Changes**:
1. Replace every Indonesian return value with its English equivalent.
2. Retain the `default` branch that returns `critId` unchanged for unknown IDs.

```dart
String _getDisplayName(String critId) {
  switch (critId.toLowerCase()) {
    case 'price':
    case 'harga':
      return 'Price';
    case 'performance':
    case 'performa':
      return 'Performance';
    case 'battery':
    case 'battery life':
    case 'baterai':
      return 'Battery Life';
    case 'storage':
    case 'penyimpanan':
      return 'Storage';
    case 'weight':
    case 'berat':
      return 'Weight';
    default:
      return critId;
  }
}
```

---

### Issue 2 — History Detail Review in `history_detail_screen.dart`

**File**: `mychoice_app/lib/screens/user/history/history_detail_screen.dart`

**Specific Changes**:
1. Convert `HistoryDetailScreen` from `StatelessWidget` to `StatefulWidget`.
2. Add state: `_isEditingReview`, `_reviewController` (`TextEditingController`),
   `_currentRating` (`int`).
3. On `initState`, seed `_reviewController.text = widget.decision.review` and
   `_currentRating = widget.decision.rating`.
4. Replace the static "Your Review" section with a conditional widget:
   - If `decision.review.isEmpty` OR `_isEditingReview` is true:
     render an editable star-rating row (5 `IconButton` stars toggling
     `_currentRating`) and a `TextFormField` bound to `_reviewController`,
     followed by a "Submit Review" `ElevatedButton`.
   - Otherwise: render the existing read-only star row and `Text`, plus an
     "Edit" `TextButton` that sets `_isEditingReview = true`.
5. The "Submit Review" button calls a `_submitReview()` method that:
   - Updates the matching entry in `historySampleDecisions` with the new
     `review` text and `rating`.
   - Resets `_isEditingReview = false`.
   - Shows a success `SnackBar`.

---

### Issue 3 — Resume Navigation in `continue_decision_screen.dart`

**File**: `mychoice_app/lib/screens/user/decision/continue_decision_screen.dart`

**Specific Changes**:
1. In `_resumeDecision`, pass `arguments` to `pushNamed`:
   ```dart
   void _resumeDecision(InProgressDecision decision) {
     Navigator.of(context).pushNamed(
       '/create-decision',
       arguments: {
         'category': decision.category,
         'subcategory': decision.subcategory,
         'options': List<String>.from(decision.options),
         'priorities': Map<String, double>.from(decision.priorities),
       },
     );
   }
   ```
2. In `app.dart` (or wherever `/create-decision` is registered), update the
   route builder to extract arguments:
   ```dart
   '/create-decision': (context) {
     final args = ModalRoute.of(context)?.settings.arguments
         as Map<String, dynamic>?;
     return _protectedRoute(
       CreateDecisionScreen(
         initialCategory: args?['category'] as String?,
         initialSubcategory: args?['subcategory'] as String?,
         initialOptions: (args?['options'] as List?)?.cast<String>(),
         initialPriorities: (args?['priorities'] as Map?)
             ?.cast<String, double>(),
       ),
     );
   },
   ```
3. `CreateDecisionScreen.initState` already handles the four `initial*`
   parameters — no further changes needed there.

---

### Issue 4 — Criteria–Subcategory Sync in `create_decision_screen.dart`

**File**: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`

**Specific Changes**:
1. Add a `_criteriaBySubcategory` constant map of type
   `Map<String, Map<String, bool>>` inside `_CreateDecisionScreenState`.
   Each entry maps a subcategory name to its default criteria with initial
   checked state. Example entries:
   ```
   'Laptop':      {'Price': true, 'RAM': true, 'Storage': true, 'Processor Speed': true, 'Battery Life': true, 'Weight': false}
   'Smartphone':  {'Price': true, 'Display Size': true, 'Camera': true, 'Battery': true, 'Storage': true, 'Performance': false}
   'Tablet':      {'Price': true, 'Display Size': true, 'Performance': true, 'Battery': true, 'Storage': false}
   'Monitor':     {'Price': true, 'Resolution': true, 'Refresh Rate': true, 'Panel Type': false, 'Response Time': false}
   'Gaming PC':   {'Price': true, 'GPU': true, 'CPU': true, 'RAM': true, 'Storage': false}
   'Processor':   {'Price': true, 'Core Count': true, 'Clock Speed': true, 'TDP': false}
   'Graphics Card':{'Price': true, 'VRAM': true, 'Performance': true, 'TDP': false}
   'Course':      {'Price': true, 'Duration': true, 'Rating': true, 'Level': false, 'Platform': false}
   'Certification':{'Price': true, 'Difficulty': true, 'Recognition': true, 'Validity': false}
   'Bootcamp':    {'Price': true, 'Duration': true, 'Career Support': true, 'Rating': false}
   'University':  {'Tuition': true, 'Ranking': true, 'Research Output': true, 'Acceptance Rate': false}
   'Training Program': {'Price': true, 'Duration': true, 'Certification Included': false}
   'Dress':       {'Price': true, 'Style': true, 'Material Quality': true, 'Comfort': false}
   'Shoes':       {'Price': true, 'Comfort': true, 'Durability': true, 'Style': false}
   'Accessories': {'Price': true, 'Brand Reputation': true, 'Durability': true, 'Style': false}
   'Bags':        {'Price': true, 'Capacity': true, 'Durability': true, 'Brand': false, 'Material': false}
   'Jewelry':     {'Price': true, 'Material': true, 'Design': true, 'Brand': false}
   'Outerwear':   {'Price': true, 'Warmth': true, 'Water Resistance': true, 'Weight': false, 'Style': false}
   ```
2. Modify `_selectSubcategory` to call a new `_resetCriteriaForSubcategory`
   helper after updating `_selectedSubcategory`:
   ```dart
   void _selectSubcategory(String subcategory) {
     setState(() {
       _selectedSubcategory = subcategory;
       _resetCriteriaForSubcategory(subcategory);
     });
   }

   void _resetCriteriaForSubcategory(String subcategory) {
     final defaults = _criteriaBySubcategory[subcategory] ?? {};
     _selectedCriteria
       ..clear()
       ..addAll(defaults);
     _priorities.clear();
     // Seed _priorities only for initially-selected criteria
     for (final entry in defaults.entries) {
       if (entry.value) _priorities[entry.key] = 0.0;
     }
   }
   ```

---

### Issue 5 — Priority–Criteria Sync in `create_decision_screen.dart`

**File**: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`
**Function**: `_toggleCriteria`, `_saveNewCriteria`

**Specific Changes**:
1. Rewrite `_toggleCriteria` to keep `_priorities` in sync:
   ```dart
   void _toggleCriteria(String criteria) {
     setState(() {
       final nowSelected = !(_selectedCriteria[criteria] ?? false);
       _selectedCriteria[criteria] = nowSelected;
       if (nowSelected) {
         _priorities.putIfAbsent(criteria, () => 0.0);
       } else {
         _priorities.remove(criteria);
       }
     });
   }
   ```
2. Rewrite `_saveNewCriteria` to NOT pre-add the new criterion to `_priorities`
   (the user must check the checkbox to include it):
   ```dart
   void _saveNewCriteria(BuildContext context) {
     final name = _newCriteriaController.text.trim();
     if (name.isEmpty || _selectedCriteria.containsKey(name)) {
       Navigator.of(context).pop();
       return;
     }
     setState(() {
       _selectedCriteria[name] = false; // unchecked by default
       // Do NOT add to _priorities until the user checks the box
     });
     Navigator.of(context).pop();
   }
   ```

---

### Issue 6 — Manual Option + Admin Request in `create_decision_screen.dart`

**File**: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`

**Specific Changes**:
1. After a custom option is successfully added to `_selectedOptions` (inside the
   inline custom-entry flow), show a `SnackBar` with an action button:
   ```dart
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text('"$customName" added.'),
       action: SnackBarAction(
         label: 'Request to catalog',
         onPressed: () => _requestCatalogEntry(customName),
       ),
     ),
   );
   ```
2. Add `_requestCatalogEntry(String optionName)` method:
   ```dart
   void _requestCatalogEntry(String optionName) {
     final payload = {
       'optionName': optionName,
       'category': _selectedCategory ?? '',
       'subcategory': _selectedSubcategory ?? '',
       'requestedAt': DateTime.now().toIso8601String(),
     };
     // TODO: send payload to admin notification service via API
     debugPrint('Catalog request: $payload');
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text(
           'Your suggestion has been sent to our team for review.',
         ),
       ),
     );
   }
   ```
3. No changes to the existing add-to-`_selectedOptions` logic — this is additive only.

---

### Issue 7 — Option Specifications

**File 1**: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`

1. Replace the plain `_optionsBySubcategory` `List<String>` lookups with
   `Alternative` entity lookups. Add a `Map<String, List<Alternative>>
   _alternativesBySubcategory` constant (or load from the same
   `MockAlternativeDataSource` used by `AlternativeManagementScreen`).
2. Update `_availableOptions` getter to return `List<Alternative>` instead of
   `List<String>`.
3. Replace the inline list-item rendering in `_buildOptionsSection` with a
   reusable `_CreateDecisionAlternativeItem` widget that mirrors
   `_AlternativeListItem` from `alternative_management_screen.dart`:
   - Primary text: `alternative.name`
   - Secondary text (if `specs` is non-null and non-empty): top 2–3 entries
     formatted as `key: value` joined by ` • `
   - Checked/tapped state and add logic unchanged.

**File 2**: `mychoice_app/lib/features/alternative_management/data/datasources/alternative_datasource.dart`

1. Extend `_getMockAlternatives` with entries for every missing subcategory.
   Required new entries (minimum 2 alternatives with non-empty `specs` each):
   - `'tablet'`, `'monitor'`, `'gaming_pc'`, `'processor'`, `'graphics_card'`
   - `'certification'`, `'bootcamp'`, `'university'`, `'training_program'`
   - `'dress'`, `'shoes'`, `'accessories'`, `'bags'`, `'jewelry'`, `'outerwear'`
2. Spec keys must be appropriate to the subcategory (e.g., `bags` →
   `'capacity'`, `'material'`, `'brand'`, `'price'`;
   `shoes` → `'size_range'`, `'material'`, `'comfort_rating'`, `'price'`).

---

### Issue 8 — Admin Naming Consistency

**File 1**: `mychoice_app/lib/core/models/admin_user.dart`

1. Change `plan` field type from `String` to `UserPlanTier`:
   ```dart
   import '../../entities/user_plan.dart';

   class AdminUser {
     final String id;
     final String name;
     final String email;
     final UserPlanTier plan;           // was: String
     final AdminUserStatus status;
     final String? recentDecisionSubcategory; // new field
     ...
   }
   ```
2. Add `recentDecisionSubcategory` nullable String field.
3. Update `demoAdminUsers` to use `UserPlanTier.basic` / `UserPlanTier.premium`
   and populate `recentDecisionSubcategory` with realistic demo values.
4. Update `copyWith` to accept `UserPlanTier? plan` and
   `String? recentDecisionSubcategory`.

**File 2**: `mychoice_app/lib/screens/admin/users/user_management_screen.dart`

1. In `_UserCard`, replace `Text(user.plan)` with a helper that formats the
   enum for display:
   ```dart
   extension UserPlanTierLabel on UserPlanTier {
     String get displayName {
       switch (this) {
         case UserPlanTier.guest:   return 'Guest';
         case UserPlanTier.basic:   return 'Basic';
         case UserPlanTier.premium: return 'Premium';
         case UserPlanTier.admin:   return 'Admin';
       }
     }
   }
   ```
2. In `_UserCard`, add a third subtitle line showing
   `user.recentDecisionSubcategory` when non-null.
3. In `_UserDetailsDialog`, replace `Text(user.plan)` with
   `Text(user.plan.displayName)`.

---

## Testing Strategy

### Validation Approach

Each fix is validated in two phases:
1. **Exploratory / Fix Checking** — write tests against the unfixed code first to
   confirm the bug is observable, then run the same tests against the fixed code to
   confirm they pass.
2. **Preservation Checking** — property-based tests verify that non-buggy inputs
   produce unchanged behavior after the fix.

---

### Exploratory Bug Condition Checking

**Goal**: Surface concrete counterexamples that confirm the bugs before applying any fix.

| # | Test | Expected failure on unfixed code |
|---|------|----------------------------------|
| 1.E | Call `_getDisplayName('price')`, assert `== 'Price'` | Fails: returns `'Harga'` |
| 1.E | Call `_getDisplayName('performance')`, assert `== 'Performance'` | Fails: returns `'Performa'` |
| 2.E | Render `HistoryDetailScreen` with `review = ''`; assert `find.byType(TextFormField)` finds a widget | Fails: no `TextFormField` exists |
| 2.E | Render `HistoryDetailScreen` with non-empty review; assert `find.byType(TextButton)` finds "Edit" | Fails: no "Edit" button exists |
| 3.E | Call `_resumeDecision(draftLaptop)`; assert last pushed route has non-null arguments | Fails: arguments is null |
| 4.E | Call `_selectSubcategory('Fashion')`; assert `_selectedCriteria` does not contain `'Battery'` | Fails: Battery remains |
| 5.E | Check criterion `'Battery'` to true, then call `_toggleCriteria('Battery')`; assert `_priorities` does not contain `'Battery'` | Fails: key remains |
| 5.E | Call `_saveNewCriteria(ctx)` with name `'Durability'`; then `_toggleCriteria('Durability')`; assert `_priorities['Durability']` == 0.0 | Fails: key already present before toggle OR missing after |
| 6.E | Trigger custom option add; assert `find.text('Request to catalog')` finds a widget (SnackBar action or button) | Fails: no such widget |
| 7.E | Load `_buildOptionsSection` with subcategory `'Laptop'`; assert spec text is present in option rows | Fails: only plain names are shown |
| 8.E | Instantiate `AdminUser(plan: 'freeform')` — should not compile after fix | Passes compilation before fix (String allows it) |

---

### Fix Checking

**Goal**: For all inputs where the bug condition holds, the fixed function produces the
expected behavior.

```
FOR ALL critId WHERE isBugCondition_issue1(critId) DO
  ASSERT _getDisplayName_fixed(critId) IN
    ['Price', 'Performance', 'Battery Life', 'Storage', 'Weight']
END FOR

FOR ALL decision WHERE decision.review.isEmpty DO
  ASSERT HistoryDetailScreen_fixed(decision)
         .contains(TextFormField)
         .contains(starRatingWidget)
         .contains(submitButton)
END FOR

FOR ALL draft WHERE draft IS InProgressDecision DO
  _resumeDecision_fixed(draft)
  ASSERT lastPushedRouteArguments['category'] == draft.category
  ASSERT lastPushedRouteArguments['subcategory'] == draft.subcategory
  ASSERT lastPushedRouteArguments['options'] == draft.options
  ASSERT lastPushedRouteArguments['priorities'] == draft.priorities
END FOR

FOR ALL subcategory WHERE subcategory != _selectedSubcategory DO
  _selectSubcategory_fixed(subcategory)
  ASSERT _selectedCriteria.keys INTERSECT techLaptopDefaults == EMPTY
         OR _selectedCriteria.keys == _criteriaBySubcategory[subcategory].keys
END FOR

FOR ALL criterion WHERE _selectedCriteria[criterion] == true DO
  _toggleCriteria_fixed(criterion)   // uncheck
  ASSERT NOT _priorities.containsKey(criterion)
END FOR

FOR ALL criterion WHERE _selectedCriteria[criterion] == false DO
  _toggleCriteria_fixed(criterion)   // check
  ASSERT _priorities.containsKey(criterion)
END FOR
```

---

### Preservation Checking

**Goal**: For all inputs where the bug condition does NOT hold, the fixed functions
produce the same result as before.

```
FOR ALL critId WHERE NOT isBugCondition_issue1(critId) DO
  ASSERT _getDisplayName_original(critId) == _getDisplayName_fixed(critId)
END FOR

FOR ALL decision WHERE decision.review != '' DO
  ASSERT HistoryDetailScreen_fixed(decision)
         shows same date/score/priorities/status sections as original
END FOR

FOR ALL interaction WHERE NOT involvesKeyboardOrSlider DO
  ASSERT WhatIfScreen_fixed behavior == WhatIfScreen_original behavior
END FOR
```

---

### Unit Tests

**Issue 1**:
- `_getDisplayName('price')` → `'Price'`
- `_getDisplayName('harga')` → `'Price'`
- `_getDisplayName('battery life')` → `'Battery Life'`
- `_getDisplayName('unknown_id')` → `'unknown_id'`

**Issue 2**:
- Widget test: `HistoryDetailScreen` with empty review renders `TextFormField`.
- Widget test: `HistoryDetailScreen` with non-empty review renders read-only text + "Edit" button.
- Widget test: tapping "Edit" switches to editable mode.
- Widget test: tapping "Submit Review" calls update and resets editing state.

**Issue 3**:
- Unit test: `_resumeDecision(laptopDraft)` → `Navigator.pushNamed` called with correct arguments map.
- Widget test: `CreateDecisionScreen` initialized from route arguments populates state fields correctly.

**Issue 4**:
- Unit test: `_selectSubcategory('Fashion')` → `_selectedCriteria` contains `'Style'`, not `'Battery'`.
- Unit test: `_selectSubcategory('Course')` → `_priorities` contains only the `Course` default selected criteria.
- Unit test: `_selectSubcategory('Laptop')` after `_selectSubcategory('Fashion')` → criteria reset correctly.

**Issue 5**:
- Unit test: uncheck criterion → key removed from `_priorities`.
- Unit test: check criterion → key added to `_priorities`.
- Unit test: `_saveNewCriteria` → key NOT in `_priorities` after save, only in `_selectedCriteria` as false.

**Issue 6**:
- Widget test: submit custom option → `SnackBar` with "Request to catalog" action visible.
- Unit test: `_requestCatalogEntry` constructs correct payload with all required fields.

**Issue 7**:
- Widget test: render option list with `Alternative(specs: {'ram': '16GB', 'price': '\$999'})` →
  secondary text contains `'ram: 16GB'`.
- Unit test: `MockAlternativeDataSource.getCatalogAlternatives('bags')` returns ≥ 2 non-empty specs entries.
- Unit test: same for every subcategory in the required list.

**Issue 8**:
- Compile-time check: `AdminUser(plan: 'bad_string')` causes a type error after change to `UserPlanTier`.
- Unit test: `UserPlanTier.basic.displayName == 'Basic'`.
- Widget test: `_UserCard` renders `user.plan.displayName` not `user.plan.toString()`.
- Widget test: `_UserCard` renders `recentDecisionSubcategory` when non-null.

---

### Property-Based Tests

**Issue 1 — Property 1 & 2**:
- Generate random `critId` strings; for known IDs assert English output;
  for unknown IDs assert output equals input.
- Generate random slider interaction sequences; assert simulation results
  are deterministic and match SAW calculation expectations.

**Issue 4 — Property 8**:
- Generate random subcategory selections in arbitrary order; assert that after
  each selection `_selectedCriteria.keys` equals `_criteriaBySubcategory[sub].keys`
  and `_priorities.keys` is a subset of that set.

**Issue 5 — Property 10 & 12**:
- Generate random sequences of check/uncheck operations; assert at every step
  that `_priorities.keys == _selectedCriteria.entries.where(e => e.value).map(e => e.key).toSet()`.

**Issue 8 — Property 18**:
- Generate random `UserPlanTier` values; assert `displayName` always returns a
  non-empty, title-cased string that matches the canonical plan name shown on the
  user-facing Profile and Premium Plan screens.

---

### Integration Tests

- Full Create Decision flow: select Technology → Laptop → criteria auto-populate →
  toggle criteria → priority sliders sync → total = 100% → navigate to Result screen.
- Full Resume flow: tap "Resume Decision" on a draft → Create Decision screen opens
  with correct pre-filled data → user can make a decision from the pre-filled state.
- History Detail review flow: view decision with no review → write review → submit →
  review appears in read-only mode → tap "Edit" → modify → re-submit.
- Admin User Management: create `AdminUser` with `UserPlanTier.basic` →
  card shows `'Basic'` → `recentDecisionSubcategory` is displayed.
- What-If Simulation: open screen for a completed Laptop decision → all
  criterion labels displayed in English → adjust sliders → run simulation →
  result modal shows original vs. simulated ranking correctly.
