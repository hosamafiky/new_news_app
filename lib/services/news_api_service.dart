import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:news_app/services/error_model.dart';
import 'package:news_app/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'adc63e5383ce401084ea5b7a47971dbd'; // Replace with your API key

  final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl, queryParameters: {'apiKey': _apiKey}))
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

  // Get everything endpoint
  Future<Either<ErrorModel, NewsResponse>> getEverything({
    String? query,
    String? searchIn,
    String? sources,
    String? domains,
    String? from,
    String? to,
    String? language,
    String sortBy = 'publishedAt',
    int pageSize = 20,
    int page = 1,
  }) async {
    final Map<String, String> queryParams = {'sortBy': sortBy, 'pageSize': pageSize.toString(), 'page': page.toString()};

    queryParams['q'] = query ?? 'currency'; // Default query if none provided
    if (searchIn != null) queryParams['searchIn'] = searchIn;
    if (sources != null) queryParams['sources'] = sources;
    if (domains != null) queryParams['domains'] = domains;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (language != null) queryParams['language'] = language;

    final response = await _dio.get(
      '/everything',
      queryParameters: _dio.options.queryParameters
        ..addAll(queryParams)
        ..remove('country'),
    );

    if (response.statusCode == 200) {
      return Right(NewsResponse.fromMap(response.data));
    } else {
      final errorData = response.data;
      final model = ErrorModel.fromMap(errorData);
      return Left(model);
    }
  }

  // Get top headlines endpoint
  Future<Either<ErrorModel, NewsResponse>> getTopHeadlines({
    Country? country,
    Category? category,
    String? sources,
    String? query,
    int pageSize = 20,
    int page = 1,
  }) async {
    final Map<String, String> queryParams = {'apiKey': _apiKey, 'pageSize': pageSize.toString(), 'page': page.toString()};

    if (country != null) queryParams['country'] = country.code;
    if (category != null) queryParams['category'] = category.name;
    if (sources != null) queryParams['sources'] = sources;
    if (query != null && query.isNotEmpty) queryParams['q'] = query;

    final response = await _dio.get(
      '/top-headlines',
      queryParameters: _dio.options.queryParameters
        ..addAll(queryParams)
        ..remove('q')
        ..remove('from')
        ..remove('to')
        ..remove('country'),
    );

    if (response.statusCode == 200) {
      return Right(NewsResponse.fromMap(response.data));
    } else {
      final errorData = response.data;
      final model = ErrorModel.fromMap(errorData);
      return Left(model);
    }
  }

  // Get sources endpoint
  Future<Either<ErrorModel, List<Source>>> getSources({String? category, String? language, String? country}) async {
    final Map<String, String> queryParams = {'apiKey': _apiKey};

    if (category != null) queryParams['category'] = category;
    if (language != null) queryParams['language'] = language;
    if (country != null) queryParams['country'] = country;

    final response = await _dio.get('/sources', queryParameters: _dio.options.queryParameters..addAll(queryParams));

    if (response.statusCode == 200) {
      final data = response.data;
      return Right((data['sources'] as List).map((source) => Source.fromMap(source)).toList());
    } else {
      final errorData = response.data;
      final model = ErrorModel.fromMap(errorData);
      return Left(model);
    }
  }
}
