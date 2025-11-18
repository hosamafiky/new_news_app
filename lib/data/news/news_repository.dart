import 'package:dartz/dartz.dart';
import 'package:news_app/data/models/article.dart';

import '../../core/networking/error_model.dart';
import 'news_api_service.dart';

class NewsRepository {
  final NewsApiService service;

  NewsRepository(this.service);

  Future<Either<ErrorModel, List<Article>>> fetchArticles(String path, Map<String, dynamic> params) async {
    final result = await service.getArticles(path, params);

    return result.map((json) => (json['articles'] as List).map((e) => Article.fromMap(e)).toList());
  }
}
