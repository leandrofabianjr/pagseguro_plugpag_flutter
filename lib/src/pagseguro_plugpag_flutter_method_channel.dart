import 'package:flutter/services.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:pagseguro_plugpag_flutter/src/utils/exceptions/pagseguro_plugpag_flutter_exception.dart';

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
  ]) async {
    try {
      return await methodChannel.invokeMethod(
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
      if (e is PlatformException &&
          e.code == PagseguroPlugpagFlutterException.ppfPlugpagError) {
        final details = e.details as Map;
        final ppEx = PlugPagException.fromMethodChannel(details['ppf_args']);
        return Future.error(ppEx);
      }
      throwException(PagseguroPlugpagFlutterException.fromException(e));
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
          final e = PagseguroPlugpagFlutterException.fromMethodChannel(
            call.arguments,
          );
          throwException(e);
          break;
      }
    } catch (e) {
      throwException(PagseguroPlugpagFlutterException.fromException(e));
    }
  }

  Map<int, PlugPagListenerClass> listeners = {};

  Map<String, dynamic> registerListener(PlugPagListenerClass listener) {
    final map = listener.toMethodChannel();
    final hash = map[PlugPagListenerClass.attrHash];
    listeners[hash] = listener;
    return map;
  }

  @override
  void removeListener(PlugPagListenerClass listener) {
    listeners.remove(listener.hashCode);
  }
}
