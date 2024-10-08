// ignore_for_file: constant_identifier_names

import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

import '../utils/interfaces/plug_pag_data_class.dart';

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

enum PlugPagPaymentDataType {
  credito,
  debito,
  voucher,
  qrCode,
  pix,
  preautoCard,
  qrcodeCredito,
  preautoKeyed,
}

extension on PlugPagPaymentDataType {
  int get plugPagValue => switch (this) {
        PlugPagPaymentDataType.credito => PlugPag.TYPE_CREDITO,
        PlugPagPaymentDataType.debito => PlugPag.TYPE_DEBITO,
        PlugPagPaymentDataType.voucher => PlugPag.TYPE_VOUCHER,
        PlugPagPaymentDataType.qrCode => PlugPag.TYPE_QRCODE,
        PlugPagPaymentDataType.pix => PlugPag.TYPE_PIX,
        PlugPagPaymentDataType.preautoCard => PlugPag.TYPE_PREAUTO_CARD,
        PlugPagPaymentDataType.qrcodeCredito => PlugPag.TYPE_QRCODE_CREDITO,
        PlugPagPaymentDataType.preautoKeyed => PlugPag.TYPE_PREAUTO_KEYED,
      };
}

enum PlugPagPaymentDataInstallmentType {
  aVista,
  parcVendedor,
  parcComprador,
}

extension PlugPagPaymentDataInstallmentTypeExtension
    on PlugPagPaymentDataInstallmentType {
  int get plugPagValue => switch (this) {
        PlugPagPaymentDataInstallmentType.aVista =>
          PlugPag.INSTALLMENT_TYPE_A_VISTA,
        PlugPagPaymentDataInstallmentType.parcVendedor =>
          PlugPag.INSTALLMENT_TYPE_PARC_VENDEDOR,
        PlugPagPaymentDataInstallmentType.parcComprador =>
          PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR,
      };
}

class PlugPagPaymentData extends PlugPagDataClass {
  static const serialVersionUID = -1;

  final PlugPagPaymentDataType type;
  final int amount;
  final PlugPagPaymentDataInstallmentType installmentType;
  final String? userReference;
  final int installments;
  final bool printReceipt;
  final bool partialPay;
  final bool isCarne;

  PlugPagPaymentData({
    required this.type,
    required this.amount,
    required this.installmentType,
    required String userReference,
    this.installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY,
    this.printReceipt = false,
    this.partialPay = false,
    this.isCarne = false,
  }) : userReference = userReference.substring(
            0, userReference.length < 10 ? userReference.length : 10);

  factory PlugPagPaymentData.fromDoubleAmount({
    required PlugPagPaymentDataType type,
    required double amount,
    required PlugPagPaymentDataInstallmentType installmentType,
    required String userReference,
    int installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY,
    bool printReceipt = false,
    bool partialPay = false,
    bool isCarne = false,
  }) {
    final strAmount = amount.toStringAsFixed(2).replaceAll(RegExp(r'\D'), '');
    return PlugPagPaymentData(
      type: type,
      amount: int.parse(strAmount),
      installmentType: installmentType,
      userReference: userReference,
      installments: installments,
      printReceipt: printReceipt,
      partialPay: partialPay,
      isCarne: isCarne,
    );
  }

  @override
  String get className => 'PlugPagPaymentData';
  @override
  List get params => [
        type.plugPagValue,
        amount,
        installmentType.plugPagValue,
        installments,
        userReference,
        printReceipt,
        partialPay,
        isCarne,
      ];
}

class PlugPagVoidData extends PlugPagDataClass {
  PlugPagVoidData(
    this.transactionCode,
    this.transactionId, [
    this.printReceipt = false,
    this.voidType = PlugPag.VOID_PAYMENT,
  ]);

  final String transactionCode;
  final String transactionId;
  final bool printReceipt;
  final int voidType;

  @override
  String get className => 'PlugPagVoidData';
  @override
  List get params => [
        transactionCode,
        transactionId,
        printReceipt,
        voidType,
      ];
}

class PlugPagNearFieldCardData extends PlugPagDataClass {
  static const int EMV_AB = 1;
  static const int ISO14443_AB = 0;
  static const String NFC_DATA = 'data';
  static const int NFC_FINAL_SLOT = 63;
  static const String NFC_PWD = 'pwd';
  static const int ONLY_A = 2;
  static const int ONLY_B = 3;
  static const int ONLY_M = 4;
  static const int SLOTS_SIZE = 64;
  static const int TIMEOUT_LIMIT_IN_SECONDS = 10;
  static const int serialVersionUID = 1;

  int endSlot;
  List<Map<String, int>> slots;
  int startSlot;
  int timeOutRead;
  int typeCard;

  PlugPagNearFieldCardData({
    required this.endSlot,
    required this.slots,
    required this.startSlot,
    required this.timeOutRead,
    required this.typeCard,
  });

  @override
  String get className => 'PlugPagNearFieldCardData';
  @override
  List get params => [
        endSlot,
        slots,
        startSlot,
        timeOutRead,
        typeCard,
      ];
}
