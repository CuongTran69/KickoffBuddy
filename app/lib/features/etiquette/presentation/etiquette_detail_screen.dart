import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_screen_background.dart';
import '../data/etiquette_repository.dart';
import '../data/etiquette_tip.dart';

/// Detail screen for a single fan etiquette tip.
///
/// Shows the tip title and full body text (Vietnamese only for MVP).
class EtiquetteDetailScreen extends ConsumerStatefulWidget {
  const EtiquetteDetailScreen({super.key, required this.tipId});

  final String tipId;

  @override
  ConsumerState<EtiquetteDetailScreen> createState() =>
      _EtiquetteDetailScreenState();
}

class _EtiquetteDetailScreenState
    extends ConsumerState<EtiquetteDetailScreen> {
  Future<EtiquetteTip?>? _tipFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the future so it doesn't re-run on every setState.
    _tipFuture ??=
        ref.read(etiquetteRepositoryProvider).getById(widget.tipId);
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
          title: Text(l10n.etiquette_appBar_title),
        ),
        body: FutureBuilder<EtiquetteTip?>(
          future: _tipFuture,
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
                      l10n.etiquette_error_load,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.etiquette_btn_back),
                    ),
                  ],
                ),
              );
            }

            final tip = snapshot.data;

            if (tip == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      l10n.etiquette_notFound,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.etiquette_btn_back),
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
                    tip.titleVi,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Body text
                  Text(
                    tip.bodyVi,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
