## ADDED Requirements

### Requirement: Home dashboard shows next upcoming match hero
The Home tab SHALL display a hero card for the next upcoming match (the match with the earliest `kickoffAtUtc` strictly after now). The hero SHALL show both team flags, both team names (in the active locale), the localized kickoff date/venue, and a live countdown.

#### Scenario: Next match exists
- **WHEN** the Home tab is shown and at least one match has a kickoff time in the future
- **THEN** the hero card displays that match's flags, team names, kickoff date/venue, and a countdown to kickoff

#### Scenario: No upcoming match
- **WHEN** the Home tab is shown and no match has a future kickoff time
- **THEN** the hero card shows a "no upcoming match" state with a call-to-action to browse matches

#### Scenario: Data loading
- **WHEN** the next-match data is still loading
- **THEN** the hero area shows a loading indicator rather than empty or error content

### Requirement: Live countdown on hero
The hero SHALL display a countdown that updates over time without requiring the user to leave and re-enter the screen. The countdown SHALL be formatted using tabular figures and localized labels.

#### Scenario: Countdown updates
- **WHEN** the hero is displayed with a future match
- **THEN** the countdown reflects the remaining time and refreshes at least once per minute

#### Scenario: Countdown formatting by magnitude
- **WHEN** the remaining time is more than a day
- **THEN** the countdown shows days and hours; **WHEN** less than a day, it shows hours and minutes

### Requirement: Hero quick actions
The hero card SHALL provide quick actions to set a reminder and to view the match detail for the displayed match.

#### Scenario: View detail from hero
- **WHEN** the user taps the "view detail" action on the hero
- **THEN** the app navigates to that match's detail screen

#### Scenario: Set reminder from hero
- **WHEN** the user taps the "set reminder" action on the hero
- **THEN** the reminder flow for that match is initiated

### Requirement: Quick learn section
The Home dashboard SHALL display a "quick learn" section linking to rule cards, giving users one-tap access to learning content from the home screen.

#### Scenario: Quick learn entries navigate to rules
- **WHEN** the user taps a quick-learn entry
- **THEN** the app navigates to the corresponding rule card content
