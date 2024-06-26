class PlugPagActivationData {
  final String activationCode;

  PlugPagActivationData(this.activationCode);

  Map<String, dynamic> toMethodChannel() {
    return {
      "ppf_class":
          "br.com.uol.pagseguro.plugpagservice.wrapper.PlugPagActivationData",
      "ppf_params": [activationCode]
    };
  }
}
