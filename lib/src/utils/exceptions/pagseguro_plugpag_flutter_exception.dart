class PagseguroPlugpagFlutterException implements Exception {
  static const unknownErrorCode = "unknown_error_code";

  static const _ppfErrorCode = "ppf_error_code";
  static const _ppfErrorMessage = "ppf_error_message";
  static const _ppfErrorDetails = "ppf_error_details";
  static const ppfPlugpagError = "ppf_plugpag_error";

  PagseguroPlugpagFlutterException._({
    required this.message,
    required this.errorCode,
    this.details,
  });

  final String errorCode;
  final String message;
  final dynamic details;

  factory PagseguroPlugpagFlutterException.fromMethodChannel(Map map) {
    return PagseguroPlugpagFlutterException._(
      errorCode: map[_ppfErrorCode],
      message: map[_ppfErrorMessage],
      details: map[_ppfErrorDetails],
    );
  }

  factory PagseguroPlugpagFlutterException.fromException(Object? e) {
    return PagseguroPlugpagFlutterException._(
      errorCode: unknownErrorCode,
      message: e.toString(),
      details: e,
    );
  }

  @override
  String toString() {
    return '''PagseguroPlugpagFlutterException(
  errorCode: $errorCode,
  message: $message,
  details: $details
)''';
  }
}
