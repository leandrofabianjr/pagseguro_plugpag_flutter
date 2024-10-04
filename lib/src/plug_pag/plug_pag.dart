// ignore_for_file: constant_identifier_names

import 'plug_pag_methods.dart';

export 'plug_pag.dart';
export 'plug_pag_datas.dart';
export 'plug_pag_exception.dart';
export 'plug_pag_listeners.dart';
export 'plug_pag_results.dart';

class PlugPag with PlugPagMethods {
  static const int TYPE_CREDITO = 1;
  static const int TYPE_DEBITO = 2;
  static const int TYPE_VOUCHER = 3;
  static const int TYPE_QRCODE = 4;
  static const int TYPE_PIX = 5;
  static const int TYPE_PREAUTO_CARD = 6;
  static const int TYPE_QRCODE_CREDITO = 7;
  static const int TYPE_PREAUTO_KEYED = 8;
  static const int MODE_PARTIAL_PAY = 1001;
  static const int INSTALLMENT_TYPE_A_VISTA = 1;
  static const int A_VISTA_INSTALLMENT_QUANTITY = 1;
  static const int INSTALLMENT_TYPE_PARC_VENDEDOR = 2;
  static const int INSTALLMENT_TYPE_PARC_COMPRADOR = 3;
  static const int RET_OK = 0;
  static const int NFC_RET_OK = 1;
  static const int NFC_RET_ERROR = -1;
  static const int BUFFER_SIZE_ERROR = -1001;
  static const int NULL_APPLICATION_PARAMETER = -1002;
  static const int POS_NOT_READY = -1003;
  static const int TRANSACTION_DENIED = -1004;
  static const int INVALID_BUFFER_DATA = -1005;
  static const int NULL_AMOUNT = -1006;
  static const int NULL_TOTAL_AMOUNT = -1007;
  static const int NULL_USER_REFERENCE = -1008;
  static const int NULL_TRANSACTION_RESULT = -1009;
  static const int DRIVER_NOT_FOUND = -1010;
  static const int DRIVER_FUNCTION_ERROR = -1011;
  static const int INVALID_AMOUNT_FORMAT = -1012;
  static const int INVALID_LENGTH_USER_REFERENCE = -1013;
  static const int INVALID_BUFFER = -1014;
  static const int INVALID_APP_NAME = -1015;
  static const int INVALID_APP_VERSION = -1016;
  static const int APP_NAME_VERSION_NOT_SET = -1017;
  static const int NO_TRANSACTION_DATA = -1018;
  static const int COMMUNICATION_ERROR = -1019;
  static const int SHARE_MODE_NOT_ALLOWED = -1020;
  static const int APPLICATION_NOT_SUPPORTED = -1021;
  static const int INVALID_CARD = -1022;
  static const int PSC_INIT_ERROR = -1023;
  static const int TABLE_LOAD_FAILED = -1024;
  static const int PINPAD_ERROR = -1025;
  static const int INVALID_TRANSACTION_TYPE = -1026;
  static const int INVALID_PARAMETER = -1027;
  static const int OPERATION_ABORTED = -1028;
  static const int INVALID_INSTALLMENT_TYPE = -1029;
  static const int MISSING_TOKEN = -1030;
  static const int INVALID_AMOUNT = -1031;
  static const int INVALID_INSTALLMENT = -1032;
  static const int AUTHENTICATION_FAILED = -1033;
  static const int MISSING_COEFFICIENTS = -1034;
  static const int INVALID_DEVICE_IDENTIFICATION = -1035;
  static const int PINPAD_NOT_INITIALIZED = -1036;
  static const int INVALID_READER = -1037;
  static const int INSTALLMENT_ERROR = -1039;
  static const int NO_PRINTER_DEVICE = -1040;
  static const int HOST_ERROR = -1041;
  static const int CRYPTO_INIT_ERROR = -4046;
  static const int DOING_TRANSACTION = -1047;
  static const int QR_CODE_EXPIRED = -1048;
  static const int DISABLED_FUNCTION = -1049;
  static const int MISSING_PREAUTO_CACHE = -1050;
  static const int REFUND_NOT_ALLOWED = -1051;
  static const int VOID_PAYMENT = 1;
  static const int VOID_QRCODE = 2;
  static const String ERROR_CODE_OK = "0000";
  static const String UNKNOWN_ERROR_MESSAGE = "Erro desconhecido";
  static const String PLUGPAG_UNKNOWN_ERROR_CODE = "PP9999";
  static const int UNKNOWN_ERROR_CODE = -9999;
  static const int MIN_PRINTER_STEPS = 70;
  static const int PLUGPAG_PRE_PRINTING = 0;
  static const int PLUGPAG_ASYNC_CONFIRMATION = 1;
  static const int PLUGPAG_ASYNC_METRICS = 2;
  static const int PLUGPAG_CDCVM = 3;
  static const int PLUGPAG_CRASHLOG_SENDING = 4;
  static const int PLUGPAG_GMT_OFFSET = 5;
}
