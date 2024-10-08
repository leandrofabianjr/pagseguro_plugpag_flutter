import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:pagseguro_plugpag_flutter_example/nfc_page.dart';
import 'package:pagseguro_plugpag_flutter_example/transaction_result_widget.dart';
import 'package:path_provider/path_provider.dart'
    show getExternalCacheDirectories;
import 'package:provider/provider.dart';

import 'payment_page.dart';

class TemporaryData extends ChangeNotifier {
  List<PlugPagTransactionResult> transactions = [];
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TemporaryData(),
    child: const MaterialApp(home: PagseguroPlugpagFlutterExample()),
  ));
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
    final completer = Completer<Widget>();
    callback().then(completer.complete, onError: completer.completeError);
    _plugPag.onException((e) => completer.completeError(e));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FutureBuilder(
          future: completer.future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              return SingleChildScrollView(
                child: Text(snapshot.error.toString()),
              );
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
            title: const Text('Fazer pagamento'),
            subtitle: const Text('doPayment()'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PaymentPage()),
            ),
          ),
          ListTile(
            title: const Text('NFC'),
            subtitle: const Text('doPayment()'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NfcPage()),
            ),
          ),
          ListTile(
            title: const Text('Buscar última transação aprovada'),
            subtitle: const Text('asyncGetLastApprovedTransaction()'),
            onTap: () => handleCall(ultimaTransacaoAprovada),
          ),
          ListTile(
            title: const Text('Reimpressão via cliente'),
            subtitle: const Text('asyncReprintCustomerReceipt()'),
            onTap: () => handleCall(reimpressaoViaCliente),
          ),
          ListTile(
            title: const Text('Reimpressão via estabelecimento'),
            subtitle: const Text('asyncReprintEstablishmentReceipt()'),
            onTap: () => handleCall(reimpressaoViaEstabelecimento),
          ),
          ListTile(
            title: const Text('Cancelar execução'),
            subtitle: const Text('abort()'),
            onTap: () => handleCall(cancelarExecucao),
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

  Future<Widget> ultimaTransacaoAprovada() {
    final completer = Completer<Widget>();
    _plugPag.asyncGetLastApprovedTransaction(UltimaTransacaoListener(
      (value) => completer.complete(value),
    ));
    return completer.future;
  }

  Future<Widget> reimpressaoViaCliente() {
    final completer = Completer<Widget>();
    _plugPag.asyncReprintCustomerReceipt(
      ImpressaoListener(
        title: 'Reimpressão via cliente',
        handler: (value) => completer.complete(value),
      ),
    );
    return completer.future;
  }

  Future<Widget> reimpressaoViaEstabelecimento() {
    final completer = Completer<Widget>();
    _plugPag.asyncReprintEstablishmentReceipt(
      ImpressaoListener(
        title: 'Reimpressão via estabelecimento',
        handler: (value) => completer.complete(value),
      ),
    );
    return completer.future;
  }

  Future<Widget> cancelarExecucao() => _plugPag.abort().then(
        (value) => value.result == PlugPag.RET_OK
            ? const Text('Execução cancelada')
            : Text('Erro: ${value.result}'),
        onError: (e) => Text('Erro: ${e.toString()}'),
      );
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

class ImpressaoListener extends PlugPagPrinterListener {
  ImpressaoListener({required this.title, required this.handler});
  final String title;
  final void Function(Widget child) handler;

  @override
  void onError(PlugPagPrintResult result) {
    handler(Text(
      '$title:\nErro de impressão: (${result.errorCode}) ${result.message}',
    ));
  }

  @override
  void onSuccess(PlugPagPrintResult result) {
    handler(Text(
      '$title:\nImpressão concluída: ${result.message} - ${result.result} - ${result.steps}',
    ));
  }
}

class UltimaTransacaoListener extends PlugPagLastTransactionListener {
  final void Function(Widget child) _handler;
  UltimaTransacaoListener(this._handler);

  @override
  void onError(PlugPagTransactionResult result) {
    _handler(TransactionResultWidget(
      result,
      title: 'Erro ao buscar última transação',
    ));
  }

  @override
  void onRequestedLastTransaction(PlugPagTransactionResult result) {
    _handler(TransactionResultWidget(
      result,
      title: 'Última transação',
    ));
  }
}
