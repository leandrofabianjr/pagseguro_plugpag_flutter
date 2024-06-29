abstract class PlugPagListenerClass {
  static const attrClass = "ppf_listener_class";
  static const attrHash = "ppf_listener_hash";
  static const attrInvoke = "ppf_invoke_listener";
  static const attrInvokeMethod = "ppf_invoke_listener_method";
  static const attrInvokeMethodArgs = "ppf_invoke_listener_method_args";

  String get packageName =>
      "br.com.uol.pagseguro.plugpagservice.wrapper.listeners";

  String get className;

  Map<String, dynamic> toMethodChannel() {
    return {
      attrClass: "$packageName.$className",
      attrHash: hashCode,
    };
  }

  void invoke(String method, List<dynamic> args);
}
