// ignore_for_file: constant_identifier_names

import 'utils/interfaces/plug_pag_data_class.dart';

class PlugPagActivationData extends PlugPagDataClass {
  final String activationCode;
  PlugPagActivationData(this.activationCode);
  @override
  String get className => 'PlugPagActivationData';
  @override
  List get params => [activationCode];
}

class PlugPagPrinterData extends PlugPagDataClass {
  final String filePath;
  final int printerQuality, steps;
  PlugPagPrinterData(this.filePath, this.printerQuality, this.steps);
  @override
  String get className => 'PlugPagPrinterData';
  @override
  List get params => [filePath, printerQuality, steps];
}

class PlugPagCustomPrinterLayout extends PlugPagDataClass {
  String? title,
      titleColor,
      confirmTextColor,
      cancelTextColor,
      windowBackgroundColor,
      buttonBackgroundColor,
      buttonBackgroundColorDisabled,
      sendSMSTextColor;
  int? maxTimeShowPopup;
  PlugPagCustomPrinterLayout(
    this.title,
    this.titleColor,
    this.confirmTextColor,
    this.cancelTextColor,
    this.windowBackgroundColor,
    this.buttonBackgroundColor,
    this.buttonBackgroundColorDisabled,
    this.sendSMSTextColor,
    this.maxTimeShowPopup,
  );

  @override
  String get className => 'PlugPagCustomPrinterLayout';
  @override
  List get params => [
        title,
        titleColor,
        confirmTextColor,
        cancelTextColor,
        windowBackgroundColor,
        buttonBackgroundColor,
        buttonBackgroundColorDisabled,
        sendSMSTextColor,
        maxTimeShowPopup,
      ];
}

class PlugPagEventData extends PlugPagDataClass {
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

  @override
  String get className => 'PlugPagEventData';
  @override
  List get params => [eventCode, customMessage];
}

class PlugPagPaymentData extends PlugPagDataClass {
  static const serialVersionUID = -1;

  final int type;
  final int amount;
  final int installmentType;
  final int installments;
  final String? userReference;
  final bool printReceipt;
  final bool partialPay;
  final bool isCarne;

  PlugPagPaymentData({
    required this.type,
    required this.amount,
    required this.installmentType,
    required this.installments,
    this.userReference,
    this.printReceipt = false,
    this.partialPay = false,
    this.isCarne = false,
  });

  @override
  String get className => 'PlugPagPaymentData';
  @override
  List get params => [
        type,
        amount,
        installmentType,
        installments,
        userReference,
        printReceipt,
        partialPay,
        isCarne,
      ];
}
