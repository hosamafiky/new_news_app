class ErrorModel {
  final String status, code, message;

  const ErrorModel({required this.status, required this.code, required this.message});

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(status: map['status']?.toString() ?? '', code: map['code']?.toString() ?? '', message: map['message']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'code': code, 'message': message};
  }

  factory ErrorModel.fromDio(dynamic dioError) {
    if (dioError.response != null && dioError.response?.data != null) {
      return ErrorModel.fromMap(dioError.response!.data);
    } else {
      return ErrorModel(status: 'error', code: 'DIO_ERROR', message: dioError.message ?? 'Unknown Dio error');
    }
  }

  @override
  String toString() {
    return 'ErrorModel(status: $status, code: $code, message: $message)';
  }
}
