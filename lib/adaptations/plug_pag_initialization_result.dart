class PlugPagInitializationResult {
  final String errorCode;
  final String errorMessage;
  final int result;

  PlugPagInitializationResult({
    required this.errorCode,
    required this.errorMessage,
    required this.result,
  });

  static PlugPagInitializationResult fromMethodChannel(
      Map<dynamic, dynamic>? map) {
    return PlugPagInitializationResult(
      errorCode: map!['errorCode'].toString(),
      errorMessage: map['errorMessage'].toString(),
      result: int.parse(map['result'].toString()),
    );
  }
}
