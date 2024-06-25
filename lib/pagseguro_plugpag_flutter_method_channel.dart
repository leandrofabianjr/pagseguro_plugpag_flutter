import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pagseguro_plugpag_flutter_platform_interface.dart';

/// An implementation of [PagseguroPlugpagFlutterPlatform] that uses method channels.
class MethodChannelPagseguroPlugpagFlutter extends PagseguroPlugpagFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pagseguro_plugpag_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
