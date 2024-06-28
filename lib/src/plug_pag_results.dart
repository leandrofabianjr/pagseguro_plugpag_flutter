class PlugPagInitializationResult {
  final String errorCode, errorMessage;
  final int result;

  PlugPagInitializationResult._(this.errorCode, this.errorMessage, this.result);

  factory PlugPagInitializationResult.fromMethodChannel(
    Map<dynamic, dynamic>? map,
  ) {
    return PlugPagInitializationResult._(
      map!['errorCode'].toString(),
      map['errorMessage'].toString(),
      int.parse(map['result'].toString()),
    );
  }
}

class PlugPagInstallment {
  final int quantity, amount, total;

  PlugPagInstallment._(
    this.quantity,
    this.amount,
    this.total,
  );

  get amountDouble => amount / 100.0;
  get totalDouble => total / 100.0;

  factory PlugPagInstallment.fromMethodChannel(
    Map<dynamic, dynamic>? map,
  ) {
    return PlugPagInstallment._(
      int.parse(map!['quantity'].toString()),
      int.parse(map['amount'].toString()),
      int.parse(map['total'].toString()),
    );
  }
}

class PlugPagPrintResult {
  final String errorCode, message;
  final int result, steps;

  PlugPagPrintResult._(this.errorCode, this.message, this.result, this.steps);

  factory PlugPagPrintResult.fromMethodChannel(
    Map<dynamic, dynamic>? map,
  ) {
    return PlugPagPrintResult._(
      map!['errorCode'].toString(),
      map['message'].toString(),
      int.parse(map['result'].toString()),
      int.parse(map['steps'].toString()),
    );
  }
}
