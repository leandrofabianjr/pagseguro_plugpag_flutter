import 'package:pagseguro_plugpag_flutter/src/utils/mixins/to_method_channel.dart';

class PlugPagActivationData with ToMethodChannel {
  final String activationCode;

  PlugPagActivationData(this.activationCode);

  @override
  Map<String, dynamic> toMethodChannel() {
    return {
      "ppf_class":
          "br.com.uol.pagseguro.plugpagservice.wrapper.PlugPagActivationData",
      "ppf_params": [activationCode]
    };
  }
}
