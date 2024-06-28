import 'package:pagseguro_plugpag_flutter/src/utils/interfaces/plug_pag_class_data.dart';

class PlugPagActivationData extends PlugPagClassData {
  final String activationCode;
  PlugPagActivationData(this.activationCode);
  @override
  String get className => 'PlugPagActivationData';
  @override
  List get params => [activationCode];
}

class PlugPagPrinterData extends PlugPagClassData {
  final String filePath;
  final int printerQuality, steps;
  PlugPagPrinterData(this.filePath, this.printerQuality, this.steps);
  @override
  String get className => 'PlugPagPrinterData';
  @override
  List get params => [filePath, printerQuality, steps];
}
