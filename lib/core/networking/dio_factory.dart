import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio create() {
    final dio = Dio(BaseOptions(baseUrl: 'https://newsapi.org/v2', connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

    dio.interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

    return dio;
  }
}
