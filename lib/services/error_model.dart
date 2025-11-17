class ErrorModel {
  final String status, code, message;

  const ErrorModel({required this.status, required this.code, required this.message});

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(status: map['status']?.toString() ?? '', code: map['code']?.toString() ?? '', message: map['message']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'code': code, 'message': message};
  }

  @override
  String toString() {
    return 'ErrorModel(status: $status, code: $code, message: $message)';
  }
}
