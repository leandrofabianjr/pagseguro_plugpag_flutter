// import 'package:flutter_test/flutter_test.dart';
// import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
// import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter_platform_interface.dart';
// import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockPagseguroPlugpagFlutterPlatform
//     with MockPlatformInterfaceMixin
//     implements PagseguroPlugpagFlutterPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final PagseguroPlugpagFlutterPlatform initialPlatform = PagseguroPlugpagFlutterPlatform.instance;

//   test('$MethodChannelPagseguroPlugpagFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelPagseguroPlugpagFlutter>());
//   });

//   test('getPlatformVersion', () async {
//     PagseguroPlugpagFlutter pagseguroPlugpagFlutterPlugin = PagseguroPlugpagFlutter();
//     MockPagseguroPlugpagFlutterPlatform fakePlatform = MockPagseguroPlugpagFlutterPlatform();
//     PagseguroPlugpagFlutterPlatform.instance = fakePlatform;

//     expect(await pagseguroPlugpagFlutterPlugin.getPlatformVersion(), '42');
//   });
// }
