import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';
import 'utils/interfaces/plug_pag_data_class.dart';
import 'utils/interfaces/plug_pag_listener_class.dart';

const _methodChannelName = 'pagseguro_plugpag_flutter_channel';

class MethodChannelPagseguroPlugpagFlutter
    extends PagseguroPlugpagFlutterPlatform {
  MethodChannelPagseguroPlugpagFlutter() {
    methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  final methodChannel = const MethodChannel(_methodChannelName);

  @override
  Future invokePlugPagMethod(
    String methodName, [
    List<dynamic>? methodParams,
  ]) {
    try {
      return methodChannel.invokeMethod(
        methodName,
        methodParams?.map((p) {
          if (p is PlugPagDataClass) {
            return p.toMethodChannel();
          }
          if (p is PlugPagListenerClass) {
            return registerListener(p);
          }
          return p;
        }).toList(),
      );
    } catch (e) {
      if (kDebugMode) print(e);
      throwException(e);
      return Future.error(e);
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case PlugPagListenerClass.attrInvoke:
          final map = call.arguments;
          final hash = map[PlugPagListenerClass.attrHash];
          final listener = listeners[hash];
          final method = map[PlugPagListenerClass.attrInvokeMethod];
          final args = map[PlugPagListenerClass.attrInvokeMethodArgs];
          listener?.invoke(method, args);
          break;
        case "ppf_error":
          throw Exception(call.arguments);
      }
    } catch (e) {
      throwException(e);
      return Future.error(e);
    }
  }

  Map<int, PlugPagListenerClass> listeners = {};

  Map<String, dynamic> registerListener(PlugPagListenerClass listener) {
    final map = listener.toMethodChannel();
    final hash = map[PlugPagListenerClass.attrHash];
    try {
      listeners[hash] = listener;
    } catch (e) {
      throwException(e);
    }
    return map;
  }

  @override
  void removeListener(PlugPagListenerClass listener) {
    listeners.remove(listener.hashCode);
  }
}
