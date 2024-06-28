abstract class PlugPagClassData {
  final String _packageName = "br.com.uol.pagseguro.plugpagservice.wrapper";

  String get className;
  List<dynamic> get params;

  Map<String, dynamic> toMethodChannel() {
    return {"ppf_class": "$_packageName.$className", "ppf_params": params};
  }
}
