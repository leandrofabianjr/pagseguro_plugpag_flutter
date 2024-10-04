class PlugPagException implements Exception {
  final String errorCode;
  final String message;
  final dynamic cause;

  PlugPagException({
    required this.errorCode,
    required this.message,
    this.cause,
  });

  factory PlugPagException.fromMethodChannel(Map map) {
    return PlugPagException(
      errorCode: map['errorCode'],
      message: map['message'],
      cause: map['cause'],
    );
  }

  @override
  String toString() {
    return '$message ($errorCode)';
  }
}
