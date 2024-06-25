import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pagseguro_plugpag_flutter_method_channel.dart';

abstract class PagseguroPlugpagFlutterPlatform extends PlatformInterface {
  /// Constructs a PagseguroPlugpagFlutterPlatform.
  PagseguroPlugpagFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PagseguroPlugpagFlutterPlatform _instance = MethodChannelPagseguroPlugpagFlutter();

  /// The default instance of [PagseguroPlugpagFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelPagseguroPlugpagFlutter].
  static PagseguroPlugpagFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PagseguroPlugpagFlutterPlatform] when
  /// they register themselves.
  static set instance(PagseguroPlugpagFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
