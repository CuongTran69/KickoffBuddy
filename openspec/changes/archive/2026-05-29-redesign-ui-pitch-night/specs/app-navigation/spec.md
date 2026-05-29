## ADDED Requirements

### Requirement: Persistent bottom navigation shell
The app SHALL present a persistent bottom `NavigationBar` hosting four primary destinations: Home, Matches, Rules, and Vocabulary. The navigation bar SHALL remain visible while navigating within any of these sections.

#### Scenario: Navigation bar shows four destinations
- **WHEN** the app is launched and onboarding is complete
- **THEN** a bottom navigation bar is displayed with four destinations (Home, Matches, Rules, Vocabulary) labeled in the active locale

#### Scenario: Switching tabs preserves each tab's state
- **WHEN** the user navigates within one tab (e.g. scrolls the match list) and switches to another tab and back
- **THEN** the original tab's scroll position and state are preserved

#### Scenario: Active destination is visually indicated
- **WHEN** a destination is selected
- **THEN** that destination shows a filled icon and the navigation indicator with the emerald accent color

### Requirement: Onboarding and detail routes excluded from shell
The navigation shell SHALL NOT wrap the onboarding flow or detail/add routes. Onboarding SHALL display without a navigation bar, and detail/add screens (match detail, magic add, manual add, rule detail) SHALL push over the navigation bar as full-screen routes.

#### Scenario: Onboarding has no navigation bar
- **WHEN** the user is in the onboarding flow
- **THEN** no bottom navigation bar is shown

#### Scenario: Detail screen pushes over navigation
- **WHEN** the user opens a match detail from any tab
- **THEN** the match detail screen is shown as a pushed route with a back affordance, not as a navigation tab

### Requirement: Initial route respects onboarding state
The app SHALL route to the onboarding flow when onboarding is not complete, and to the navigation shell (defaulting to the Home tab) when onboarding is complete.

#### Scenario: First launch routes to onboarding
- **WHEN** the app launches and `onboarding_completed` is false
- **THEN** the onboarding flow is shown

#### Scenario: Subsequent launch routes to Home tab
- **WHEN** the app launches and `onboarding_completed` is true
- **THEN** the navigation shell is shown with the Home tab active
