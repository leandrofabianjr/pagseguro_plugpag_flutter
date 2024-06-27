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
}
