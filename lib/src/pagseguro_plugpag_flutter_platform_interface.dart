import 'package:flutter/foundation.dart';
import 'package:pagseguro_plugpag_flutter/src/utils/interfaces/plug_pag_listener_class.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pagseguro_plugpag_flutter_method_channel.dart';

abstract class PagseguroPlugpagFlutterPlatform extends PlatformInterface {
  PagseguroPlugpagFlutterPlatform() : super(token: _token);

  void Function(Object ex)? _catchError;

  static final Object _token = Object();

  static PagseguroPlugpagFlutterPlatform _instance =
      MethodChannelPagseguroPlugpagFlutter();

  static PagseguroPlugpagFlutterPlatform get instance => _instance;

  static set instance(PagseguroPlugpagFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @protected
  void throwException(Object ex) => _catchError?.call(ex);

  Future invokePlugPagMethod(String methodName, [List<dynamic>? methodParams]);

  void onException(void Function(Object ex)? cathError) {
    _catchError = cathError;
  }

  void removeListener(PlugPagListenerClass listener);
}
