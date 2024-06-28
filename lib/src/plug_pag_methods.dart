import 'pagseguro_plugpag_flutter_platform_interface.dart';
import 'plug_pag_datas.dart';
import 'plug_pag_results.dart';

mixin PlugPagMethods {
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
    return PlugPagInitializationResult.fromMethodChannel(res);
  }

  Future<PlugPagInitializationResult> deactivate(
    PlugPagActivationData data,
  ) async {
    final res =
        await PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
      'deactivate',
      [data],
    );
    return PlugPagInitializationResult.fromMethodChannel(res);
  }

  Future<List<PlugPagInstallment>> calculateInstallments(
    String saleValue,
    int installmentType,
  ) async {
    final res =
        await PagseguroPlugpagFlutterPlatform.instance.invokePlugPagMethod(
      'calculateInstallments',
      [saleValue, installmentType],
    );
    return (res as List)
        .map((i) => PlugPagInstallment.fromMethodChannel(i))
        .toList();
  }

  Future<PlugPagPrintResult> printFromFile(
      PlugPagPrinterData printerData) async {
    final res = await PagseguroPlugpagFlutterPlatform.instance
        .invokePlugPagMethod('printFromFile', [printerData]);
    return PlugPagPrintResult.fromMethodChannel(res);
  }
}
