import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pagseguro_plugpag_flutter/src/utils/mixins/to_method_channel.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';

class MethodChannelPagseguroPlugpagFlutter
    extends PagseguroPlugpagFlutterPlatform {
  @visibleForTesting
  final methodChannel =
      const MethodChannel('pagseguro_plugpag_flutter_channel');

  @override
  Future invokePlugPagMethod(
    String methodName, [
    List<dynamic>? methodParams,
  ]) =>
      methodChannel.invokeMethod(
        methodName,
        methodParams
            ?.map((p) => p is ToMethodChannel ? p.toMethodChannel() : p)
            .toList(),
      );
}
