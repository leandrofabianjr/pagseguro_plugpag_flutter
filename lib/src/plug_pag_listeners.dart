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
