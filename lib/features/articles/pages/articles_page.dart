import 'package:flutter/material.dart';

import 'package:fitness_flutter/features/articles/models/article.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ArticlesPage extends StatefulWidget {
  final List<Article> articles;

  const ArticlesPage({super.key, required this.articles});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  String _query = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Keep a tiny loading phase to show a modern skeleton UI.
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = widget.articles.where((a) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return a.title.toLowerCase().contains(q) ||
          a.subtitle.toLowerCase().contains(q) ||
          (a.category ?? '').toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Fitness Tips & Articles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search articles…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? _shimmerList(theme)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = filtered[index];

                      return InkWell(
                        onTap: () => context.push('/articles/$index'),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  article.image,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 12, 12, 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if ((article.category ?? '').isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(
                                              theme.brightness == Brightness.dark
                                                  ? 0.18
                                                  : 0.12,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            article.category!,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article.title,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        article.subtitle,
                                        style: theme.textTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerList(ThemeData theme) {
    final baseColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);
    final highlightColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.16)
        : Colors.black.withOpacity(0.03);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            height: 110,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
