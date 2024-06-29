import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pagseguro_plugpag_flutter_method_channel.dart';

abstract class PagseguroPlugpagFlutterPlatform extends PlatformInterface {
  PagseguroPlugpagFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PagseguroPlugpagFlutterPlatform _instance =
      MethodChannelPagseguroPlugpagFlutter();

  static PagseguroPlugpagFlutterPlatform get instance => _instance;

  static set instance(PagseguroPlugpagFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future invokePlugPagMethod(String methodName, [List<dynamic>? methodParams]);
}
