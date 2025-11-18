import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/data/news/news_repository.dart';
import 'package:news_app/logic/filter_provider.dart';
import 'package:news_app/logic/tab_index_provider.dart';

import '../core/networking/error_model.dart';

class ArticlesProvider extends ChangeNotifier {
  final NewsRepository repo;
  final String articlesPath;

  ArticlesProvider(this.repo, {required this.articlesPath});

  Either<ErrorModel, List<Article>>? _result = Right([]);
  Either<ErrorModel, List<Article>>? get result => _result;

  int get articlesCount => result?.fold((l) => 0, (r) => r.length) ?? 0;

  Future<void> loadArticles(Map<String, dynamic> params) async {
    _result = await repo.fetchArticles(articlesPath, params);
    notifyListeners();
  }
}

class EverythingProvider extends ArticlesProvider {
  EverythingProvider(super.repo) : super(articlesPath: "/everything");

  void listenToFilterOptions(TabIndexProvider tabIndexProvider, FilterProvider filterProvider) {
    filterProvider.addListener(() => loadArticles(filterProvider.currentEveryThingFilters));
    loadArticles(filterProvider.currentEveryThingFilters);
  }
}

class TopHeadlinesProvider extends ArticlesProvider {
  TopHeadlinesProvider(super.repo) : super(articlesPath: "/top-headlines");

  void listenToFilterOptions(TabIndexProvider tabIndexProvider, FilterProvider filterProvider) {
    filterProvider.addListener(() => loadArticles(filterProvider.currentTopHeadlinesFilters));
    loadArticles(filterProvider.currentTopHeadlinesFilters);
  }
}
