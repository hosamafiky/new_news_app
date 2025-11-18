import 'package:news_app/data/models/source.dart';

class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: Source.fromMap(map['source']),
      author: map['author'],
      title: map['title'] ?? '',
      description: map['description'],
      url: map['url'] ?? '',
      urlToImage: map['urlToImage'],
      publishedAt: DateTime.parse(map['publishedAt']),
      content: map['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
    };
  }
}

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({required this.status, required this.totalResults, required this.articles});

  factory NewsResponse.fromMap(Map<String, dynamic> map) {
    return NewsResponse(
      status: map['status'],
      totalResults: map['totalResults'] ?? 0,
      articles: (map['articles'] as List).map((article) => Article.fromMap(article)).toList(),
    );
  }
}
