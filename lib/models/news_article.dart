class NewsArticle {
  final String title;
  final String description;
  final String? imageUrl;
  final String link;
  final String pubDate;
  final String category;

  NewsArticle({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.link,
    required this.pubDate,
    required this.category,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      link: json['link'] ?? '',
      pubDate: json['pubDate'] ?? '',
      category: json['category']?.first ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'link': link,
      'pubDate': pubDate,
      'category': category,
    };
  }
}
