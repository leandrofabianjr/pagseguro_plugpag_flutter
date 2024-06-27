import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_activation_data.dart';
import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_initialization_result.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';

class PagseguroPlugpagFlutter {
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
