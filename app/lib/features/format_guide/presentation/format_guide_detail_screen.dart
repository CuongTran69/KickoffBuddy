import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../data/format_guide_repository.dart';
import '../data/format_guide_section.dart';

/// Detail screen for a single tournament format guide section.
///
/// Shows the section title, full body text, and an optional numbered bullet
/// list (e.g. tiebreaker steps, knockout rounds).
class FormatGuideDetailScreen extends ConsumerStatefulWidget {
  const FormatGuideDetailScreen({super.key, required this.sectionId});

  final String sectionId;

  @override
  ConsumerState<FormatGuideDetailScreen> createState() =>
      _FormatGuideDetailScreenState();
}

class _FormatGuideDetailScreenState
    extends ConsumerState<FormatGuideDetailScreen> {
  Future<FormatGuideSection?>? _sectionFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the future so it doesn't re-run on every setState.
    _sectionFuture ??=
        ref.read(formatGuideRepositoryProvider).getById(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return PremiumScreenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(l10n.formatGuide_appBar_title),
        ),
        body: FutureBuilder<FormatGuideSection?>(
          future: _sectionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      l10n.formatGuide_error_load,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.formatGuide_btn_back),
                    ),
                  ],
                ),
              );
            }

            final section = snapshot.data;

            if (section == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      l10n.formatGuide_notFound,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.formatGuide_btn_back),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    section.titleVi,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Body text
                  Text(
                    section.bodyVi,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                    ),
                  ),
                  // Numbered bullet list (only when non-empty)
                  if (section.bullets.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < section.bullets.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${i + 1}.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.7,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    section.bullets[i],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
