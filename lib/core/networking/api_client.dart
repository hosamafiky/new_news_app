import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'error_model.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Either<ErrorModel, Map<String, dynamic>>> get(String path, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(path, queryParameters: params);
      return Right(response.data);
    } on DioException catch (e) {
      try {
        return Left(ErrorModel.fromDio(e));
      } catch (e) {
        return Left(ErrorModel(status: 'error', code: 'DIO_ERROR', message: e.toString()));
      }
    } catch (e) {
      return Left(ErrorModel(status: 'error', code: 'UNKNOWN_ERROR', message: e.toString()));
    }
  }
}
