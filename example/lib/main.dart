import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:path_provider/path_provider.dart'
    show getExternalCacheDirectories;

void main() {
  runApp(const MaterialApp(home: PagseguroPlugpagFlutterExample()));
}

class PagseguroPlugpagFlutterExample extends StatefulWidget {
  const PagseguroPlugpagFlutterExample({super.key});

  @override
  State<PagseguroPlugpagFlutterExample> createState() =>
      _PagseguroPlugpagFlutterExampleState();
}

class _PagseguroPlugpagFlutterExampleState
    extends State<PagseguroPlugpagFlutterExample> with PlugPagImplementations {
  handleCall(Future<Widget> Function() callback) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FutureBuilder(
          future: callback(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pagseguro_plugpag_flutter'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Verificar autenticação da maquininha'),
            subtitle: const Text('isAuthenticated()'),
            onTap: () => handleCall(verificarAutenticaoMaquininha),
          ),
          ListTile(
            title: const Text('Ativar maquininha com código 749879'),
            subtitle: const Text(
              'initializeAndActivatePinpad(PlugPagActivationData(\'749879\'))',
            ),
            onTap: () => handleCall(ativarMaquininha),
          ),
          ListTile(
            title: const Text('Desativar maquininha com código 749879'),
            subtitle: const Text(
              'deactivate(PlugPagActivationData(\'749879\')',
            ),
            onTap: () => handleCall(desativarMaquininha),
          ),
          ListTile(
            title: const Text(
                'Calcular valor parcelas para R\$ 100 com juros para o comprador'),
            subtitle: const Text(
              'calculateInstallments(\'10000\', PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR)',
            ),
            onTap: () => handleCall(calcularParcelas),
          ),
          ListTile(
            title:
                const Text('Calcular valor parcelas para R\$ 100 assíncrono'),
            subtitle: const Text(
              'calculateInstallments(\'10000\', PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR)',
            ),
            onTap: () => handleCall(calcularParcelasAsync),
          ),
          ListTile(
            title: const Text('Imprimir imagem'),
            subtitle: const Text(
                'printFromFile(PlugPagPrinterData(filePath, 4, 10))'),
            onTap: () => handleCall(imprimirImagem),
          ),
        ],
      ),
    );
  }
}

mixin PlugPagImplementations {
  final _plugPag = PlugPag();

  Future<Widget> desativarMaquininha() {
    return _plugPag.deactivate(PlugPagActivationData('749879')).then((value) {
      if (value.result == PlugPag.RET_OK) {
        return const Text('Maquininha desativada');
      } else {
        return Text('Erro: ${value.errorCode} - ${value.errorMessage}');
      }
    });
  }

  Future<Widget> verificarAutenticaoMaquininha() {
    return _plugPag
        .isAuthenticated()
        .then((value) => Text('Maquininha ${value ? '' : ' não'} autenticada'));
  }

  Future<Widget> ativarMaquininha() {
    return _plugPag
        .initializeAndActivatePinpad(PlugPagActivationData('749879'))
        .then((value) {
      if (value.result == PlugPag.RET_OK) {
        return const Text('Maquininha ativada');
      } else {
        return Text('Erro: ${value.errorCode} - ${value.errorMessage}');
      }
    });
  }

  Future<Widget> calcularParcelas() {
    return _plugPag
        .calculateInstallments(
          '10000',
          PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR,
        )
        .then((value) => Column(
              children: value
                  .map((e) => Text(
                      '${e.quantity} x R\$ ${e.amountDouble} = R\$ ${e.totalDouble}'))
                  .toList(),
            ));
  }

  Future<Widget> calcularParcelasAsync() {
    final completer = Completer<Widget>();
    _plugPag.asyncCalculateInstallments(
        '10000',
        CalcularParcelasAsyncListener(
          (value) => completer.complete(value),
        ));
    return completer.future;
  }

  Future<Widget> imprimirImagem() async {
    const testImageUrl =
        'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png';
    var response = await get(Uri.parse(testImageUrl));
    final directory = (await getExternalCacheDirectories())![0].path;
    File imgFile = File('$directory/to-print.png');
    await imgFile.writeAsBytes(response.bodyBytes);
    return _plugPag
        .printFromFile(
      PlugPagPrinterData(imgFile.path, 4, 10),
    )
        .then((value) {
      if (value.result == PlugPag.RET_OK) {
        return Text(
            'Imagem impressa: ${value.message} - ${value.result} - ${value.steps}');
      } else {
        return Text('Erro: ${value.errorCode} - ${value.message}');
      }
    });
  }

  Future<Widget> pagamentoCredito() {
    final paymentData = PlugPagPaymentData(
      type: PlugPag.TYPE_CREDITO,
      amount: 1000,
      installmentType: PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR,
      installments: 3,
      userReference: "Teste pagseguro_plugpag_flutter",
      printReceipt: true,
    );
    return _plugPag.doPayment(paymentData).then((result) {
      if (result.result == PlugPag.RET_OK) {
        return Text('Pagamento realizado (${result.transactionCode})');
      } else {
        return Text('Erro: ${result.errorCode} - ${result.message}');
      }
    });
  }
}

class CalcularParcelasAsyncListener extends PlugPagInstallmentsListener {
  final void Function(Widget child) _handler;
  CalcularParcelasAsyncListener(this._handler);

  @override
  void onCalculateInstallments(List<String> installments) {
    _handler(Text(installments.join(', ')));
  }

  @override
  void onCalculateInstallmentsWithTotalAmount(
      List<PlugPagInstallment> installmentsWithTotalAmount) {
    _handler(Column(
      children: installmentsWithTotalAmount
          .map((e) => Text(
              '${e.quantity} x R\$ ${e.amountDouble} = R\$ ${e.totalDouble}'))
          .toList(),
    ));
  }

  @override
  void onError(String errorMessage) {
    _handler(Text(errorMessage));
  }
}

class PagamentoComCartaoListener extends PlugPagEventListener {
  var _passwordDigitsCounter = 0;
  final void Function(Widget child) _handler;
  PagamentoComCartaoListener(this._handler);

  @override
  void onEvent(PlugPagEventData data) {
    switch (data.eventCode) {
      case PlugPagEventData.EVENT_CODE_DIGIT_PASSWORD:
        _passwordDigitsCounter++;
        final hidden = List.generate(_passwordDigitsCounter, (_) => '*');
        _handler(Text('Senha: $hidden'));
        break;
      case PlugPagEventData.EVENT_CODE_NO_PASSWORD:
        _passwordDigitsCounter = 0;
        _handler(const Text('Senha: '));
        break;
      default:
        if (data.customMessage != null) {
          _handler(Text(data.customMessage!));
        }
    }
  }
}

class PrinterListener extends PlugPagPrinterListener {
  final void Function(Widget child) _handler;
  PrinterListener(this._handler);

  @override
  void onError(PlugPagPrintResult result) {
    _handler(
        Text('Erro de impressão: (${result.errorCode}) ${result.message}'));
  }

  @override
  void onSuccess(PlugPagPrintResult result) {
    _handler(
      Text(
        'Impressão concluída: ${result.message} - ${result.result} - ${result.steps}',
      ),
    );
  }
}
