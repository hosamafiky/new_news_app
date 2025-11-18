import 'package:dartz/dartz.dart';

import '../../core/networking/api_client.dart';
import '../../core/networking/error_model.dart';

class NewsApiService {
  final ApiClient client;
  static const String apiKey = "adc63e5383ce401084ea5b7a47971dbd";

  const NewsApiService(this.client);

  Future<Either<ErrorModel, Map<String, dynamic>>> getArticles(String path, Map<String, dynamic> params) {
    return client.get(path, {"apiKey": apiKey, ...params});
  }
}
