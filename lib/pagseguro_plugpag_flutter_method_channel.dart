import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_activation_data.dart';
import 'package:pagseguro_plugpag_flutter/adaptations/plug_pag_initialization_result.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';

/// An implementation of [PagseguroPlugpagFlutterPlatform] that uses method channels.
class MethodChannelPagseguroPlugpagFlutter
    extends PagseguroPlugpagFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pagseguro_plugpag_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isAuthenticated() async {
    final res = await methodChannel.invokeMethod('isAuthenticated');
    return res == true;
  }

  @override
  Future<PlugPagInitializationResult> initializeAndActivatePinpad(
      PlugPagActivationData data) async {
    final arguments = [data.toMethodChannel()];
    final res = await methodChannel.invokeMethod<Map>(
      'initializeAndActivatePinpad',
      arguments,
    );
    return PlugPagInitializationResult.fromMethodChannel(res);
  }
}
