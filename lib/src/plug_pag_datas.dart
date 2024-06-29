import 'utils/interfaces/plug_pag_data_class.dart';

class PlugPagActivationData extends PlugPagDataClass {
  final String activationCode;
  PlugPagActivationData(this.activationCode);
  @override
  String get className => 'PlugPagActivationData';
  @override
  List get params => [activationCode];
}

class PlugPagPrinterData extends PlugPagDataClass {
  final String filePath;
  final int printerQuality, steps;
  PlugPagPrinterData(this.filePath, this.printerQuality, this.steps);
  @override
  String get className => 'PlugPagPrinterData';
  @override
  List get params => [filePath, printerQuality, steps];
}
