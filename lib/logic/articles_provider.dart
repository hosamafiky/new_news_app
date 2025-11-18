import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/data/news/news_repository.dart';
import 'package:news_app/logic/filter_provider.dart';

import '../core/networking/error_model.dart';

class ArticlesProvider extends ChangeNotifier {
  final NewsRepository repo;

  ArticlesProvider(this.repo);

  Either<ErrorModel, List<Article>>? _result = Right([]);
  Either<ErrorModel, List<Article>>? get result => _result;

  int get articlesCount => result?.fold((l) => 0, (r) => r.length) ?? 0;

  void listenToFilterOptions(FilterProvider filterProvider, String path, Map<String, dynamic> initialParams) {
    filterProvider.addListener(() => loadArticles(path, initialParams));
    loadArticles(path, initialParams);
  }

  Future<void> loadArticles(String path, Map<String, dynamic> params) async {
    _result = await repo.fetchArticles(path, params);
    notifyListeners();
  }
}
