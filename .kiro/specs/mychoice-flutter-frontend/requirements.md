# MyChoice Flutter Frontend - Requirements Document

## Introduction

MyChoice is an AI-assisted personal decision-support system that helps students and young adults make structured decisions based on their needs, conditions, and personal priorities. The application implements the Simple Additive Weighting (SAW) decision engine to provide transparent, explainable recommendations.

The Flutter frontend is a mobile application (Android/iOS) that serves as the primary interface for end-users to:
1. Create structured decision problems across predefined categories
2. Define alternatives and evaluation criteria
3. Set priorities and weights
4. Execute decision calculations
5. Receive AI-powered explanations
6. Simulate scenario changes
7. Track decision history

This requirements document formalizes the 17 functional requirement groups that guide design and implementation, ensuring the system delivers clarity before decision-making.

---

## Glossary

- **Alternative**: A specific option being compared (e.g., "Lenovo ThinkPad", "HP Pavilion")
- **Benefit Criteria**: Evaluation criteria where higher values are better (e.g., RAM, battery life)
- **Cost Criteria**: Evaluation criteria where lower values are better (e.g., price, weight)
- **Criteria**: An evaluation dimension used to compare alternatives (e.g., price, performance, battery)
- **Decision**: A structured problem-solving session with alternatives, criteria, and weights
- **Decision Engine**: The SAW calculator that normalizes values, applies weights, and ranks alternatives
- **Decision Matrix**: A table of alternatives vs. criteria with raw values
- **Guest User**: Unauthenticated user with limited access (view-only features)
- **Plan/Tier**: User subscription level (Guest, Basic, Premium, Admin) that determines feature access
- **Priority/Weight**: A percentage value (0-100) indicating how important a criterion is
- **Rank/Ranking**: The final sorted order of alternatives by composite score
- **SAW (Simple Additive Weighting)**: Multi-criteria decision-making algorithm using normalization, weighting, and summation
- **Subcategory**: A sub-classification within a main category (e.g., "Laptop" within "Technology")
- **System**: The MyChoice Flutter mobile application
- **User**: An authenticated end-user (Basic or Premium tier) or Admin
- **What-If Simulation**: Interactive scenario testing where users adjust priorities and observe ranking changes

---

## Requirements

### Requirement Group 1: User Authentication & Account Management

**User Story**: As a user, I want to authenticate securely and manage my account, so that my personal decisions and preferences are protected and accessible only to me.

#### Acceptance Criteria

1. WHEN a user opens the application for the first time, THE System SHALL display the Splash Screen with animated logo, then transition to Onboarding or Login after 3 seconds
2. WHEN an unauthenticated user navigates to a protected route, THE System SHALL redirect to Login Screen
3. WHEN a new user taps "Sign Up", THE System SHALL display Registration Form requiring email, password, name, and date of birth
4. WHEN a user submits valid registration data, THE System SHALL:
   - Validate email format (RFC 5322 compliant)
   - Validate password complexity (minimum 8 characters, at least 1 uppercase, 1 number)
   - Create user account in backend
   - Return success message and navigate to Login
5. IF registration fails (email already exists, network error, backend error), THEN THE System SHALL display descriptive error message and allow retry
6. WHEN a user enters valid credentials on Login Screen, THE System SHALL authenticate via backend API and store authentication token securely
7. WHEN login fails due to invalid credentials, THEN THE System SHALL display "Invalid email or password" error without revealing whether email exists
8. WHERE multi-factor authentication is required, THE System SHALL prompt for verification code sent to registered email
9. WHEN user taps "Forgot Password", THE System SHALL direct to password reset flow (email verification + new password entry)
10. WHEN user is logged in, THE System SHALL display user profile (name, email, tier/plan) accessible from Dashboard or Profile screen
11. WHILE user is authenticated, THE System SHALL maintain session validity and refresh tokens before expiration
12. IF user explicitly taps "Logout", THEN THE System SHALL clear session tokens and redirect to Login Screen
13. WHEN user closes app and returns while session is valid, THE System SHALL restore authenticated state without re-login

#### Related Definitions
- **System** = MyChoice Flutter mobile application
- **Login Screen** = Initial authentication interface with email/password fields and social sign-in options
- **Registration Form** = Multi-step form collecting user identity and credentials
- **Splash Screen** = Initial app launch screen with logo animation
- **Onboarding** = Tutorial flow introducing core features (5 slides: welcome, understand needs, compare options, understand results, get started)
- **Profile Screen** = User account information and settings display
- **Dashboard** = Primary authenticated view showing decision overview and quick actions

---

### Requirement Group 2: Dashboard & Navigation

**User Story**: As a user, I want a clear dashboard with navigation to all features, so that I can easily access decisions, history, insights, and my profile.

#### Acceptance Criteria

1. THE Dashboard Screen SHALL display after successful authentication
2. THE Dashboard SHALL include:
   - User greeting with name and avatar
   - Notification bell icon (placeholder for future notifications)
   - Prominent "Create New Decision" call-to-action button
   - "Continue Your Decision" section showing ongoing decisions (horizontal scrollable cards)
   - "Decision Summary" with statistics (total decisions, what-if simulations, completed reviews)
   - "Recent Decisions" vertical list showing latest 5 decisions
3. WHEN user views "Continue Your Decision" cards, EACH card SHALL display:
   - Decision title and category icon
   - Progress percentage toward completion
   - Subtitle showing number of alternatives and criteria
   - Tap to resume decision-making from interrupted state
4. WHEN user views "Recent Decisions" list items, EACH item SHALL display:
   - Decision title, category, and associated alternative
   - Status badge (Draft, In Progress, Completed)
   - Timestamp (optional)
5. WHEN user taps "Create New Decision" button or Decision nav item, THE System SHALL navigate to Category Selection screen
6. THE System SHALL provide Bottom Navigation Bar (5 items) for primary user flows:
   - Home (Dashboard)
   - Decision (Create decision)
   - Insight (Analytics/Dashboard - placeholder)
   - History (Decision history list)
   - Profile (User account & settings)
7. WHEN user taps Bottom Navigation Bar items, THE System SHALL navigate to corresponding screen and persist selection state
8. WHEN Decision list is empty, THE System SHALL display empty state with message "No decisions yet" and prominent "Create New Decision" button
9. WHERE user has no ongoing decisions, THE System SHALL hide or gray out "Continue Your Decision" section
10. WHILE on Dashboard, IF user has unread notifications, THE System SHALL display badge count on Notification icon

#### Related Definitions
- **Decision Status**: States include Draft (created but not submitted), In Progress (submitted but incomplete), Completed (results calculated and saved)
- **Continue Your Decision**: List of decisions in Draft or In Progress status that user was previously working on

---

### Requirement Group 3: Category & Subcategory Selection

**User Story**: As a user, I want to select a decision category and subcategory, so that the system can provide relevant alternatives and criteria suggestions.

#### Acceptance Criteria

1. WHEN user initiates "Create New Decision" flow, THE System SHALL display Category Selection Screen showing 3 categories:
   - Technology (laptop, smartphone, computer components)
   - Education (courses, certifications, universities, bootcamps)
   - Fashion (clothing, shoes, accessories, bags)
2. EACH category card SHALL display:
   - Icon representing the category (SVG or image)
   - Category name
   - Visual highlight on tap (background color change, border emphasis)
3. WHEN user selects a category, THE System SHALL:
   - Update UI to show selected state (filled background, darker border)
   - Display Subcategory Selection panel below
4. WHEN category is selected, THE System SHALL populate subcategories dynamically from backend catalog:
   - Technology: Laptop, Smartphone, Tablet, Monitor, Gaming PC, Processor, Graphics Card
   - Education: Course, Certification, Bootcamp, University, Training Program
   - Fashion: Dress, Shoes, Accessories, Bags, Jewelry, Outerwear
5. THE System SHALL display subcategories as interactive chips (radio-button-like selection pattern)
6. WHEN user taps a subcategory chip, THE System SHALL:
   - Update subcategory selection state
   - Load relevant alternatives from catalog
7. IF user changes category selection after choosing subcategory, THE System SHALL reset subcategory selection
8. WHEN category and subcategory are selected, THE System SHALL enable navigation to next step (Alternative Management)
9. IF category list fails to load (network error), THEN THE System SHALL display error state and retry button
10. WHILE category selection is active, THE System SHALL cache category/subcategory metadata to improve UX on return

#### Related Definitions
- **Category**: Top-level classification (Technology, Education, Fashion)
- **Subcategory**: Specific type within category (e.g., Laptop within Technology)

---

### Requirement Group 4: Alternative Management (Add/Remove Options)

**User Story**: As a user, I want to add alternatives to compare from a catalog or by entering custom options, so that I can structure my decision problem.

#### Acceptance Criteria

1. WHEN user proceeds from category/subcategory selection, THE System SHALL display Alternative Management screen
2. THE System SHALL provide 2 input modes:
   - Mode A: Browse Catalog (pre-populated alternatives for selected subcategory)
   - Mode B: Custom Entry (user types in alternatives manually)
3. IN Catalog Mode:
   - THE System SHALL load and display 15-50 predefined alternatives (e.g., laptop models)
   - EACH alternative SHALL show name, brand/manufacturer, key specs (display price/processor/RAM as summary)
   - USER SHALL tap "+ Add" button to add alternative to decision
   - WHEN alternative is added, button SHALL change to "Added" (disabled state)
4. IN Custom Mode:
   - THE System SHALL provide TextField for user to enter custom alternative name
   - USER can add up to 10 alternatives per decision (Basic plan limit)
   - WHEN user types alternative name (e.g., "MacBook Pro M3"), THE System SHALL display in "Selected Options" list
5. FOR Basic Plan tier:
   - MAXIMUM 3 alternatives per decision
6. FOR Premium Plan tier:
   - MAXIMUM 10 alternatives per decision
7. WHEN alternative is added to selection, THE System SHALL:
   - Add to "Selected Options" list on screen
   - Display alternative with delete (X) icon
   - Update count badge "Options Compared (N)"
8. WHEN user taps delete icon on selected alternative, THE System SHALL remove from list and update count
9. IF user attempts to exceed plan tier limit (e.g., add 4th alternative on Basic), THEN THE System SHALL display upgrade prompt
10. WHEN alternative list has at least 2 items, THE System SHALL enable "Next" button to proceed to Criteria Selection
11. IF alternative list is empty or has <2 items, THE System SHALL disable "Next" button and display message "Select at least 2 alternatives"
12. WHILE browsing catalog, IF search/filter is provided, THE System SHALL support case-insensitive substring matching
13. WHILE Alternative Management is active, THE System SHALL allow back navigation to Category Selection, clearing alternative selections

#### Related Definitions
- **Catalog Mode**: Pre-populated list of common alternatives for a subcategory (e.g., popular laptop models)
- **Custom Mode**: User-entered free-text alternatives not in catalog
- **Plan Tier**: Subscription level determining feature limits (Basic = 3 alts/decision, Premium = 10 alts/decision)

---

### Requirement Group 5: Criteria Selection & Suggestion

**User Story**: As a user, I want to select evaluation criteria and optionally receive AI-powered suggestions, so that I can define how alternatives should be compared.

#### Acceptance Criteria

1. WHEN user proceeds from Alternative Management, THE System SHALL display Criteria Selection screen
2. THE System SHALL provide suggested criteria relevant to selected subcategory (e.g., for Laptop: Price, RAM, Storage, Processor Speed, Battery Life, Weight)
3. EACH suggested criterion SHALL display:
   - Checkbox for selection toggle
   - Criterion name
   - Criterion type indicator (Benefit or Cost) if visible in UI
4. WHEN user selects/deselects criteria checkboxes, THE System SHALL:
   - Update selected criteria list in real-time
   - Track criterion type (Benefit vs. Cost)
5. WHERE user wants custom criteria not in suggestions, THE System SHALL provide "+ Add Custom Criteria" button
6. WHEN user taps "+ Add Custom Criteria", THE System SHALL display inline form to:
   - Enter custom criterion name (TextField, max 50 chars)
   - Select type: Benefit or Cost (Radio buttons)
   - Save custom criterion
7. FOR Basic Plan tier:
   - MAXIMUM 3 criteria per decision (from suggestions or custom combined)
8. FOR Premium Plan tier:
   - MAXIMUM 8 criteria per decision
9. IF user attempts to exceed tier limit, THEN THE System SHALL display plan upgrade prompt
10. WHERE AI Suggestion Feature is available (Premium tier), THE System SHALL provide "AI Suggest Criteria" button
11. WHEN user taps "AI Suggest Criteria", THE System SHALL:
    - Call backend AI service with (Category, Subcategory, Alternatives)
    - Display top 5-7 suggested criteria with confidence scores (optional UI detail)
    - Allow user to add suggested criteria to selection
12. IF AI suggestion fails or is slow (>3 seconds), THEN THE System SHALL display error message and allow manual entry
13. WHEN criteria selection is complete (at least 1 criteria selected), THE System SHALL enable "Next" button to proceed to Priority Setting
14. IF no criteria selected, THE System SHALL disable "Next" and display "Select at least 1 criterion"

#### Related Definitions
- **Benefit Criteria**: Higher values are desirable (RAM: 16GB > 8GB)
- **Cost Criteria**: Lower values are desirable (Price: $800 < $1200)
- **AI Suggestion**: Leverages LLM to recommend relevant criteria for category/subcategory/alternatives

---

### Requirement Group 6: Priority & Weight Input

**User Story**: As a user, I want to assign weights (percentages) to criteria reflecting their importance, so that the Decision Engine can calculate results respecting my priorities.

#### Acceptance Criteria

1. WHEN user proceeds from Criteria Selection, THE System SHALL display Priority Input screen
2. FOR each selected criterion, THE System SHALL display:
   - Criterion name as label
   - Horizontal slider (0-100%)
   - Current percentage value display (right-aligned)
   - Unit indicator if applicable (e.g., "%" for weight)
3. WHEN user adjusts slider, THE System SHALL:
   - Update percentage display in real-time
   - Recalculate total percentage (sum of all criterion weights)
   - Update "Total" display below sliders
4. THE Total display SHALL show:
   - Label "Total"
   - Cumulative percentage (e.g., "75%")
   - Visual feedback: Green background if Total = 100%, Red background if Total ≠ 100%
5. WHEN Total percentage ≠ 100%, THE System SHALL disable "Calculate Result" button and display message "Total weight must equal 100%"
6. WHEN Total percentage = 100%, THE System SHALL enable "Calculate Result" button with primary styling
7. WHERE user wants to rebalance weights proportionally, THE System SHALL provide "Auto-Balance" button (optional optimization):
   - IF tapped, proportionally rescale weights to sum to 100%
8. WHEN user taps "Calculate Result" with valid weights, THE System SHALL:
   - Save weights locally or to session
   - Transmit decision parameters to Decision Engine API
   - Display loading state while calculating
9. IF calculation fails (network error, backend error), THEN THE System SHALL display error message with retry option
10. WHILE adjusting sliders, THE System SHALL provide haptic feedback (device vibration) on value changes (if device supports)
11. WHEN priority input is displayed, THE System SHALL display instructions: "Set importance for each criterion. Total must equal 100%"

#### Related Definitions
- **Priority/Weight**: Percentage value (0-100) representing criterion importance
- **Validation Rule**: Sum of all weights must equal exactly 100%

---

### Requirement Group 7: Decision Engine - SAW Calculation & Display

**User Story**: As a user, I want the Decision Engine to calculate and display results using the SAW (Simple Additive Weighting) method, so that I get transparent, explainable recommendations.

#### Acceptance Criteria

1. WHEN user submits valid decision parameters (alternatives, criteria, weights), THE Decision_Engine SHALL execute SAW calculation:
   - **Step 1 - Build Decision Matrix**: Collect raw values for each (alternative, criterion) pair
   - **Step 2 - Classify Criteria**: Determine if each criterion is Benefit (higher is better) or Cost (lower is better)
   - **Step 3 - Normalize**: 
     - FOR Benefit criteria: `Rij = Xij / MAX(Xij)` across all alternatives
     - FOR Cost criteria: `Rij = MIN(Xij) / Xij`
   - **Step 4 - Weight**: Multiply normalized value by criterion weight: `Yij = Rij × (Wj / 100)`
   - **Step 5 - Sum**: Calculate final score: `Si = Σ Yij` (sum across all criteria for alternative i)
   - **Step 6 - Rank**: Sort alternatives by Si in descending order
2. THE Decision_Engine SHALL store calculation results deterministically (same inputs always produce same output)
3. WHEN calculation succeeds, THE System SHALL display Result Screen with:
   - Ranked alternatives list (top recommendation highlighted)
   - Final composite scores for each alternative (displayed as percentage 0-100)
   - "Best Match" badge/highlight on top-ranked alternative
4. EACH result row SHALL display:
   - Rank number (1, 2, 3...)
   - Alternative name
   - Composite score (e.g., "82.5%")
   - Visual score indicator (progress bar or gauge)
   - Tap to expand for detail breakdown
5. WHEN user taps on a result row to expand, THE System SHALL show:
   - Individual criterion scores (normalized and weighted)
   - Calculation transparency: "Price: 0.75 × 30% = 22.5%"
6. IF calculation has an error (missing data, invalid inputs), THEN THE System SHALL:
   - Display error message with root cause (e.g., "Alternative 'Laptop A' is missing value for Price criterion")
   - Allow user to go back and fix data
7. WHERE missing data exists in decision matrix, IF all required data cannot be inferred, THEN THE System SHALL apply strategy:
   - FLAG missing value with warning indicator
   - OPTIONALLY allow user to provide fallback value or exclude criterion
8. THE System SHALL calculate and cache results for subsequent what-if simulations (reuse calculation with updated weights)
9. WHILE displaying results, THE System SHALL make calculation steps auditable (show normalization, weighting steps if expanded)

#### Related Definitions
- **Decision_Engine** = Backend SAW calculation component
- **Deterministic** = Given same inputs, always produces exact same output (reproducible)
- **Transparent** = Calculation steps are visible/explainable to user

---

### Requirement Group 8: AI-Powered Result Explanation

**User Story**: As a user, I want AI-powered explanations of decision results, so that I understand what factors influenced the recommendation.

#### Acceptance Criteria

1. WHEN results are displayed, THE System SHALL fetch AI explanation from backend AI_Service
2. THE AI_Service SHALL receive decision context:
   - Selected alternatives and their ranks
   - Weighted criterion scores
   - User's priorities (weights)
   - Normalized values
3. THE AI_Service SHALL generate natural language explanation including:
   - Recommendation statement (e.g., "Based on your priorities, Laptop A is the best fit")
   - Top 3 factors driving recommendation (e.g., "Laptop A excels in Performance (95%) and Value (80%)")
   - Trade-offs if top 2 alternatives are close (e.g., "Laptop B offers better battery life but trails in processing speed")
   - Personalized insight based on user weights (e.g., "You prioritized Price (40%), so we favored cost-effective options")
4. WHEN explanation is generated, THE System SHALL display it in Result Screen under "AI Insight" section
5. THE AI explanation text SHALL be 150-300 words, written in clear, user-friendly language
6. FOR Basic Plan tier:
   - AI explanation is brief (1-2 key factors)
7. FOR Premium Plan tier:
   - AI explanation is detailed (3-4 factors with nuance)
8. IF AI explanation generation fails (LLM timeout, API error), THEN THE System SHALL:
   - Display fallback static explanation (e.g., "Laptop A scores highest overall")
   - Log error for monitoring
9. WHERE user dismisses or hides AI explanation, THE System SHALL remember preference for session
10. WHILE explanation is displayed, THE System SHALL include "How is this calculated?" link to show SAW methodology

#### Related Definitions
- **AI_Service** = Backend LLM integration for natural language generation
- **Trade-offs** = Competitive dimensions where alternatives differ significantly
- **AI Insight** = Generated natural language explanation of calculation results

---

### Requirement Group 9: Comparison Feature (Side-by-Side)

**User Story**: As a user, I want to compare alternatives side-by-side with criterion-level details, so that I can understand differences across all dimensions.

#### Acceptance Criteria

1. WHEN result is displayed, THE System SHALL provide "Compare" action button/link
2. WHEN user taps "Compare", THE System SHALL display Comparison Screen with:
   - Horizontal scrollable table (alternatives as columns, criteria as rows)
   - Each cell shows raw or normalized value for (alternative, criterion) pair
   - Column headers show alternative name and current rank/score
   - Visual indicators (color coding by performance: green for high, red for low, gray for neutral)
3. EACH comparison cell SHALL display:
   - Raw value in primary text (e.g., "16GB", "$899")
   - Normalized value in secondary text or tooltip (e.g., "1.0 normalized")
4. THE Comparison Screen SHALL highlight best performer in each criterion row:
   - Bold or colored background for highest value (Benefit criteria) or lowest (Cost criteria)
5. WHERE alternatives are many (>6), THE System SHALL provide:
   - Horizontal scroll for viewing all alternatives
   - Sticky column for criterion names (left fixed)
6. WHEN user taps a cell value, THE System SHALL display tooltip or modal showing:
   - Criterion definition
   - Calculation (normalized × weight)
   - How this criterion affected ranking
7. WHILE in Comparison view, THE System SHALL provide "Return to Results" button to go back

#### Related Definitions
- **Comparison Screen** = Side-by-side view of alternatives across all criteria with performance indicators

---

### Requirement Group 10: What-If Simulation Feature

**User Story**: As a user, I want to simulate how decision results change if I adjust priority weights, so that I can explore impact of different preferences.

#### Acceptance Criteria

1. WHEN result is displayed, THE System SHALL provide "What-If" action button or access via menu
2. WHEN user taps "What-If", THE System SHALL display What-If Simulation Screen showing:
   - Current priorities (sliders for each criterion, same as Priority Input screen)
   - Current ranking preview (top 3 alternatives with scores)
   - Real-time recalculation as user adjusts sliders
3. WHEN user adjusts a priority slider in What-If mode:
   - THE System SHALL re-normalize and re-calculate in real-time (client-side or fast backend call)
   - Update ranking preview to show new order and scores
   - Highlight changes (new top alternative if changed, score delta)
4. FOR each criterion adjustment, THE System SHALL display:
   - Original weight
   - New weight (adjusted)
   - Visual delta indicator (↑ if increased, ↓ if decreased)
5. WHEN total weight drifts from 100% (e.g., user moved 1 slider up but others down unproportionally), THE System SHALL:
   - Display total indicator (as in Priority Input)
   - Disable "Save Simulation" until total = 100%
   - Provide "Auto-Balance" to restore proportional weights
6. WHEN user finishes what-if adjustment and total = 100%, THE System SHALL enable "Save as New Decision" button
7. WHEN user taps "Save as New Decision", THE System SHALL:
   - Create new decision record with adjusted priorities
   - Calculate and display results for simulated scenario
   - Store both original and simulated decision for comparison
8. WHERE Premium Plan unlocks unlimited what-ifs, WHERE Basic Plan has restricted simulation (e.g., 1 per decision), THE System SHALL enforce limit and display upgrade prompt
9. WHILE in What-If mode, IF user returns to Results without saving, THE System SHALL discard temporary changes
10. WHEN comparison between original and simulated results is needed, THE System SHALL provide side-by-side view of:
    - Original ranking with original weights
    - Simulated ranking with new weights
    - Alternatives that changed position

#### Related Definitions
- **What-If Simulation** = Interactive exploration of alternative outcomes by adjusting priority weights
- **Real-time Recalculation** = Immediate update of ranking as weights change (within <500ms)

---

### Requirement Group 11: Decision History & Persistence

**User Story**: As a user, I want to save and review past decisions with full details and calculation history, so that I can evaluate my decision-making over time.

#### Acceptance Criteria

1. WHEN decision is completed and results displayed, THE System SHALL provide "Save Decision" button/action
2. WHEN user taps "Save Decision", THE System SHALL:
   - Store decision record in backend database with metadata (userId, createdAt, status='Completed')
   - Store all calculation inputs (alternatives, criteria, weights, raw values)
   - Store calculation outputs (scores, rankings, SAW breakdown)
   - Display confirmation message
3. AFTER saving, THE System SHALL enable "View History" navigation to access saved decisions
4. WHEN user navigates to History Screen, THE System SHALL display:
   - List of all saved decisions for authenticated user
   - Decision title, category, subcategory, date created
   - Decision status (Completed, In Progress, Draft)
   - Quick action: tap to view full details
5. WHEN user taps a decision in history list, THE System SHALL display Decision Detail Screen showing:
   - All decision inputs (alternatives, criteria, weights)
   - SAW calculation results with all scores and rankings
   - AI explanation from original calculation
   - Timestamp (created, last modified)
   - Action buttons: Re-simulate, Export, Delete
6. WHERE decision list is long (>20 items), THE System SHALL provide:
   - Pagination or infinite scroll (load 10 items, fetch more on scroll)
   - Filter by category or date range
   - Search by decision title/alternative name
7. FOR Basic Plan tier:
   - Store up to 10 completed decisions, 1 draft in progress
8. FOR Premium Plan tier:
   - Unlimited decision storage
9. IF storage limit is reached (Basic tier), THE System SHALL:
   - Warn user when creating 11th decision
   - Prompt to upgrade or delete old decision
10. WHEN user selects "Delete" on a historical decision, THE System SHALL:
    - Display confirmation dialog
    - Permanently remove from database (or soft-delete for audit trail)
11. WHILE viewing historical decision, IF user taps "Re-simulate", THE System SHALL create new What-If session with original parameters
12. IF decision data cannot be loaded (network error, deleted by admin), THEN THE System SHALL display "Decision not found" message

#### Related Definitions
- **Decision History** = Persisted log of all completed decisions with full calculation details
- **In Progress** = Decision created but not yet completed/saved
- **Draft** = Ongoing decision session not yet finalized

---

### Requirement Group 12: Access Control & Role-Based Features

**User Story**: As a system, I want to enforce access control based on user role and subscription tier, so that features are available only to authorized users with appropriate plans.

#### Acceptance Criteria

1. THE System SHALL support 4 user roles with distinct permissions:
   - **Guest**: Unauthenticated, limited to onboarding and login flow
   - **Basic**: Authenticated free tier, limited feature access
   - **Premium**: Authenticated paid tier, full feature access
   - **Admin**: Backend-only role for catalog/user management (not mobile app scope)
2. WHEN unauthenticated user (Guest) attempts to access protected screen (Dashboard, Create Decision), THE System SHALL redirect to Login
3. FOR Guest role:
   - Can view Onboarding screens
   - Can access Login/Register
   - Can view AI explanations in demo mode (no calculation)
4. FOR Basic tier authenticated user:
   - Max 5 decisions per month
   - Max 3 alternatives per decision
   - Max 3 criteria per decision
   - Single ongoing what-if simulation
   - Basic AI explanation (1-2 key factors)
   - History view limited to 10 decisions
5. FOR Premium tier authenticated user:
   - Unlimited decisions per month
   - Max 10 alternatives per decision
   - Max 8 criteria per decision
   - Unlimited what-if simulations
   - Detailed AI explanation (3-4 factors with nuance)
   - Full history storage (unlimited)
6. WHEN Basic tier user attempts to exceed a quota (e.g., add 4th criterion), THE System SHALL:
   - Display inline upgrade prompt: "Upgrade to Premium for unlimited criteria"
   - Provide action button "Upgrade Now" linking to upgrade page/flow
7. WHEN user views profile, THE System SHALL display:
   - Current tier (Basic, Premium)
   - Usage statistics (decisions created this month, criteria used)
   - Upgrade button if on Basic tier
8. WHILE user is on Free tier, THE System SHALL display "Premium" badge on limited features as preview
9. IF user's plan expires or is downgraded, THE System SHALL:
   - Still preserve historical decisions (read-only)
   - Restrict new creation to tier limits
   - Display notification of plan change

#### Related Definitions
- **Role** = User classification (Guest, Basic, Premium, Admin)
- **Tier/Plan** = Subscription level (Basic = free, Premium = paid)
- **Quota** = Numerical limit on feature usage (decisions/month, alternatives/decision, etc.)
- **Access Control** = Permission system enforcing role/tier restrictions

---

### Requirement Group 13: Data Validation & Error Handling

**User Story**: As a user, I want clear error messages and validation feedback, so that I can correct input issues and understand why operations fail.

#### Acceptance Criteria

1. WHEN user enters data in forms (registration, alternative names, criterion values), THE System SHALL validate in real-time or on submit:
   - Email format (RFC 5322): `Invalid email format`
   - Password complexity: `Password must be at least 8 characters with 1 uppercase, 1 number`
   - Text length limits: `Maximum 50 characters`
   - Numeric ranges (for weights): `Value must be between 0 and 100`
   - Required fields: `This field is required`
2. WHEN validation fails on submit, THE System SHALL:
   - Highlight invalid fields with red border
   - Display error message below or in tooltip
   - Disable submit button until resolved
3. WHEN alternative list has <2 items, THE System SHALL display warning: "Select at least 2 alternatives to compare"
4. WHEN criterion list has <1 item, THE System SHALL display warning: "Select at least 1 criterion"
5. WHEN priority weights don't sum to 100%, THE System SHALL display: "Total weight must equal 100% (currently XX%)"
6. WHEN API request fails (network error, 500 error), THE System SHALL:
   - Display user-friendly message: "Something went wrong. Please try again."
   - Provide retry button
   - Log error with timestamp for debugging
7. WHEN timeout occurs (request >10 seconds), THE System SHALL:
   - Cancel request and display: "Request timed out. Check your connection."
   - Offer retry
8. WHEN Decision Matrix has missing values (e.g., Alternative A has no value for Price criterion), THE System SHALL:
   - Flag missing cell with warning indicator
   - Prevent calculation unless value is provided
   - Display: "Price value is required for Laptop A"
9. WHEN Decision Engine calculation fails, THE System SHALL display error with actionable suggestion:
   - "Calculation failed. Ensure all alternatives have values for selected criteria. [View Details]"
10. WHEN user tries to proceed without completing required step, THE System SHALL disable "Next" button and display inline help text
11. WHILE form is being submitted, THE System SHALL display loading indicator and disable all inputs to prevent duplicate submission

#### Related Definitions
- **Validation** = Client-side or server-side verification that inputs meet requirements
- **Error State** = UI state displaying error message and recovery options

---

### Requirement Group 14: Privacy & Data Protection

**User Story**: As a user, I want my personal data and decision history to be protected, so that I trust the system with my information.

#### Acceptance Criteria

1. WHEN user provides personal information (email, name, decisions, priorities), THE System SHALL:
   - Transmit via HTTPS/TLS encryption (no unencrypted data)
   - Store in backend database with at-rest encryption
   - Never log sensitive data (password, email, decision content) to console or analytics
2. WHEN user is logged in, THE System SHALL:
   - Store authentication token securely (encrypted shared preferences on Android, Keychain on iOS)
   - Not expose token in logs or network inspection
3. WHEN user logs out, THE System SHALL:
   - Clear authentication token from device storage
   - Invalidate session on backend
4. WHEN user requests data deletion (future GDPR compliance), THE System SHALL support:
   - Delete all personal data and associated decisions within 30 days
5. WHERE Personal Identifiable Information (PII) is displayed (email, name in profile), THE System SHALL:
   - Mask or redact in screenshots/exports if feature is added
   - Display only to authenticated user viewing own profile
6. WHEN decision data is transmitted for AI explanation generation, THE System SHALL:
   - Send only necessary decision context (not user email or sensitive PII)
   - Use backend-to-backend communication (not direct client-to-AI-service)
7. IF decision is shared or exported (future feature), THE System SHALL:
   - Provide option to exclude decision metadata (creator name, timestamps)
   - Require user consent before sharing

#### Related Definitions
- **PII (Personal Identifiable Information)** = Email, name, phone, date of birth, personal decisions
- **HTTPS/TLS** = Secure encrypted network communication
- **At-rest Encryption** = Data encrypted when stored in database

---

### Requirement Group 15: Platform-Specific Requirements (Flutter/Android/iOS)

**User Story**: As a user, I want the app to work seamlessly across Android and iOS platforms with native look and feel, so that I have a consistent, high-quality experience.

#### Acceptance Criteria

1. THE System SHALL be built using Flutter framework (Dart language) supporting:
   - Android 5.0 (API 21) and above
   - iOS 11 and above
2. THE System SHALL follow Material Design 3 guidelines for Android UI/UX consistency
3. THE System SHALL follow Human Interface Guidelines (HIG) principles for iOS (if applicable)
4. THE System SHALL use native components where available (dialogs, pickers, bottom sheets)
5. WHEN running on Android, THE System SHALL:
   - Support portrait orientation only (no landscape mode in Phase 1)
   - Respect system-wide dark mode preference
   - Use Android Material Design colors and typography
   - Support Android Back button for navigation
6. WHEN running on iOS, THE System SHALL:
   - Support portrait orientation only
   - Display status bar appropriately (notch support)
   - Use iOS-appropriate navigation gestures (back swipe)
7. THE System SHALL handle screen size variations:
   - Test on minimum 4.5" screen (small phone)
   - Test on maximum 6.7" screen (large phone)
   - Responsive layout adjusting padding/font size proportionally
8. WHEN device has limited connectivity (offline), THE System SHALL:
   - Cache critical data (category, subcategory lists)
   - Display "No connection" message for features requiring internet
   - Allow offline result viewing if decision was previously calculated
9. WHEN device has limited memory or battery, THE System SHALL:
   - Optimize image sizes (compress to device DPI)
   - Avoid continuous animation/background tasks
   - Display power-saving mode hint if available
10. WHEN app is backgrounded and then returned to foreground, THE System SHALL:
    - Restore UI state (current screen, form progress)
    - Re-authenticate if session expired (>1 hour idle)
11. THE System SHALL support navigation gestures:
    - Back button/swipe to pop navigation stack
    - Bottom navigation bar tab switching
    - Quick access via deep linking (optional)
12. THE System SHALL minimize APK/IPA file size:
    - APK target <30MB (uncompressed)
    - Use tree-shaking to remove unused dependencies

#### Related Definitions
- **Flutter** = Multi-platform UI framework using Dart
- **Material Design 3** = Android design specification for Material Design v3
- **HIG (Human Interface Guidelines)** = Apple's iOS/iPadOS design guidelines
- **Deep Linking** = URI-based navigation (optional future feature)

---

### Requirement Group 16: Data Integrity - SAW Calculation Determinism

**User Story**: As a system, I want decision calculations to be deterministic and reproducible, so that users trust results are consistent and not randomized.

#### Acceptance Criteria

1. WHEN Decision Engine calculates SAW for decision D with inputs (alternatives, criteria, weights, values), THE calculation SHALL be deterministic:
   - **Same inputs → Same output** (reproducible within numerical precision)
   - Normalization algorithm produces identical normalized values when recalculated
   - Weighted scores are calculated identically
   - Final ranking order is consistent
2. WHEN calculation is repeated hours later with same historical decision, THE System SHALL produce identical results (within floating-point precision ±0.001%)
3. WHEN comparing two decisions with same parameters, BOTH SHALL produce identical rankings and scores
4. THE Normalization algorithm SHALL use well-defined formula:
   - **Benefit**: `Rij = Xij / MAX(Xij)` where MAX is across all alternatives for criterion j
   - **Cost**: `Rij = MIN(Xij) / Xij` where MIN is across all alternatives for criterion j
   - No rounding or stochastic variation
5. WHEN values contain edge cases (e.g., all alternatives have same value for criterion), THE System SHALL:
   - Handle without error (e.g., MAX = current value, Rij = 1.0)
   - Document behavior in AI explanation: "All laptops have identical storage"
6. IF calculated result differs between subsequent runs for same decision, THEN THIS IS A BUG that SHALL be investigated and fixed
7. WHEN exporting or sharing calculation details, THE System SHALL include:
   - Version number of calculation algorithm
   - Timestamp of calculation
   - Full input parameters (for reproducibility verification)
8. WHERE numerical precision may vary (floating-point arithmetic), THE System SHALL:
   - Round to 2 decimal places for display
   - Compare with tolerance threshold (±0.001) for equality checks

#### Related Definitions
- **Deterministic** = Predictable, reproducible, not random
- **Normalization** = Formula to convert raw values to 0-1 scale

---

### Requirement Group 17: AI Integration Guardrails & Limitations

**User Story**: As a system, I want to ensure AI-generated content is helpful but bounded, so that users make informed decisions without over-relying on AI.

#### Acceptance Criteria

1. WHEN AI generates explanations, criteria suggestions, or insights, THE System SHALL:
   - Display disclaimer: "AI-powered insights are suggestions, not guarantees. Your decision is ultimately yours."
   - Clearly label AI-generated content (e.g., "AI Insight", "Suggested by AI")
2. WHEN AI Criteria Suggestion is used, THE System SHALL:
   - Return top 5-7 suggestions (not unlimited)
   - Display confidence score if available
   - Allow user to accept/reject each suggestion
3. WHEN AI Explanation is generated, THE System SHALL:
   - Ensure explanation is grounded in actual calculation (not fabricated insights)
   - Avoid anthropomorphizing alternatives (not: "Laptop A is happy with this choice")
   - Focus on factors (performance, price) not aspirational messaging
4. WHERE AI generates explanation, THE System SHALL verify:
   - Explanation references actual top 3 factors from SAW calculation
   - No contradictions with ranking results
   - Trade-off statements are factually accurate
5. IF AI suggestion confidence is low (<0.5), THE System SHALL:
   - Display lower-confidence suggestions visually distinct (lighter text, footnote)
   - Encourage user to define custom criteria instead
6. WHEN calculation contains missing or ambiguous data, THE System SHALL:
   - NOT fill gaps with AI inference (e.g., assume missing price)
   - Instead, prompt user to provide or confirm value
7. THE System SHALL NOT:
   - Make final decision recommendations (e.g., "You should choose Laptop A")
   - Use dark patterns to push user toward premium features
   - Collect user decision patterns for alternative purposes (profiling)
   - Train custom models on user data without explicit consent
8. WHERE AI service fails or times out (>5 seconds), THE System SHALL:
   - Display fallback static explanation
   - Offer to retry
   - NOT display broken/partial AI text
9. WHILE AI features are under development or limited, THE System SHALL clearly indicate:
   - Feature status (e.g., "AI Suggestions coming soon")
   - Availability by tier (e.g., "Premium only")

#### Related Definitions
- **AI Guardrails** = Constraints ensuring AI output is helpful, harmless, and honest
- **Confidence Score** = Model's estimate of suggestion reliability (0-1 scale)
- **Dark Patterns** = Manipulative UI/UX design pushing unwanted behavior

---

## Integration Points & Product/Backend Decisions

The following integrations are flagged as requiring explicit product/backend decisions:

### 1. **Authentication Provider**
- **Current State**: Placeholder (login accepts any credentials)
- **Required Decision**: Select provider:
  - Firebase Authentication (Google, Email/Password, Anonymous)
  - Custom JWT-based backend
  - Third-party (Auth0, Supabase, etc.)
- **Impact**: Affects login flow, token management, security

### 2. **AI Services**
- **Current State**: No AI integration
- **Required Decisions**:
  - **Criteria Suggestions**: Which LLM? (OpenAI GPT, Google PaLM, Anthropic Claude, custom fine-tuned model)
  - **Result Explanations**: Same LLM or separate?
  - **Hosting**: Backend-to-backend or direct mobile-to-API calls?
  - **Cost Model**: Rate limiting, monthly quota per tier?
- **Impact**: Feature availability, latency, cost structure

### 3. **Persistence & Database**
- **Current State**: No backend data store
- **Required Decisions**:
  - **Database**: PostgreSQL (Supabase), Firebase Firestore, MongoDB, or other?
  - **Schema**: How to store Decision Matrix, calculation history, user preferences?
  - **Caching**: Redis for decision cache or simple TTL?
- **Impact**: Data model design, query performance, scalability

### 4. **Analytics & Monitoring**
- **Current State**: No analytics collection
- **Required Decisions**:
  - **What to track?** (Feature usage, error rates, decision completion rate, AI explanation quality)
  - **Tool**: Firebase Analytics, Mixpanel, custom logging?
  - **Privacy**: What data can be collected per privacy policy?
- **Impact**: Business insights, debugging, GDPR compliance

### 5. **Payment Processing** (Future)
- **Current State**: No payment system
- **Required Decisions** (for Premium tier):
  - **Provider**: Stripe, Google Play Billing, Apple In-App Purchase?
  - **Model**: Subscription (monthly/annual) or one-time?
  - **Trial Period**: Free tier transition to Premium?
- **Impact**: Monetization strategy, user acquisition

### 6. **Push Notifications** (Future)
- **Current State**: Placeholder notification icon (non-functional)
- **Required Decision**: Implement or defer to Phase 2?
  - **Use Cases**: Decision deadline reminders, new AI feature notifications, upgrade prompts
  - **Service**: Firebase Cloud Messaging, OneSignal, or custom?
- **Impact**: User engagement, retention

---

## Non-Functional Requirements

### Performance
- Decision Engine calculation SHALL complete within 2 seconds for typical decision (5-10 alternatives, 3-5 criteria)
- API response time for decision retrieval SHALL be <1 second (p95)
- App startup time SHALL be <3 seconds from cold boot
- UI responsiveness: all gestures SHALL respond within 100ms

### Availability
- System SHALL support 99% uptime (backend) excluding maintenance windows
- Mobile app SHALL gracefully handle offline scenarios (cached data, retry logic)

### Reliability
- Decision calculation results SHALL be accurate to 2 decimal places
- Decision history SHALL have zero data loss (transactions, backups)
- Failed operations SHALL provide clear error messages and recovery paths

### Usability
- All screens SHALL be navigable without external documentation
- First-time users SHALL complete decision creation in <5 minutes
- Error messages SHALL be phrased in simple language (no technical jargon)

### Security
- All data transmissions SHALL use HTTPS/TLS
- Authentication tokens SHALL expire after 24 hours of inactivity
- Passwords SHALL be salted and hashed using bcrypt or equivalent
- No sensitive data (email, password) SHALL be logged

### Scalability
- System SHALL support 10,000 concurrent users
- Database SHALL scale horizontally for decision history storage

---

## Assumptions & Constraints

### Assumptions
- Users have Android/iOS smartphones with screen size 4.5"-6.7"
- Typical internet connection available (cellular or WiFi)
- Users understand basic decision-making concepts (alternatives, criteria)
- Backend API and database are deployed separately (outside app scope)
- AI LLM services are available via third-party API calls

### Constraints
- **Scope**: Android/iOS mobile app only (no web version in Phase 1)
- **Language**: English UI/UX (internationalization deferred to Phase 2)
- **Orientation**: Portrait mode only (no landscape rotation)
- **Framework**: Flutter/Dart (no native code in Phase 1)
- **Cost Criteria Type**: Only Binary (Benefit/Cost), not complex multi-tier types

---

## Compliance & Privacy

- All handling of user data complies with GDPR requirements (right to deletion, data portability, consent)
- Privacy policy SHALL be displayed before registration
- No third-party data sharing without explicit user consent
- Decision data remains user-owned and is not used for AI model training without consent

---

## Verification Strategy

This requirements document will be verified through:

1. **Acceptance Testing**: Each requirement group SHALL have acceptance tests validating all criteria
2. **Property-Based Testing** (for specific quantifiable properties like SAW determinism)
3. **User Testing**: Real users SHALL complete decision workflows and provide feedback
4. **Integration Testing**: Frontend-Backend API contracts SHALL be validated

---

**Document Version**: 1.0  
**Date**: January 2025  
**Status**: Initial Requirements Phase  
**Next Step**: Design Document (Phase 2)
