import 'package:flutter/material.dart';

import '../../data/vocabulary_item.dart';

/// A vocabulary term tile with collapsed and expanded states.
///
/// Collapsed: shows VN term (bold) and EN term (subtitle).
/// Expanded: shows full VN+EN definition, VN+EN example, related-term chips.
///
/// The expanded state is controlled externally via [expanded] and [onToggle]
/// so the parent screen can force-expand a term when navigating via related chips.
class VocabularyTile extends StatelessWidget {
  const VocabularyTile({
    super.key,
    required this.item,
    required this.expanded,
    required this.onToggle,
    this.onRelatedTap,
  });

  final VocabularyItem item;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(String relatedId)? onRelatedTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark
        ? const Color(0x991E293B) // Slate-800 with 60% opacity
        : const Color(0xD9FFFFFF); // White with 85% opacity
    final cardBorderColor = isDark
        ? const Color(0x3310B981)
        : Colors.white.withValues(alpha: 0.9);
    final double borderWidth = isDark ? 1.0 : 1.5;
    final activeColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0x0A059669).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onToggle,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsed header: VN term + EN term
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.termVi,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: expanded ? activeColor : null),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.termEn,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  // Expanded content
                  if (expanded) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, color: isDark ? const Color(0x1F94A3B8) : const Color(0x1F64748B)),
                    const SizedBox(height: 12),
                    // VN definition
                    Text(
                      item.definitionVi,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    // EN definition
                    Text(
                      item.definitionEn,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                    ),
                    if (item.exampleVi.isNotEmpty || item.exampleEn.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      // Example Card Box
                      Stack(
                        children: [
                          Positioned(
                            right: -10,
                            top: -10,
                            child: Icon(
                              Icons.format_quote,
                              size: 64,
                              color: activeColor.withValues(alpha: 0.08),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  isDark ? const Color(0x1F10B981) : const Color(0x15059669),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: activeColor.withValues(alpha: 0.25),
                                width: 0.8,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.format_quote, size: 16, color: activeColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ví dụ / Examples',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: activeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (item.exampleVi.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32),
                                    child: Text(
                                      '"${item.exampleVi}"',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                if (item.exampleEn.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32),
                                    child: Text(
                                      '"${item.exampleEn}"',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Related term chips
                    if (item.related.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: item.related.map((relatedId) {
                          return GestureDetector(
                            onTap: onRelatedTap != null
                                ? () => onRelatedTap!(relatedId)
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0x1F10B981) : const Color(0x15059669),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: activeColor.withValues(alpha: 0.2),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                relatedId,
                                style: TextStyle(
                                  color: activeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
