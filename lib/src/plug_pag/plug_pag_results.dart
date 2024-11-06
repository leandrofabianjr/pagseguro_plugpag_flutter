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
      cardIssuerNationality: CardIssuerNationality.values.firstWhere(
        (e) => e.name == map['cardIssuerNationality'],
        orElse: () => CardIssuerNationality.UNAVAILABLE,
      ),
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

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'errorCode': errorCode,
      'transactionCode': transactionCode,
      'transactionId': transactionId,
      'date': date,
      'time': time,
      'hostNsu': hostNsu,
      'cardBrand': cardBrand,
      'bin': bin,
      'holder': holder,
      'userReference': userReference,
      'terminalSerialNumber': terminalSerialNumber,
      'amount': amount,
      'availableBalance': availableBalance,
      'cardApplication': cardApplication,
      'label': label,
      'holderName': holderName,
      'extendedHolderName': extendedHolderName,
      'cardIssuerNationality': cardIssuerNationality?.name,
      'result': result,
      'readerModel': readerModel,
      'nsu': nsu,
      'autoCode': autoCode,
      'installments': installments,
      'originalAmount': originalAmount,
      'buyerName': buyerName,
      'paymentType': paymentType,
      'typeTransaction': typeTransaction,
      'appIdentification': appIdentification,
      'cardHash': cardHash,
      'preAutoDueDate': preAutoDueDate,
      'preAutoOriginalAmount': preAutoOriginalAmount,
      'userRegistered': userRegistered,
      'accumulatedValue': accumulatedValue,
      'consumerIdentification': consumerIdentification,
      'currentBalance': currentBalance,
      'consumerPhoneNumber': consumerPhoneNumber,
      'clubePagScreensIds': clubePagScreensIds,
      'partialPayPartiallyAuthorizedAmount':
          partialPayPartiallyAuthorizedAmount,
      'partialPayRemainingAmount': partialPayRemainingAmount,
    };
  }
}

class PlugPagEventData {
  static const ON_EVENT_ERROR = -3;
  static const EVENT_CODE_CUSTOM_MESSAGE = -2;
  static const EVENT_CODE_DEFAULT = -1;
  static const EVENT_CODE_WAITING_CARD = 0;
  static const EVENT_CODE_INSERTED_CARD = 1;
  static const EVENT_CODE_PIN_REQUESTED = 2;
  static const EVENT_CODE_PIN_OK = 3;
  static const EVENT_CODE_SALE_END = 4;
  static const EVENT_CODE_AUTHORIZING = 5;
  @Deprecated('')
  static const EVENT_CODE_INSERTED_KEY = 6;
  static const EVENT_CODE_WAITING_REMOVE_CARD = 7;
  static const EVENT_CODE_REMOVED_CARD = 8;
  static const EVENT_CODE_CVV_REQUESTED = 9;
  static const EVENT_CODE_CVV_OK = 10;
  static const EVENT_CODE_CAR_BIN_REQUESTED = 11;
  static const EVENT_CODE_CAR_BIN_OK = 12;
  static const EVENT_CODE_CAR_HOLDER_REQUESTED = 13;
  static const EVENT_CODE_CAR_HOLDER_OK = 14;
  static const EVENT_CODE_ACTIVATION_SUCCESS = 15;
  static const EVENT_CODE_DIGIT_PASSWORD = 16;
  static const EVENT_CODE_NO_PASSWORD = 17;
  static const EVENT_CODE_SALE_APPROVED = 18;
  static const EVENT_CODE_SALE_NOT_APPROVED = 19;
  static const EVENT_CODE_CONTACTLESS_ERROR = 23;
  static const EVENT_CODE_CONTACTLESS_ON_DEVICE = 24;
  static const EVENT_CODE_USE_TARJA = 25;
  static const EVENT_CODE_USE_CHIP = 26;
  static const EVENT_CODE_DOWNLOADING_TABLES = 27;
  static const EVENT_CODE_RECORDING_TABLES = 28;
  static const EVENT_CODE_SUCCESS = 29;
  static const EVENT_CODE_SOLVE_PENDINGS = 30;
  static const MESSAGES_INITIAL_CAPACITY = 20;

  PlugPagEventData(this.eventCode, this.customMessage);
  final int eventCode;
  final String? customMessage;

  factory PlugPagEventData.fromMethodChannel(
    Map<dynamic, dynamic> map,
  ) {
    return PlugPagEventData(
      map['eventCode'],
      map['customMessage'],
    );
  }
}

class PlugPagAbortResult {
  final int result;
  PlugPagAbortResult({
    required this.result,
  });

  factory PlugPagAbortResult.fromMethodChannel(
    Map<dynamic, dynamic> map,
  ) {
    return PlugPagAbortResult(
      result: map['result'],
    );
  }
}

class PlugPagNFCResult {
  final int startSlot;
  final int endSlot;
  final List<Map<String, List<int>>> slots;
  final int result;
  final String? message;
  final String? errorCode;

  PlugPagNFCResult({
    required this.startSlot,
    required this.endSlot,
    required this.slots,
    required this.result,
    this.message,
    this.errorCode,
  });

  factory PlugPagNFCResult.fromMethodChannel(
    Map<dynamic, dynamic> map,
  ) {
    return PlugPagNFCResult(
      startSlot: map['startSlot'],
      endSlot: map['endSlot'],
      slots: map['slots'],
      result: map['result'],
      message: map['message'],
      errorCode: map['errorCode'],
    );
  }
}

class PlugPagNFCInfosResultDirectly {
  final int result;
  final int? cardType;
  final int? cid;
  final List<int>? other;
  final List<int>? serialNumber;

  PlugPagNFCInfosResultDirectly({
    required this.result,
    this.cardType,
    this.cid,
    this.other,
    this.serialNumber,
  });

  factory PlugPagNFCInfosResultDirectly.fromMethodChannel(
    Map<dynamic, dynamic> map,
  ) {
    return PlugPagNFCInfosResultDirectly(
      result: map['result'],
      cardType: map['cardType'],
      cid: map['cid'],
      other: map['other']?.cast<int>(),
      serialNumber: map['serialNumber']?.cast<int>(),
    );
  }

  String? get serialNumberAsHexString {
    return serialNumber?.map((byte) => byte.toUnsignedHexString()).join('');
  }
}

extension on int {
  toUnsignedHexString() {
    // convert signed integer to unsigned hex
    return (this & 0xFF).toUnsigned(8).toRadixString(16).padLeft(2, '0');
  }
}
