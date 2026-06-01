## Context

Kickoff Buddy is a Flutter football companion app for casual/international fans, organized around three value layers: Plan, Protect, Understand. The "Understand" layer already ships two static-content features — Rule Cards and Fan Etiquette — that follow an identical pattern: a bundled JSON asset, a repository that lazily loads and caches it, Riverpod providers, and list/detail screens built on `PremiumScreenBackground`.

The 2026 World Cup introduces a brand-new 48-team / 12-group format with novel advancement and tiebreaker rules. This change adds a Format Guide that explains that format. The newest analogous feature, `etiquette` (`app/lib/features/etiquette/`), is the reference implementation; this design deliberately reuses its structure to minimize risk and keep the codebase consistent.

## Goals / Non-Goals

**Goals:**
- Explain the WC2026 format offline, in bite-sized Vietnamese-primary sections.
- Reuse the proven static-content pattern (etiquette) for model, repository, providers, screens, routing, and Settings entry.
- Support ordered step lists (tiebreaker sequence, knockout rounds) via an optional `bullets` field.
- Keep content factually accurate against official FIFA WC2026 sources, with a disclaimer that FIFA may update exact criteria.
- Match the existing test bar for static-content features (repository unit test + list-screen widget test).

**Non-Goals:**
- No animated or graphical bracket visualization — a clean, scrollable stage list only.
- No English body content — Vietnamese-primary, consistent with etiquette (UI chrome labels remain localized EN/VI).
- No home-screen surfacing, no quiz, no live data, no API, no new dependencies.

## Decisions

**D1: Mirror the `etiquette` feature structure rather than inventing a new pattern.**
The etiquette feature is the most recent static-content implementation and already encodes the project's conventions (lazy-cached repository, `Provider` + `FutureProvider`, `PremiumScreenBackground`, push-to-detail navigation, retry-on-error via `ref.invalidate`). Reusing it gives consistency and the lowest implementation risk.
- Alternative considered: extend Rule Cards with a "format" topic. Rejected — Rule Cards is keyed on the 7-topic × 3-level matrix and a level filter, which does not fit a single linear format explainer.

**D2: Single data model `FormatGuideSection` with an optional ordered `bullets` list.**
Fields: `id`, `titleVi`, `bodyVi`, `icon` (Material icon name string), and `bullets: List<String>` defaulting to `const []`. The `bullets` field is what makes the guide "interactive/structured" — it renders as a numbered list for the tiebreaker sequence and knockout rounds. Sections without bullets render body text only.
- Alternative considered: a richer nested schema (sub-sections, links). Rejected — over-engineered for six static sections; the flat model matches `EtiquetteTip` and is trivially testable.

**D3: No Isar / no persistence.** Content is read-only and tiny (six sections). Lazy load from `rootBundle` with an in-memory `_cache`, exactly like `EtiquetteRepository`. This is the same D1 rationale documented in the etiquette and rule-card repositories.

**D4: Routes registered outside the shell.** The list and detail screens are pushed over the bottom-nav shell (like `/etiquette` and `/etiquette/:id`), not added as a new tab. Entry is via the Settings "Resources & Reference" card. This keeps the four-tab shell unchanged and matches where the other "Understand" reference features live.

**D5: Asset uses `{ "sections": [...] }` envelope.** Consistent with `etiquette_tips.json` (`{ "tips": [...] }`) and `rule_cards.json` (`{ "cards": [...] }`). The directory `assets/data/` is already declared in `pubspec.yaml`, so no manifest change is needed.

**D6: Content accuracy and disclaimer.** Advancement numbers (24 group qualifiers + 8 best third-placed = 32) and the tiebreaker order (points → goal difference → goals scored → head-to-head → fair-play points → FIFA ranking/draw) follow official FIFA WC2026 reporting. The tiebreakers section ends with a one-line note that FIFA may update exact criteria, so the content does not over-promise precision.

## Risks / Trade-offs

- **Content becomes inaccurate if FIFA updates rules** → Mitigation: include an explicit "subject to FIFA updates" line in the tiebreakers section; content lives in a single JSON file that is easy to patch.
- **Tiebreaker nuance is hard to convey simply** → Mitigation: lead with the points-first principle in body text, then present the ordered sequence as numbered bullets so casual readers can skim.
- **Pattern drift from etiquette** → Mitigation: this design pins the etiquette feature as the exact reference; the verifier checks parity (loading/error/empty/not-found states, retry behavior, styling).
- **Localization regen** → Mitigation: add keys to both ARB files and run `flutter gen-l10n`; the build/test step catches any missing-key or generation errors.

## Migration Plan

Purely additive; no data migration. New files plus small edits to routing and Settings. Rollback = remove the feature folder, the asset, the two routes, the Settings tile, and the `formatGuide_*` keys. No persisted state, no schema, no network.

## Open Questions

None — all decisions resolved from existing codebase patterns and confirmed FIFA WC2026 sources during exploration.
