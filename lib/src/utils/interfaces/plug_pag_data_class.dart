abstract class PlugPagDataClass {
  final String _packageName = "br.com.uol.pagseguro.plugpagservice.wrapper";

  static const attrClass = "ppf_data_class";
  static const attrParams = "ppf_data_class_params";

  String get className;
  List<dynamic> get params;

  Map<String, dynamic> toMethodChannel() {
    return {attrClass: "$_packageName.$className", attrParams: params};
  }
}
