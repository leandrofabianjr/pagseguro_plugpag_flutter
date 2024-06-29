import 'plug_pag_datas.dart';
import 'plug_pag_results.dart';
import 'utils/interfaces/plug_pag_listener_class.dart';

abstract class PlugPagInstallmentsListener extends PlugPagListenerClass {
  @override
  String get className => 'PlugPagInstallmentsListener';

  void onCalculateInstallments(List<String> installments);
  void onCalculateInstallmentsWithTotalAmount(
    List<PlugPagInstallment> installmentsWithTotalAmount,
  );
  void onError(String errorMessage);

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onCalculateInstallments':
        final list = (args[0] as List).map((e) => e.toString()).toList();
        onCalculateInstallments(list);
        break;
      case 'onCalculateInstallmentsWithTotalAmount':
        throw Exception('Ainda não foi implementado');
      case 'onError':
        onError(args[0].toString());
        break;
      default:
        throw Exception(
            'Método inválido em PlugPagInstallmentsListener: $method');
    }
  }
}

abstract class PlugPagEventListener extends PlugPagListenerClass {
  void onEvent(PlugPagEventData data);

  @override
  String get className => 'PlugPagEventListener';

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onEvent':
        onEvent(args[0] as PlugPagEventData);
        break;
      default:
        throw Exception('Método inválido em PlugPagEventListener: $method');
    }
  }
}

// public interface PlugPagPrinterListener {
//     public abstract fun onError(result: br.com.uol.pagseguro.plugpagservice.wrapper.PlugPagPrintResult): kotlin.Unit

//     public abstract fun onSuccess(result: br.com.uol.pagseguro.plugpagservice.wrapper.PlugPagPrintResult): kotlin.Unit
// }

abstract class PlugPagPrinterListener extends PlugPagListenerClass {
  void onError(PlugPagPrintResult result);
  void onSuccess(PlugPagPrintResult result);

  @override
  String packageName = 'br.com.uol.pagseguro.plugpagservice.wrapper';

  @override
  String get className => 'PlugPagPrinterListener';

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onError':
        onError(args[0] as PlugPagPrintResult);
        break;
      case 'onSuccess':
        onSuccess(args[0] as PlugPagPrintResult);
        break;
      default:
        throw Exception('Método inválido em PlugPagPrinterListener: $method');
    }
  }
}
