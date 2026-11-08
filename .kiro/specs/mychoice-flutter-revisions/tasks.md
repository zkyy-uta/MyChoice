# Implementation Plan

---

## Bug 1 — What-If Simulation: Language (`_getDisplayName`)

- [ ] 1. Write bug condition exploration test for `_getDisplayName` language bug
  - **Property 1: Bug Condition** - `_getDisplayName` Returns Indonesian Strings
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that confirm `_getDisplayName` returns Indonesian instead of English
  - **Scoped PBT Approach**: Scope the property to the five known criterion IDs (`'price'`, `'performance'`, `'battery'`, `'storage'`, `'weight'`) and their Indonesian aliases
  - Test that `_getDisplayName('price')` returns `'Price'` (not `'Harga'`), `_getDisplayName('performance')` returns `'Performance'` (not `'Performa'`), etc. — from Bug Condition `isBugCondition_issue1` in design
  - Test all known IDs including aliases: `'harga'` → `'Price'`, `'baterai'` → `'Battery Life'`, `'battery life'` → `'Battery Life'`, `'penyimpanan'` → `'Storage'`, `'berat'` → `'Weight'`
  - Run test on UNFIXED code
  - **EXPECTED OUTCOME**: Test FAILS (returns `'Harga'`, `'Performa'`, etc. — this proves the bug exists)
  - Document counterexamples found (e.g., `_getDisplayName('price')` returned `'Harga'` instead of `'Price'`)
  - Mark task complete when test is written, run, and failure is documented
  - _Requirements: 1.1, 1.2_

- [ ] 2. Write preservation property test for What-If slider behavior (BEFORE implementing fix)
  - **Property 2: Preservation** - What-If Slider Recalculation Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: slider drag events, "Run Simulation" tap, and modal display on unfixed code all work correctly
  - Write property-based test: for any user interaction that does NOT read criterion labels (slider drags, weight validation, simulation tap, modal display), the `WhatIfScreen` behavior is unchanged
  - Scope to: simulate arbitrary slider value changes and assert that the ranking recalculation output (scores and order) is deterministic and consistent with SAW calculation expectations
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.1_

- [ ] 3. Fix `_getDisplayName` in `what_if_screen.dart`

  - [ ] 3.1 Replace Indonesian return values with English equivalents in `_getDisplayName`
    - File: `mychoice_app/lib/screens/user/decision/what_if_screen.dart`
    - Add `case 'harga':` alias under `case 'price':` → return `'Price'`
    - Add `case 'performa':` alias under `case 'performance':` → return `'Performance'`
    - Add `case 'battery life':` and `case 'baterai':` under `case 'battery':` → return `'Battery Life'`
    - Add `case 'penyimpanan':` alias under `case 'storage':` → return `'Storage'`
    - Add `case 'berat':` alias under `case 'weight':` → return `'Weight'`
    - Retain the `default` branch returning `critId` unchanged for unknown IDs
    - _Bug_Condition: `isBugCondition_issue1(critId)` — critId is one of the known English/Indonesian criterion IDs_
    - _Expected_Behavior: return canonical English display name for known IDs; return `critId` unchanged for unknown IDs_
    - _Preservation: slider recalculation, simulation modal, and all non-label behavior unchanged_
    - _Requirements: 2.1, 2.2, 3.1_

  - [ ] 3.2 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - `_getDisplayName` Returns English Labels
    - **IMPORTANT**: Re-run the SAME test from task 1 — do NOT write a new test
    - The test from task 1 encodes the expected behavior
    - Run `_getDisplayName` exploration test from step 1 on the fixed code
    - **EXPECTED OUTCOME**: Test PASSES (confirms `'price'` → `'Price'`, `'baterai'` → `'Battery Life'`, etc.)
    - _Requirements: 2.1, 2.2_

  - [ ] 3.3 Verify preservation test still passes
    - **Property 2: Preservation** - What-If Slider Recalculation Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 2 — do NOT write new tests
    - Run What-If slider preservation test from step 2
    - **EXPECTED OUTCOME**: Tests PASS (confirms no regressions in slider/simulation behavior)

- [ ] 4. Checkpoint — Bug 1
  - Ensure all Bug 1 tests pass, ask the user if questions arise

---

## Bug 2 — History Detail: Review Section

- [ ] 5. Write bug condition exploration test for History Detail review section
  - **Property 1: Bug Condition** - History Detail Review Section Is Always Read-Only
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing no `TextFormField` or interactive star-rating exists
  - **Scoped PBT Approach**: `isBugCondition_issue2` returns `true` for every `HistoryDecision` — test both the empty-review and non-empty-review cases
  - Case A: render `HistoryDetailScreen` with `review = ''`, `rating = 0`; assert `find.byType(TextFormField)` finds a widget
  - Case B: render `HistoryDetailScreen` with `review = 'Great decision'`, `rating = 4`; assert `find.text('Edit')` finds a widget (edit affordance)
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (no `TextFormField` or Edit button present — this proves the bug exists)
  - Document counterexamples (e.g., `find.byType(TextFormField)` found 0 widgets)
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.3, 2.4, 2.5_

- [ ] 6. Write preservation property test for History Detail read-only sections (BEFORE implementing fix)
  - **Property 2: Preservation** - Decision Date / Score / Priorities / Status Sections Remain Read-Only
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, the Decision Date, Final Score, Your Priorities, and Decision Status sections render as read-only `Text` widgets
  - Write property-based test: for any `HistoryDecision`, those four sections contain no editable input widgets and their text values match the decision data fields
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.3_

- [ ] 7. Fix History Detail review section in `history_detail_screen.dart`

  - [ ] 7.1 Convert `HistoryDetailScreen` from `StatelessWidget` to `StatefulWidget`
    - File: `mychoice_app/lib/screens/user/history/history_detail_screen.dart`
    - Create `_HistoryDetailScreenState` with state fields: `bool _isEditingReview`, `TextEditingController _reviewController`, `int _currentRating`
    - In `initState`, seed `_reviewController.text = widget.decision.review` and `_currentRating = widget.decision.rating`
    - Dispose `_reviewController` in `dispose()`
    - _Bug_Condition: every call to `HistoryDetailScreen` — review section is always read-only_
    - _Expected_Behavior: screen has editable state for review text and star rating_
    - _Preservation: all non-review sections (date, score, priorities, status) remain read-only_
    - _Requirements: 2.3, 2.4, 2.5, 3.3_

  - [ ] 7.2 Replace static review section with conditional editable/read-only widget
    - Replace the static "Your Review" `Text` and `Icon` widgets with a conditional widget tree:
    - IF `decision.review.isEmpty` OR `_isEditingReview == true`: render editable star-rating row (5 `IconButton` stars toggling `_currentRating`), a `TextFormField` bound to `_reviewController`, and a "Submit Review" `ElevatedButton`
    - ELSE: render existing read-only star row and `Text(decision.review)`, plus a "Edit" `TextButton` that sets `_isEditingReview = true`
    - _Requirements: 2.3, 2.4, 2.5_

  - [ ] 7.3 Implement `_submitReview()` method
    - Updates the matching entry in `historySampleDecisions` with new `review` text and `rating`
    - Resets `_isEditingReview = false` and calls `setState`
    - Shows a success `SnackBar` ("Review submitted successfully")
    - _Requirements: 2.4_

  - [ ] 7.4 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - History Detail Review Section Is Editable
    - **IMPORTANT**: Re-run the SAME tests from task 5 — do NOT write new tests
    - Run History Detail review exploration tests from step 5 on the fixed code
    - **EXPECTED OUTCOME**: Tests PASS (TextFormField present for empty review; Edit button present for existing review)
    - _Requirements: 2.3, 2.4, 2.5_

  - [ ] 7.5 Verify preservation test still passes
    - **Property 2: Preservation** - Read-Only Sections Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 6 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (date, score, priorities, status sections remain read-only)

- [ ] 8. Checkpoint — Bug 2
  - Ensure all Bug 2 tests pass, ask the user if questions arise

---

## Bug 3 — Resume Navigation

- [ ] 9. Write bug condition exploration test for `_resumeDecision` passing no arguments
  - **Property 1: Bug Condition** - `_resumeDecision` Navigates Without Route Arguments
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing `Navigator.pushNamed('/create-decision')` is called with `arguments == null`
  - **Scoped PBT Approach**: `isBugCondition_issue3` is true for every `InProgressDecision` — test with a concrete Laptop draft and a Course draft
  - Case A: call `_resumeDecision(laptopDraft)` where `laptopDraft` has `category = 'Technology'`, `subcategory = 'Laptop'`, `options = ['MacBook Air M3']`, `priorities = {'Price': 40.0, 'RAM': 60.0}`; assert the last pushed route's `arguments` is non-null and contains `'category': 'Technology'`
  - Case B: call `_resumeDecision(courseDraft)` with Education/Course data; assert `arguments['subcategory'] == 'Course'`
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (arguments is null — this proves the bug exists)
  - Document counterexamples (e.g., `ModalRoute.of(context).settings.arguments` was `null`)
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.6, 2.7_

- [ ] 10. Write preservation property test for Resume empty-state behavior (BEFORE implementing fix)
  - **Property 2: Preservation** - Empty-State UI and "Create New Decision" Button Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: when `_draftDecisions` is empty on unfixed code, the empty-state widget and "Create New Decision" button are shown; tapping the button navigates to `/create-decision` with no arguments
  - Write property-based test: when `_draftDecisions` is empty, the navigation target is `/create-decision` and `arguments == null`; the empty-state widget is present in the widget tree
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.2_

- [ ] 11. Fix Resume navigation in `continue_decision_screen.dart` and `app.dart`

  - [ ] 11.1 Update `_resumeDecision` to pass route arguments
    - File: `mychoice_app/lib/screens/user/decision/continue_decision_screen.dart`
    - Change `Navigator.of(context).pushNamed('/create-decision')` to pass `arguments` map: `{'category': decision.category, 'subcategory': decision.subcategory, 'options': List<String>.from(decision.options), 'priorities': Map<String, double>.from(decision.priorities)}`
    - _Bug_Condition: every call to `_resumeDecision` — no arguments are ever passed_
    - _Expected_Behavior: `pushNamed` called with full `RouteArguments` map containing `category`, `subcategory`, `options`, `priorities`_
    - _Preservation: empty-state "Create New Decision" navigation unaffected (calls `pushNamed` with no args, separate code path)_
    - _Requirements: 2.6, 3.2_

  - [ ] 11.2 Update `/create-decision` route in `app.dart` to extract and pass arguments
    - File: `mychoice_app/lib/app.dart`
    - In the `/create-decision` route builder, extract `ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?`
    - Pass `initialCategory`, `initialSubcategory`, `initialOptions`, `initialPriorities` from the args map to `CreateDecisionScreen`; all args are nullable so a blank-form navigation still works
    - _Requirements: 2.7_

  - [ ] 11.3 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - `_resumeDecision` Passes Full Draft Data
    - **IMPORTANT**: Re-run the SAME tests from task 9 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (arguments map contains correct `category`, `subcategory`, `options`, `priorities`)
    - _Requirements: 2.6, 2.7_

  - [ ] 11.4 Verify preservation test still passes
    - **Property 2: Preservation** - Empty-State Navigation Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 10 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (empty-state "Create New Decision" still navigates with no args)

- [ ] 12. Checkpoint — Bug 3
  - Ensure all Bug 3 tests pass, ask the user if questions arise

---

## Bug 4 — Criteria–Subcategory Sync

- [ ] 13. Write bug condition exploration test for criteria not resetting on subcategory change
  - **Property 1: Bug Condition** - Criteria Not Updated When Subcategory Changes
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing `_selectedCriteria` still contains hardcoded Technology/Laptop keys after selecting a non-Tech subcategory
  - **Scoped PBT Approach**: `isBugCondition_issue4` is true for any non-null subcategory — test three concrete cases
  - Case A: call `_selectSubcategory('Fashion')`; assert `_selectedCriteria` does NOT contain `'Battery'` and DOES contain `'Style'`
  - Case B: call `_selectSubcategory('Course')`; assert `_selectedCriteria` does NOT contain `'Performance'` and DOES contain `'Duration'`
  - Case C: call `_selectSubcategory('Laptop')` then `_selectSubcategory('Shoes')`; assert `_selectedCriteria.keys` equals `_criteriaBySubcategory['Shoes'].keys`
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (`_selectedCriteria` still has `Battery`/`Performance` after Fashion/Course selection)
  - Document counterexamples found
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.8, 2.9_

- [ ] 14. Write preservation property test for subcategory chip and category selection (BEFORE implementing fix)
  - **Property 2: Preservation** - Category Selection and Subcategory Chip Display Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, selecting a category renders the subcategory chip selector; selecting the same subcategory again or selecting a category without a subcategory does not crash and shows the correct chip UI
  - Write property-based test: for any category selection without a subsequent subcategory selection, subcategory chips are displayed and `_selectedCriteria` is unchanged; selecting the same subcategory twice produces the same `_selectedCriteria` as selecting it once
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.4_

- [ ] 15. Fix criteria–subcategory sync in `create_decision_screen.dart`

  - [ ] 15.1 Add `_criteriaBySubcategory` constant map to `_CreateDecisionScreenState`
    - File: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`
    - Add a `Map<String, Map<String, bool>> _criteriaBySubcategory` covering all 18 subcategories: Laptop, Smartphone, Tablet, Monitor, Gaming PC, Processor, Graphics Card, Course, Certification, Bootcamp, University, Training Program, Dress, Shoes, Accessories, Bags, Jewelry, Outerwear
    - Use the exact entries specified in the design (e.g., `'Laptop': {'Price': true, 'RAM': true, 'Storage': true, 'Processor Speed': true, 'Battery Life': true, 'Weight': false}`)
    - _Requirements: 2.8_

  - [ ] 15.2 Add `_resetCriteriaForSubcategory` helper method
    - Implement `_resetCriteriaForSubcategory(String subcategory)`: fetch defaults from `_criteriaBySubcategory[subcategory] ?? {}`; call `_selectedCriteria..clear()..addAll(defaults)`; call `_priorities.clear()`; seed `_priorities` with `0.0` for every key whose initial value is `true` in defaults
    - _Bug_Condition: `isBugCondition_issue4` — subcategory != null and criteria still contain hardcoded Tech set_
    - _Expected_Behavior: after calling `_selectSubcategory(sub)`, `_selectedCriteria.keys == _criteriaBySubcategory[sub].keys`_
    - _Preservation: category card selection and subcategory chip display behavior unchanged_
    - _Requirements: 2.8, 2.9, 3.4_

  - [ ] 15.3 Update `_selectSubcategory` to call `_resetCriteriaForSubcategory`
    - Modify `_selectSubcategory` to call `_resetCriteriaForSubcategory(subcategory)` inside `setState` after updating `_selectedSubcategory`
    - _Requirements: 2.8, 2.9_

  - [ ] 15.4 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Criteria Reset Correctly on Subcategory Change
    - **IMPORTANT**: Re-run the SAME tests from task 13 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (Fashion → Style present, Battery absent; Course → Duration present, Performance absent)
    - _Requirements: 2.8, 2.9_

  - [ ] 15.5 Verify preservation test still passes
    - **Property 2: Preservation** - Category/Subcategory Chip Behavior Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 14 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (chip display and category-only selection behavior intact)

- [ ] 16. Checkpoint — Bug 4
  - Ensure all Bug 4 tests pass, ask the user if questions arise

---

## Bug 5 — Priority–Criteria Sync

- [ ] 17. Write bug condition exploration test for priority sliders not syncing with checkbox toggles
  - **Property 1: Bug Condition** - `_toggleCriteria` Does Not Update `_priorities`
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing stale/missing entries in `_priorities` after checkbox operations
  - **Scoped PBT Approach**: `isBugCondition_issue5` covers UNCHECK and ADD_AND_SELECT cases — test all three sub-cases
  - Case A (UNCHECK): set `_selectedCriteria['Battery'] = true` and `_priorities['Battery'] = 30.0`; call `_toggleCriteria('Battery')`; assert `_priorities` does NOT contain key `'Battery'`
  - Case B (ADD_AND_SELECT): call `_saveNewCriteria(ctx)` with name `'Durability'`; then call `_toggleCriteria('Durability')`; assert `_priorities.containsKey('Durability')` and `_priorities['Durability'] == 0.0`
  - Case C (ADD only): call `_saveNewCriteria(ctx)` with name `'Comfort'`; assert `_priorities` does NOT contain `'Comfort'` (it should only be in `_selectedCriteria` as `false`)
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (Battery key remains after uncheck; Durability missing after add+check; or Comfort incorrectly present after add-only)
  - Document counterexamples found
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.10, 2.11, 2.12_

- [ ] 18. Write preservation property test for criteria checkbox visual state (BEFORE implementing fix)
  - **Property 2: Preservation** - Checkbox Visual State Updates Immediately
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, toggling any criterion checkbox immediately updates the checkbox visual state (`_selectedCriteria[key]` flips correctly)
  - Write property-based test: generate random sequences of check/uncheck operations on a set of criteria; after each toggle, assert `_selectedCriteria[key]` reflects the new boolean state (visual update is correct)
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.5_

- [ ] 19. Fix priority–criteria sync in `create_decision_screen.dart`

  - [ ] 19.1 Rewrite `_toggleCriteria` to keep `_priorities` in sync
    - File: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`
    - New logic: compute `nowSelected = !(_selectedCriteria[criteria] ?? false)`; set `_selectedCriteria[criteria] = nowSelected`; if `nowSelected` call `_priorities.putIfAbsent(criteria, () => 0.0)` else call `_priorities.remove(criteria)`
    - All changes wrapped in `setState`
    - _Bug_Condition: UNCHECK — `_priorities` still contains the key after unchecking; ADD_AND_SELECT — `_priorities` missing after add+check_
    - _Expected_Behavior: `_priorities.keys` always equals the set of keys in `_selectedCriteria` where `value == true`_
    - _Preservation: checkbox visual state continues to update immediately_
    - _Requirements: 2.10, 2.11, 3.5_

  - [ ] 19.2 Rewrite `_saveNewCriteria` to NOT pre-add to `_priorities`
    - New logic: validate name is non-empty and not duplicate; call `setState(() { _selectedCriteria[name] = false; })`; do NOT add to `_priorities` (only `_toggleCriteria` does that)
    - _Bug_Condition: ADD_AND_SELECT — `_saveNewCriteria` added key to `_priorities` with weight 0 regardless of checkbox state_
    - _Expected_Behavior: after `_saveNewCriteria`, key is in `_selectedCriteria` as `false` and NOT in `_priorities`_
    - _Requirements: 2.12_

  - [ ] 19.3 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - `_toggleCriteria` Keeps `_priorities` in Sync
    - **IMPORTANT**: Re-run the SAME tests from task 17 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (Battery removed from `_priorities` after uncheck; Durability added after add+check; Comfort absent until checked)
    - _Requirements: 2.10, 2.11, 2.12_

  - [ ] 19.4 Verify preservation test still passes
    - **Property 2: Preservation** - Checkbox Visual State Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 18 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (`_selectedCriteria` boolean flips correctly for all toggle operations)

- [ ] 20. Checkpoint — Bug 5
  - Ensure all Bug 5 tests pass, ask the user if questions arise

---

## Bug 6 — Manual Option + Admin Request

- [ ] 21. Write bug condition exploration test for missing "Request to catalog" affordance
  - **Property 1: Bug Condition** - No "Request to catalog" UI After Custom Option Add
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing no catalog-request widget appears after a custom option is submitted
  - **Scoped PBT Approach**: `isBugCondition_issue6` is true whenever a custom option is added — test with two different custom option names
  - Case A: trigger the custom option add flow with name `'Samsung Galaxy Tab S9 FE'`; assert `find.text('Request to catalog')` finds a widget (SnackBar action)
  - Case B: trigger with a completely new product name `'BrandX UltraBook'`; assert the same SnackBar action appears
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (no "Request to catalog" text found — this proves the bug exists)
  - Document counterexamples found
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.13, 2.14_

- [ ] 22. Write preservation property test for existing custom option add behavior (BEFORE implementing fix)
  - **Property 2: Preservation** - Custom Option Continues to Be Added to `_selectedOptions`
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, typing a custom option name and tapping "+" adds it to `_selectedOptions` and it appears in the selected list
  - Write property-based test: for any non-empty custom option string, after the add action `_selectedOptions` contains that string and the option row appears in the widget tree; the existing add flow is not blocked
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.6_

- [ ] 23. Fix manual option add + admin request in `create_decision_screen.dart`

  - [ ] 23.1 Show "Request to catalog" SnackBar action after custom option is added
    - File: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`
    - After the custom option is added to `_selectedOptions` (inside the inline custom-entry flow), call `ScaffoldMessenger.of(context).showSnackBar` with `content: Text('"$customName" added.')` and a `SnackBarAction(label: 'Request to catalog', onPressed: () => _requestCatalogEntry(customName))`
    - This is ADDITIVE — do NOT change the existing add-to-`_selectedOptions` logic
    - _Bug_Condition: custom option just added to `_selectedOptions` AND no catalog-request UI was presented_
    - _Expected_Behavior: SnackBar with "Request to catalog" action appears immediately after custom option add_
    - _Preservation: existing add-to-`_selectedOptions` logic unchanged_
    - _Requirements: 2.13, 3.6_

  - [ ] 23.2 Add `_requestCatalogEntry(String optionName)` method
    - Build payload map: `{'optionName': optionName, 'category': _selectedCategory ?? '', 'subcategory': _selectedSubcategory ?? '', 'requestedAt': DateTime.now().toIso8601String()}`
    - Log payload with `debugPrint` (TODO: wire to admin notification service via API)
    - Show confirmation SnackBar: `'Your suggestion has been sent to our team for review.'`
    - _Requirements: 2.13, 2.14_

  - [ ] 23.3 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - "Request to catalog" Action Appears After Custom Option Add
    - **IMPORTANT**: Re-run the SAME tests from task 21 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (`find.text('Request to catalog')` finds the SnackBar action widget)
    - _Requirements: 2.13, 2.14_

  - [ ] 23.4 Verify preservation test still passes
    - **Property 2: Preservation** - Custom Option Add Behavior Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 22 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (custom option still added to `_selectedOptions`; existing flow unblocked)

- [ ] 24. Checkpoint — Bug 6
  - Ensure all Bug 6 tests pass, ask the user if questions arise

---

## Bug 7 — Option Specifications

- [ ] 25. Write bug condition exploration test for specs not rendered in `create_decision_screen`
  - **Property 1: Bug Condition** - `Alternative.specs` Not Rendered in Create Decision Screen
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing spec data is silently dropped in the options list
  - **Scoped PBT Approach**: `isBugCondition_issue7` applies when `alternative.specs != null && alternative.specs.isNotEmpty` on `create_decision_screen` — test with Laptop and Course alternatives
  - Case A: load `_buildOptionsSection` for subcategory `'Laptop'` with a mock `Alternative(name: 'MacBook Air M3', specs: {'processor': 'M3', 'ram': '8GB', 'price': '\$1099'})`; assert the option row contains secondary text with `'ram: 8GB'` or `'processor: M3'`
  - Case B: assert `MockAlternativeDataSource.getCatalogAlternatives('bags')` returns at least 2 alternatives with non-empty `specs` maps
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (specs text absent in Laptop option row; bags returns empty list or alternatives without specs)
  - Document counterexamples found
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.15, 2.16, 2.17_

- [ ] 26. Write preservation property test for existing specs rendering in `AlternativeManagementScreen` (BEFORE implementing fix)
  - **Property 2: Preservation** - `_AlternativeListItem` Continues to Show First Two Spec Entries
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, `_AlternativeListItem` in `alternative_management_screen.dart` already renders the first two spec entries as secondary text for alternatives that have a non-null, non-empty `specs` map
  - Write property-based test: for any `Alternative` with a non-empty `specs` map displayed in `AlternativeManagementScreen`, the first two spec entries appear as secondary text in the list item
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.7_

- [ ] 27. Fix option specifications rendering and mock data

  - [ ] 27.1 Replace `_optionsBySubcategory` string list with `Alternative` entity lookups in `create_decision_screen.dart`
    - File: `mychoice_app/lib/screens/user/decision/create_decision_screen.dart`
    - Add or wire a `Map<String, List<Alternative>> _alternativesBySubcategory` (load from `MockAlternativeDataSource` or mirror its data)
    - Update `_availableOptions` getter to return `List<Alternative>` instead of `List<String>`
    - _Bug_Condition: `create_decision_screen` renders options as plain `Text` — `Alternative.specs` is never read_
    - _Expected_Behavior: option list items show primary text (`alternative.name`) and secondary text (top 2–3 spec entries formatted as `key: value` joined by ` • `)_
    - _Preservation: specs rendering in `AlternativeManagementScreen` unchanged_
    - _Requirements: 2.15, 2.16, 3.7_

  - [ ] 27.2 Add `_CreateDecisionAlternativeItem` widget mirroring `_AlternativeListItem`
    - Create a private widget (or inline builder) in `create_decision_screen.dart` that renders:
      - Primary text: `alternative.name`
      - Secondary text (when `alternative.specs` is non-null and non-empty): top 2–3 entries as `'key: value'` joined by ` • `
      - Checked/tap state and add-to-list logic unchanged from current string-based implementation
    - _Requirements: 2.15, 2.16_

  - [ ] 27.3 Extend `MockAlternativeDataSource._getMockAlternatives` with missing subcategory data
    - File: `mychoice_app/lib/features/alternative_management/data/datasources/alternative_datasource.dart`
    - Add minimum 2 `Alternative` entries with non-empty `specs` maps for each missing subcategory:
      - Technology: `'tablet'`, `'monitor'`, `'gaming_pc'`, `'processor'`, `'graphics_card'`
      - Education: `'certification'`, `'bootcamp'`, `'university'`, `'training_program'`
      - Fashion: `'dress'`, `'shoes'`, `'accessories'`, `'bags'`, `'jewelry'`, `'outerwear'`
    - Use subcategory-appropriate spec keys (e.g., `bags` → `capacity`, `material`, `brand`, `price`; `shoes` → `size_range`, `material`, `comfort_rating`, `price`)
    - _Requirements: 2.17_

  - [ ] 27.4 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Specs Rendered in Create Decision Screen
    - **IMPORTANT**: Re-run the SAME tests from task 25 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (Laptop option row shows spec secondary text; bags returns ≥2 alternatives with non-empty specs)
    - _Requirements: 2.15, 2.16, 2.17_

  - [ ] 27.5 Verify preservation test still passes
    - **Property 2: Preservation** - `_AlternativeListItem` Rendering Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 26 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (first two spec entries still shown as secondary text in `AlternativeManagementScreen`)

- [ ] 28. Checkpoint — Bug 7
  - Ensure all Bug 7 tests pass, ask the user if questions arise

---

## Bug 8 — Admin Naming Consistency

- [ ] 29. Write bug condition exploration test for `AdminUser.plan` free-form string
  - **Property 1: Bug Condition** - `AdminUser.plan` Is Unvalidated Free-Form String
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples showing that invalid plan strings compile and that `recentDecisionSubcategory` is absent
  - **Scoped PBT Approach**: `isBugCondition_issue8` is true when `plan` is not a valid tier value OR `recentDecisionSubcategory == null`
  - Case A: attempt `AdminUser(plan: 'freeform_plan', ...)` — on unfixed code this compiles and runs; assert that after the fix this is a **compile-time type error** (document that this case passes compilation on unfixed code)
  - Case B: render `_UserCard` for a `demoAdminUsers` entry; assert the card subtitle contains a subcategory string (assert fails since `recentDecisionSubcategory` field doesn't exist yet)
  - Case C: render `_UserDetailsDialog`; assert `user.plan.displayName` returns a non-empty, title-cased string (fails since `displayName` getter doesn't exist on `String`)
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (free-form string compiles without error; subcategory absent from card; `displayName` getter missing)
  - Document counterexamples found
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 2.18, 2.19, 2.20_

- [ ] 30. Write preservation property test for admin deactivation and filter flows (BEFORE implementing fix)
  - **Property 2: Preservation** - Deactivation Dialog and Status Filter Behavior Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe: on unfixed code, admin deactivation via the confirmation dialog updates `status` to `inactive` and shows confirmation SnackBar; Active/Inactive status filters filter the user list without resetting other state
  - Write property-based test: simulate deactivation action → assert `user.status == inactive` and SnackBar visible; apply each filter → assert list contains only users matching that status and other state is preserved
  - Verify test PASSES on UNFIXED code
  - _Requirements: 3.8, 3.9_

- [ ] 31. Fix admin naming consistency

  - [ ] 31.1 Change `AdminUser.plan` from `String` to `UserPlanTier` enum
    - File: `mychoice_app/lib/core/models/admin_user.dart`
    - Import `user_plan.dart`; change field type from `String` to `UserPlanTier`
    - Add nullable `String? recentDecisionSubcategory` field
    - Update constructor, `copyWith`, and any `fromJson`/`toJson` accordingly
    - _Bug_Condition: `AdminUser.plan` is `String` — free-form values like `'freeform_plan'` accepted without error; `recentDecisionSubcategory` field absent_
    - _Expected_Behavior: `plan` field is `UserPlanTier` enum — invalid strings cause compile-time type errors; `recentDecisionSubcategory` is stored and displayable_
    - _Preservation: deactivation dialog and status filter behavior unchanged_
    - _Requirements: 2.20, 3.8, 3.9_

  - [ ] 31.2 Update `demoAdminUsers` to use `UserPlanTier` enum values and populate `recentDecisionSubcategory`
    - Replace string literals `'Basic'` and `'Premium'` with `UserPlanTier.basic` and `UserPlanTier.premium`
    - Add realistic demo values for `recentDecisionSubcategory` (e.g., `'Laptop'`, `'Course'`, `'Bags'`)
    - _Requirements: 2.18, 2.19_

  - [ ] 31.3 Add `UserPlanTierLabel` extension with `displayName` getter
    - File: `mychoice_app/lib/screens/admin/users/user_management_screen.dart` (or `user_plan.dart`)
    - Add extension: `guest` → `'Guest'`, `basic` → `'Basic'`, `premium` → `'Premium'`, `admin` → `'Admin'`
    - _Requirements: 2.18_

  - [ ] 31.4 Update `_UserCard` and `_UserDetailsDialog` to use enum display name and show subcategory
    - File: `mychoice_app/lib/screens/admin/users/user_management_screen.dart`
    - In `_UserCard`: replace `Text(user.plan)` with `Text(user.plan.displayName)`; add a third subtitle line showing `user.recentDecisionSubcategory` when non-null
    - In `_UserDetailsDialog`: replace `Text(user.plan)` with `Text(user.plan.displayName)`
    - _Requirements: 2.18, 2.19_

  - [ ] 31.5 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - `AdminUser.plan` Is `UserPlanTier` Enum
    - **IMPORTANT**: Re-run the SAME tests from task 29 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (`AdminUser(plan: 'freeform')` is now a compile-time error; `_UserCard` shows subcategory; `user.plan.displayName` returns `'Basic'`/`'Premium'`)
    - _Requirements: 2.18, 2.19, 2.20_

  - [ ] 31.6 Verify preservation test still passes
    - **Property 2: Preservation** - Deactivation and Filter Flows Unchanged
    - **IMPORTANT**: Re-run the SAME test from task 30 — do NOT write new tests
    - **EXPECTED OUTCOME**: Tests PASS (deactivation updates status correctly; filters behave as before)

- [ ] 32. Checkpoint — Bug 8
  - Ensure all Bug 8 tests pass, ask the user if questions arise

---

## Final Integration Checkpoint

- [ ] 33. Run full regression suite across all 8 fixes
  - Run all bug condition exploration tests (Property 1 for each bug) — all must PASS
  - Run all preservation property tests (Property 2 for each bug) — all must PASS
  - Run integration test: full Create Decision flow (Technology → Laptop → criteria auto-populate → toggle criteria → priority sliders sync → 100% total → navigate to Result screen)
  - Run integration test: full Resume flow (tap "Resume Decision" on a draft → Create Decision opens pre-filled → user completes decision)
  - Run integration test: History Detail review flow (no review → write → submit → read-only → Edit → re-submit)
  - Run integration test: Admin User Management (create `AdminUser` with `UserPlanTier.basic` → card shows `'Basic'` → subcategory displayed)
  - Run integration test: What-If Simulation (open for completed Laptop decision → all labels in English → adjust sliders → run simulation → modal shows correct comparison)
  - Run `flutter analyze` — zero issues
  - Ensure all tests pass; ask the user if any questions arise
