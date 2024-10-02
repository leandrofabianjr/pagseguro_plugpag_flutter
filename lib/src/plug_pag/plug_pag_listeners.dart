import '../utils/interfaces/plug_pag_listener_class.dart';
import 'plug_pag_results.dart';

abstract class PlugPagInstallmentsListener extends PlugPagListenerClass {
  @override
  String get className => 'listeners.PlugPagInstallmentsListener';

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
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagEventData.fromMethodChannel(classArgs);
        onEvent(result);
        break;
      default:
        throw Exception('Método inválido em PlugPagEventListener: $method');
    }
  }
}

abstract class PlugPagPrinterListener extends PlugPagListenerClass {
  void onError(PlugPagPrintResult result);
  void onSuccess(PlugPagPrintResult result);

  @override
  String get className => 'PlugPagPrinterListener';

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onError':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagPrintResult.fromMethodChannel(classArgs);
        onError(result);
        break;
      case 'onSuccess':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagPrintResult.fromMethodChannel(classArgs);
        onSuccess(result);
        break;
      default:
        throw Exception('Método inválido em PlugPagPrinterListener: $method');
    }
  }
}

abstract class PlugPagLastTransactionListener extends PlugPagListenerClass {
  void onError(PlugPagTransactionResult result);
  void onRequestedLastTransaction(PlugPagTransactionResult result);

  @override
  String get className => 'listeners.PlugPagLastTransactionListener';

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onError':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagTransactionResult.fromMethodChannel(classArgs);
        onError(result);
        break;
      case 'onRequestedLastTransaction':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagTransactionResult.fromMethodChannel(classArgs);
        onRequestedLastTransaction(result);
        break;
      default:
        throw Exception(
            'Método inválido em PlugPagLastTransactionListener: $method');
    }
  }
}

abstract class PlugPagNFCListener extends PlugPagListenerClass {
  void onError(PlugPagNFCResult result);
  void onSuccess(PlugPagNFCResult result);

  @override
  String get className => 'PlugPagNFCListener';

  @override
  void invoke(String method, List<dynamic> args) {
    switch (method) {
      case 'onError':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagNFCResult.fromMethodChannel(classArgs);
        onError(result);
        break;
      case 'onSuccess':
        final classArgs = (args[0]['ppf_args'] as Map);
        final result = PlugPagNFCResult.fromMethodChannel(classArgs);
        onSuccess(result);
        break;
      default:
        throw Exception('Método inválido em PlugPagNFCListener: $method');
    }
  }
}
