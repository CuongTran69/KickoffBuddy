import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/vocabulary_search_controller.dart';

/// Search bar for the vocabulary screen.
///
/// Calls [vocabularySearchControllerProvider.notifier.setQuery] on change.
/// Shows a clear button when the query is non-empty.
class VocabularySearchBar extends ConsumerStatefulWidget {
  const VocabularySearchBar({
    super.key,
    this.controller,
  });

  /// Optional external controller for programmatic clearing.
  final TextEditingController? controller;

  @override
  ConsumerState<VocabularySearchBar> createState() =>
      _VocabularySearchBarState();
}

class _VocabularySearchBarState extends ConsumerState<VocabularySearchBar> {
  late final TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(() {
      final hasText = _ctrl.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    // Only dispose if we created the controller ourselves.
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final searchBgColor = isDark
        ? const Color(0x991E293B)
        : Colors.white.withValues(alpha: 0.75);
    final borderColor = isDark
        ? const Color(0x3310B981)
        : Colors.white.withValues(alpha: 0.9);

    return Container(
      decoration: BoxDecoration(
        color: searchBgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: isDark ? 1.0 : 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : const Color(0x0A059669).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _ctrl,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: l10n.vocabulary_search_hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(Icons.search, color: activeColor, size: 20),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.clear, color: theme.colorScheme.onSurfaceVariant, size: 18),
                  tooltip: 'Clear search',
                  onPressed: () {
                    _ctrl.clear();
                    ref
                        .read(vocabularySearchControllerProvider.notifier)
                        .setQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          ref
              .read(vocabularySearchControllerProvider.notifier)
              .setQuery(value);
        },
      ),
    );
  }
}

