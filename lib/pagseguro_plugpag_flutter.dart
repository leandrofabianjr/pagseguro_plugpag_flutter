
import 'pagseguro_plugpag_flutter_platform_interface.dart';

class PagseguroPlugpagFlutter {
  Future<String?> getPlatformVersion() {
    return PagseguroPlugpagFlutterPlatform.instance.getPlatformVersion();
  }
}
