# Bugfix Requirements Document

## Introduction

This document covers 8 bugs and improvements for the MyChoice Flutter frontend application. The issues span multiple screens and features: language localization in the What-If Simulation page, missing review input in the History Detail screen, broken Resume navigation, stale criteria when subcategory changes, priority section not syncing with criteria changes, missing manual option addition with admin request flow, missing option specifications per subcategory, and inconsistent naming in the Admin User Management page.

Each issue is captured using the bug condition methodology, identifying the defective behavior, the expected correct behavior, and the behaviors that must be preserved.

---

## Bug Analysis

### Current Behavior (Defect)

**Issue 1 – What-If Simulation: Language**

1.1 WHEN the What-If Simulation screen displays criterion labels, THEN the system shows Indonesian-language strings (e.g., "Harga", "Performa", "Baterai", "Penyimpanan", "Berat") instead of English

1.2 WHEN the `_getDisplayName` method in `WhatIfScreen` receives a criterion ID such as `price`, `performance`, `battery`, `storage`, or `weight`, THEN the system returns the Indonesian translation rather than the English name

**Issue 2 – History Detail: Review Section**

2.1 WHEN a user views the Decision Detail screen in the History page, THEN the system displays the existing review text and star rating as read-only data (hardcoded as "Performance sesuai dengan kebutuhan." and 5 stars) without providing any input area for the user to write or submit a review

2.2 WHEN a decision has no review yet, THEN the system still shows a default hardcoded review string instead of prompting the user to add one

**Issue 3 – Continue Decision / Resume Navigation**

3.1 WHEN a user taps "Resume Decision" on the Continue Decision screen, THEN the system navigates to `/create-decision` with no pre-filled data, presenting a blank form regardless of which draft was selected

3.2 WHEN the `_resumeDecision` method is called with a specific `InProgressDecision` object, THEN the system calls `Navigator.of(context).pushNamed('/create-decision')` without passing any route arguments containing the decision's category, subcategory, options, or priorities

**Issue 4 – Create Decision: Criteria Not Updating on Subcategory Change**

4.1 WHEN a user selects a category and then selects a subcategory (e.g., "Fashion"), THEN the system continues to display the same hardcoded criteria set (`Price`, `Performance`, `Battery`, `Weight`, `Storage`) regardless of which subcategory was chosen

4.2 WHEN a user changes the subcategory selection from one subcategory to another (e.g., from "Laptop" to "Fashion"), THEN the system does not update the `_selectedCriteria` map to reflect criteria appropriate for the new subcategory (e.g., Fashion should show Style/Design, Comfort, Durability, not Battery)

**Issue 5 – Set/Add Criteria: Priority Section Not Syncing**

5.1 WHEN a user adds a new custom criterion via the "Add Criteria" dialog in the Create Decision screen, THEN the system adds the criterion to `_selectedCriteria` with `false` (unselected) and adds it to `_priorities` with weight 0, but the Priority sliders section continues to show the original criteria only until the user toggles the new criterion's checkbox

5.2 WHEN a user deselects an existing criterion (unchecks its checkbox), THEN the system does not remove that criterion's slider from the Priority section, leaving a stale slider for a criterion that is no longer active in the decision

5.3 WHEN a user adds a new criterion and then selects it, THEN the system adds the criterion's slider to the Priority section but the total weight validation may break because the new slider starts at 0% with no guidance that the total must still equal 100%

**Issue 6 – Missing Option: Manual Add + Admin Recommendation**

6.1 WHEN a user cannot find the option they want to compare in the catalog or custom entry flow, THEN the system provides no mechanism to flag that option as a candidate for the system catalog or to notify an admin that a new default option should be added

6.2 WHEN a user submits a custom option name in the alternative management screen, THEN the system adds it locally to the decision but does not offer any way for the user to request that this option become a permanent catalog entry

**Issue 7 – Option Details/Specifications**

7.1 WHEN catalog alternatives are displayed in the Create Decision screen's options list, THEN the system shows only the option name without any specifications (e.g., a laptop entry does not show storage capacity, RAM, processor, or price)

7.2 WHEN the alternative management screen renders a catalog item that has a `specs` field, THEN the spec data is available on the `Alternative` entity but the Create Decision screen does not render it — the `_AlternativeListItem` code exists only in `alternative_management_screen.dart`, not in `create_decision_screen.dart`

7.3 WHEN a user selects a subcategory such as "Fashion" or "Education", THEN the specifications shown for catalog items in those subcategories do not reflect relevant attributes (e.g., a shoe should show Size Range, Material, and Brand; a course should show Duration, Price, and Platform)

**Issue 8 – Admin Page: User Management Inconsistency**

8.1 WHEN an admin views the User Management screen and sees a user's plan label, THEN the system displays plan values sourced from `demoAdminUsers` (e.g., "Basic", "Premium") which may not match the plan tier labels shown to users on the user-facing Premium Plan screen or Profile screen

8.2 WHEN an admin views a user's category/subcategory activity or interests in the admin panel, THEN the system does not display subcategory information at all, making it impossible to verify that the categories shown in the user's decision history align with the canonical subcategory names used in the app (e.g., the admin sees no link between a user's activity and subcategories like "Laptop", "Course", or "Bags")

8.3 WHEN the admin User Management screen labels an account status as "Active" or "Inactive", THEN the terminology is consistent with the user-facing app, but the plan tier labels ("Basic", "Premium") are stored as raw strings in `AdminUser.plan` with no validation ensuring they match the `UserPlan` enum used in the user domain model

---

### Expected Behavior (Correct)

**Issue 1 – What-If Simulation: Language**

2.1 WHEN the What-If Simulation screen displays criterion labels, THEN the system SHALL display them in English (e.g., "Price", "Performance", "Battery Life", "Storage", "Weight")

2.2 WHEN `_getDisplayName` receives a known criterion ID, THEN the system SHALL return the English display name that matches the name stored on the `Criterion` entity or the key used in the decision

**Issue 2 – History Detail: Review Section**

2.3 WHEN a user views a Decision Detail screen for a completed decision that has no review, THEN the system SHALL display an input area (text field and star rating selector) allowing the user to write and submit a review

2.4 WHEN a user submits a review via the input area, THEN the system SHALL save the review text and rating and display them as the decision's review going forward

2.5 WHEN a decision already has a saved review, THEN the system SHALL display the saved review text and rating and provide an option to edit it

**Issue 3 – Continue Decision / Resume Navigation**

2.6 WHEN a user taps "Resume Decision" on a draft decision card, THEN the system SHALL navigate to the Create Decision screen pre-filled with that decision's `category`, `subcategory`, selected `options`, and configured `priorities`

2.7 WHEN the Create Decision screen receives route arguments containing pre-filled decision data, THEN the system SHALL initialize its state from those arguments so the user continues from the exact step and data they had previously configured

**Issue 4 – Create Decision: Criteria Not Updating on Subcategory Change**

2.8 WHEN a user selects a subcategory, THEN the system SHALL update the criteria list to show criteria relevant to that subcategory (e.g., Laptop → Price, RAM, Storage, Processor Speed, Battery Life, Weight; Fashion → Price, Style/Design, Comfort, Durability, Material Quality)

2.9 WHEN a user changes the subcategory selection, THEN the system SHALL reset the `_selectedCriteria` map and the `_priorities` map to reflect the new subcategory's default criteria, clearing any criteria from the previously selected subcategory

**Issue 5 – Set/Add Criteria: Priority Section Syncing**

2.10 WHEN a user checks a criterion checkbox, THEN the system SHALL immediately add that criterion's weight slider to the Priority section

2.11 WHEN a user unchecks a criterion checkbox, THEN the system SHALL immediately remove that criterion's weight slider from the Priority section and remove its entry from `_priorities`

2.12 WHEN a user adds a new custom criterion and it is selected, THEN the system SHALL add a slider for it in the Priority section with an initial weight of 0 and show that the total weight must be re-balanced to 100%

**Issue 6 – Missing Option: Manual Add + Admin Recommendation**

2.13 WHEN a user adds a custom option that is not in the catalog, THEN the system SHALL present an option to "Request this to be added to the catalog", which sends a request payload to the admin notification system

2.14 WHEN a user submits a catalog addition request for a custom option, THEN the system SHALL confirm submission with a message (e.g., "Your suggestion has been sent to our team for review") and the admin SHALL receive a pending request in the admin panel

**Issue 7 – Option Details/Specifications**

2.15 WHEN catalog alternatives are listed in the Create Decision screen, THEN the system SHALL display a brief specifications summary beneath each option name, showing the top 2–3 key specs relevant to the subcategory (e.g., for Laptop: RAM, Storage, Processor; for Course: Platform, Duration, Price)

2.16 WHEN an alternative has a populated `specs` map, THEN the system SHALL render the spec entries as secondary text in the option list item across all screens that display catalog alternatives

2.17 WHEN a subcategory is selected and its catalog alternatives are loaded, THEN the system SHALL ensure all catalog options for that subcategory have a non-empty `specs` map containing attributes appropriate to the subcategory

**Issue 8 – Admin Page: User Management Inconsistency**

2.18 WHEN the admin User Management screen displays a user's plan tier, THEN the system SHALL use the same plan tier labels that appear on the user-facing Profile and Premium Plan screens (i.e., consistent casing and naming: "Basic", "Premium")

2.19 WHEN the admin User Management screen displays a user record, THEN the system SHALL show the subcategory or decision category associated with the user's most recent decision activity so that admin can verify naming consistency

2.20 WHEN the `AdminUser.plan` field is set, THEN the system SHALL validate that its value matches one of the known plan tier names used in the `UserPlan` domain entity, preventing free-form strings that diverge from the user-facing nomenclature

---

### Unchanged Behavior (Regression Prevention)

3.1 WHEN a user views the What-If Simulation screen and adjusts sliders, THEN the system SHALL CONTINUE TO recalculate the ranking in real-time and show the original vs. simulated ranking comparison correctly

3.2 WHEN a user taps "Resume Decision" and no draft exists, THEN the system SHALL CONTINUE TO show the empty state UI with the option to create a new decision

3.3 WHEN a user views a completed decision's detail in History, THEN the system SHALL CONTINUE TO display Decision Date, Final Score, Your Priorities, and Decision Status sections as read-only

3.4 WHEN a user selects a category but has not yet selected a subcategory, THEN the system SHALL CONTINUE TO show the subcategory chip selector without loading criteria or options

3.5 WHEN a user toggles criteria checkboxes with the current fixed criteria list, THEN the system SHALL CONTINUE TO allow selecting and deselecting criteria and reflecting selected state visually

3.6 WHEN a user adds a custom alternative name in catalog mode via the inline "Not in the list? Add a custom option" section, THEN the system SHALL CONTINUE TO add it to the selected options list just as it does today

3.7 WHEN a user on the alternative management screen selects catalog alternatives that already have specs, THEN the system SHALL CONTINUE TO show the first 2 spec entries as secondary text in the list item

3.8 WHEN an admin deactivates a user account through the confirmation dialog flow, THEN the system SHALL CONTINUE TO update the user's status to `inactive` and show the confirmation snackbar

3.9 WHEN the admin applies status filters (Active/Inactive) in the User Management screen, THEN the system SHALL CONTINUE TO filter the user list accordingly without resetting other state

3.10 WHEN the Create Decision flow is completed with valid criteria and priorities summing to 100%, THEN the system SHALL CONTINUE TO navigate to the Result screen with the correct ranked choices
