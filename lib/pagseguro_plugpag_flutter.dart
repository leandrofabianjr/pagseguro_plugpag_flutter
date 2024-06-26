import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_activation_data.dart';
import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_initialization_result.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';

class PagseguroPlugpagFlutter {
  Future<String?> getPlatformVersion() {
    return PagseguroPlugpagFlutterPlatform.instance.getPlatformVersion();
  }

  Future<bool> isAuthenticated() {
    return PagseguroPlugpagFlutterPlatform.instance.isAuthenticated();
  }

  Future<PlugPagInitializationResult> initializeAndActivatePinpad(
      PlugPagActivationData data) {
    return PagseguroPlugpagFlutterPlatform.instance
        .initializeAndActivatePinpad(data);
  }
}
