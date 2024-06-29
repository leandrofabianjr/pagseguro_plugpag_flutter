// ignore_for_file: constant_identifier_names

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

enum CardIssuerNationality {
  UNAVAILABLE,
  NATIONAL,
  INTERNATIONAL,
}

class PlugPagTransactionResult {
  final String? message;
  final String? errorCode;
  final String? transactionCode;
  final String? transactionId;
  final String? date;
  final String? time;
  final String? hostNsu;
  final String? cardBrand;
  final String? bin;
  final String? holder;
  final String? userReference;
  final String? terminalSerialNumber;
  final String? amount;
  final String? availableBalance;
  final String? cardApplication;
  final String? label;
  final String? holderName;
  final String? extendedHolderName;
  final CardIssuerNationality? cardIssuerNationality;
  final int? result;
  final String? readerModel;
  final String? nsu;
  final String? autoCode;
  final int? installments;
  final int? originalAmount;
  final String? buyerName;
  final int? paymentType;
  final String? typeTransaction;
  final String? appIdentification;
  final String? cardHash;
  final String? preAutoDueDate;
  final String? preAutoOriginalAmount;
  final int userRegistered;
  final String? accumulatedValue;
  final String? consumerIdentification;
  final String? currentBalance;
  final String? consumerPhoneNumber;
  final String? clubePagScreensIds;
  final String? partialPayPartiallyAuthorizedAmount;
  final String? partialPayRemainingAmount;

  PlugPagTransactionResult._({
    this.message,
    this.errorCode,
    this.transactionCode,
    this.transactionId,
    this.date,
    this.time,
    this.hostNsu,
    this.cardBrand,
    this.bin,
    this.holder,
    this.userReference,
    this.terminalSerialNumber,
    this.amount,
    this.availableBalance,
    this.cardApplication,
    this.label,
    this.holderName,
    this.extendedHolderName,
    this.cardIssuerNationality,
    this.result,
    this.readerModel,
    this.nsu,
    this.autoCode,
    this.installments,
    this.originalAmount,
    this.buyerName,
    this.paymentType,
    this.typeTransaction,
    this.appIdentification,
    this.cardHash,
    this.preAutoDueDate,
    this.preAutoOriginalAmount,
    required this.userRegistered,
    this.accumulatedValue,
    this.consumerIdentification,
    this.currentBalance,
    this.consumerPhoneNumber,
    this.clubePagScreensIds,
    this.partialPayPartiallyAuthorizedAmount,
    this.partialPayRemainingAmount,
  });

  factory PlugPagTransactionResult.fromMethodChannel(
    Map<dynamic, dynamic>? map,
  ) {
    return PlugPagTransactionResult._(
      message: map!['message'].toString(),
      errorCode: map['errorCode'].toString(),
      transactionCode: map['transactionCode'].toString(),
      transactionId: map['transactionId'].toString(),
      date: map['date'].toString(),
      time: map['time'].toString(),
      hostNsu: map['hostNsu'].toString(),
      cardBrand: map['cardBrand'].toString(),
      bin: map['bin'].toString(),
      holder: map['holder'].toString(),
      userReference: map['userReference'].toString(),
      terminalSerialNumber: map['terminalSerialNumber'].toString(),
      amount: map['amount'].toString(),
      availableBalance: map['availableBalance'].toString(),
      cardApplication: map['cardApplication'].toString(),
      label: map['label'].toString(),
      holderName: map['holderName'].toString(),
      extendedHolderName: map['extendedHolderName'].toString(),
      cardIssuerNationality: CardIssuerNationality.values
          .firstWhere((e) => e.name == map['cardIssuerNationality']),
      result: map['result'],
      readerModel: map['readerModel'].toString(),
      nsu: map['nsu'].toString(),
      autoCode: map['autoCode'].toString(),
      installments: map['installments'],
      originalAmount: map['originalAmount'],
      buyerName: map['buyerName'].toString(),
      paymentType: map['paymentType'],
      typeTransaction: map['typeTransaction'].toString(),
      appIdentification: map['appIdentification'].toString(),
      cardHash: map['cardHash'].toString(),
      preAutoDueDate: map['preAutoDueDate'].toString(),
      preAutoOriginalAmount: map['preAutoOriginalAmount'].toString(),
      userRegistered: map['userRegistered'],
      accumulatedValue: map['accumulatedValue'].toString(),
      consumerIdentification: map['consumerIdentification'].toString(),
      currentBalance: map['currentBalance'].toString(),
      consumerPhoneNumber: map['consumerPhoneNumber'].toString(),
      clubePagScreensIds: map['clubePagScreensIds'].toString(),
      partialPayPartiallyAuthorizedAmount:
          map['partialPayPartiallyAuthorizedAmount'].toString(),
      partialPayRemainingAmount: map['partialPayRemainingAmount'].toString(),
    );
  }
}
