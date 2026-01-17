import 'package:flutter/material.dart';

import 'package:fitness_flutter/features/articles/models/article.dart';
import 'package:fitness_flutter/shared/widgets/app_header.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  int _estimateReadMinutes(String text) {
    // Rough estimate: ~200 words/minute.
    final wordCount = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  List<String> _paragraphs(String text) {
    // Treat blank lines as paragraph separators; within a paragraph, collapse
    // single newlines so the text wraps naturally.
    return text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.replaceAll(RegExp(r'\n+'), '\n').trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  bool _looksLikeListBlock(String paragraph) {
    final lines = paragraph
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.length < 2) return false;
    return lines.any((l) =>
        l.startsWith('- ') ||
        l.startsWith('• ') ||
        RegExp(r'^\d+\)').hasMatch(l) ||
        RegExp(r'^\d+\s*\)').hasMatch(l));
  }

  Widget _bulletLine(BuildContext context, String line) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: 16,
      height: 1.65,
      letterSpacing: 0.15,
      color: theme.colorScheme.onBackground.withOpacity(0.92),
    );

    final cleaned = line
        .replaceFirst(RegExp(r'^-\s+'), '')
        .replaceFirst(RegExp(r'^•\s+'), '')
        .replaceFirst(RegExp(r'^\d+\)\s*'), '')
        .trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SelectableText(
              cleaned,
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = _estimateReadMinutes(article.content);
    final paragraphs = _paragraphs(article.content);

    final chipBg = theme.colorScheme.primary.withOpacity(theme.brightness == Brightness.dark ? 0.18 : 0.12);
    final chipFg = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 260,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                tooltip: 'Back to workouts',
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              // MyFitJourney header badge in action area
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MyFitJourney',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(article.image, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _MetaChip(
                                  label: 'Workout',
                                  icon: Icons.fitness_center,
                                  background: Colors.white.withOpacity(0.18),
                                  foreground: Colors.white,
                                ),
                                _MetaChip(
                                  label: '$minutes min read',
                                  icon: Icons.schedule,
                                  background: Colors.white.withOpacity(0.18),
                                  foreground: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _MetaChip(
                        label: 'Beginner friendly',
                        icon: Icons.check_circle_outline,
                        background: chipBg,
                        foreground: chipFg,
                      ),
                      _MetaChip(
                        label: 'Actionable',
                        icon: Icons.bolt_outlined,
                        background: chipBg,
                        foreground: chipFg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...paragraphs.map((p) {
                    final normalized = p
                        .split('\n')
                        .map((l) => l.trim())
                        .where((l) => l.isNotEmpty)
                        .toList();

                    if (_looksLikeListBlock(p)) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.6),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: normalized
                                .map((line) => _bulletLine(context, line))
                                .toList(),
                          ),
                        ),
                      );
                    }

                    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.75,
                      letterSpacing: 0.15,
                      color: theme.colorScheme.onBackground.withOpacity(0.92),
                    );

                    final merged = normalized.join(' ');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SelectableText(
                        merged,
                        style: bodyStyle,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _MetaChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foreground.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
