import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/core/networking/api_client.dart';
import 'package:news_app/data/news/news_repository.dart';
import 'package:news_app/logic/articles_provider.dart';

import '../../data/news/news_api_service.dart';
import '../networking/dio_factory.dart';

final GetIt di = GetIt.instance;

void setupDependencyInjector() {
  di.registerLazySingleton<Dio>(() => DioFactory.create());

  /// Register ArticlesProvider Factory
  di.registerFactory<ArticlesProvider>(() => ArticlesProvider(di()));
  di.registerLazySingleton<NewsRepository>(() => NewsRepository(di()));
  di.registerLazySingleton<NewsApiService>(() => NewsApiService(di()));
  di.registerLazySingleton<ApiClient>(() => ApiClient(di()));
}
