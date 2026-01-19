class Article {
  final String? category;
  final String title;
  final String subtitle;
  final String image;
  final String content;

  const Article({
    this.category,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.content,
  });
}
