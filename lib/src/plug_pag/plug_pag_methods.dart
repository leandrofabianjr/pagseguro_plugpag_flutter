import 'package:pagseguro_plugpag_flutter/src/utils/interfaces/plug_pag_listener_class.dart';

import '../pagseguro_plugpag_flutter_platform_interface.dart';
import 'plug_pag_datas.dart';
import 'plug_pag_listeners.dart';
import 'plug_pag_results.dart';

mixin PlugPagMethods {
  void onException(Function(Object ex)? cathError) {
    PagseguroPlugpagFlutterPlatform.instance.onException(cathError);
  }

  void removeListener(PlugPagListenerClass listener) {
    PagseguroPlugpagFlutterPlatform.instance.removeListener(listener);
  }

  Future<bool> isAuthenticated() async {
    final res = await PagseguroPlugpagFlutterPlatform.instance
        .invokePlugPagMethod('isAuthenticated');
    return res == true;
  }

  Future<PlugPagInitializationResult> initializeAndActivatePinpad(
    PlugPagActivationData data,
  ) async {
    final res =
        await PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
      'initializeAndActivatePinpad',
      [data],
    );
    return PlugPagInitializationResult.fromMethodChannel(res['ppf_args']);
  }

  Future<PlugPagInitializationResult> deactivate(
    PlugPagActivationData data,
  ) async {
    final res =
        await PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
      'deactivate',
      [data],
    );
    return PlugPagInitializationResult.fromMethodChannel(res['ppf_args']);
  }

  Future<List<PlugPagInstallment>> calculateInstallments(
    String saleValue,
    PlugPagPaymentDataInstallmentType installmentType,
  ) async {
    final res =
        await PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
      'calculateInstallments',
      [saleValue, installmentType.plugPagValue],
    );
    return (res as List)
        .map((i) => PlugPagInstallment.fromMethodChannel(i['ppf_args']))
        .toList();
  }

  Future<List<PlugPagInstallment>> calculateInstallmentsFromDouble(
    double saleValue,
    PlugPagPaymentDataInstallmentType installmentType,
  ) async {
    final stringSaleValue =
        saleValue.toStringAsFixed(2).replaceAll(RegExp('[^0-9]'), '');
    return calculateInstallments(stringSaleValue, installmentType);
  }

  Future<PlugPagPrintResult> printFromFile(
      PlugPagPrinterData printerData) async {
    final res = await PagseguroPlugpagFlutterPlatform.instance
        .invokePlugPagMethod('printFromFile', [printerData]);
    return PlugPagPrintResult.fromMethodChannel(res['ppf_args']);
  }

  void asyncCalculateInstallments(
    String saleValue,
    PlugPagInstallmentsListener listener,
  ) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'asyncCalculateInstallments',
        [saleValue, listener],
      );

  void setEventListener(PlugPagEventListener listener) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'setEventListener',
        [listener],
      );

  void setPrinterListener(PlugPagPrinterListener listener) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'setPrinterListener',
        [listener],
      );

  void setPlugPagCustomPrinterLayout(
          PlugPagCustomPrinterLayout plugPagCustomPrinterLayout) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'setPlugPagCustomPrinterLayout',
        [plugPagCustomPrinterLayout],
      );

  Future<PlugPagTransactionResult> doPayment(
      PlugPagPaymentData paymentData) async {
    final res = await PagseguroPlugpagFlutterPlatform.instance
        .invokePlugPagMethod('doPayment', [paymentData]);
    return PlugPagTransactionResult.fromMethodChannel(res['ppf_args']);
  }

  Future<PlugPagAbortResult> abort() async {
    final res = await PagseguroPlugpagFlutterPlatform.instance
        .invokePlugPagMethod('abort');
    return PlugPagAbortResult.fromMethodChannel(res['ppf_args']);
  }

  void asyncGetLastApprovedTransaction(
          PlugPagLastTransactionListener listener) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'asyncGetLastApprovedTransaction',
        [listener],
      );

  void asyncReprintCustomerReceipt(PlugPagPrinterListener listener) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'asyncReprintCustomerReceipt',
        [listener],
      );

  void asyncReprintEstablishmentReceipt(PlugPagPrinterListener listener) =>
      PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
        'asyncReprintEstablishmentReceipt',
        [listener],
      );
}
