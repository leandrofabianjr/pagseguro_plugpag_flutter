import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
    extends State<PagseguroPlugpagFlutterExample> {
  final _plugPag = PlugPag();

  final _testImageUrl =
      'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png';

  callMethod(Future<Widget> Function() callback) {
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

  Future<String> get _imageFilePath async {
    var response = await get(Uri.parse(_testImageUrl));
    final directory = (await getExternalCacheDirectories())![0].path;
    File imgFile = File('$directory/to-print.png');
    await imgFile.writeAsBytes(response.bodyBytes);
    return imgFile.path;
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
            onTap: () => callMethod(
              () => _plugPag.isAuthenticated().then((value) =>
                  Text('Maquininha ${value ? '' : ' não'} autenticada')),
            ),
          ),
          ListTile(
            title: const Text('Ativar maquininha com código 749879'),
            subtitle: const Text(
              'initializeAndActivatePinpad(PlugPagActivationData(\'749879\'))',
            ),
            onTap: () => callMethod(
              () => _plugPag
                  .initializeAndActivatePinpad(PlugPagActivationData('749879'))
                  .then((value) {
                if (value.result == PlugPag.RET_OK) {
                  return const Text('Maquininha ativada');
                } else {
                  return Text(
                      'Erro: ${value.errorCode} - ${value.errorMessage}');
                }
              }),
            ),
          ),
          ListTile(
            title: const Text('Desativar maquininha com código 749879'),
            subtitle: const Text(
              'deactivate(PlugPagActivationData(\'749879\')',
            ),
            onTap: () => callMethod(
              () => _plugPag
                  .deactivate(PlugPagActivationData('749879'))
                  .then((value) {
                if (value.result == PlugPag.RET_OK) {
                  return const Text('Maquininha desativada');
                } else {
                  return Text(
                      'Erro: ${value.errorCode} - ${value.errorMessage}');
                }
              }),
            ),
          ),
          ListTile(
            title: const Text(
                'Calcular valor parcelas para R\$ 100 com juros para o comprador'),
            subtitle: const Text(
              'calculateInstallments(\'10000\', PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR)',
            ),
            onTap: () => callMethod(
              () => _plugPag
                  .calculateInstallments(
                    '10000',
                    PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR,
                  )
                  .then((value) => Column(
                        children: value
                            .map((e) => Text(
                                '${e.quantity} x R\$ ${e.amountDouble} = R\$ ${e.totalDouble}'))
                            .toList(),
                      )),
            ),
          ),
          ListTile(
            title: const Text('Imprimir imagem'),
            subtitle: const Text(
                'printImage(\'https://www.google.com.br/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png\')'),
            onTap: () => callMethod(
              () => _imageFilePath
                  .then((filePath) => _plugPag.printFromFile(
                        PlugPagPrinterData(filePath, 4, 10),
                      ))
                  .then((value) {
                if (value.result == PlugPag.RET_OK) {
                  return Text(
                      'Imagem impressa: ${value.message} - ${value.result} - ${value.steps}');
                } else {
                  return Text('Erro: ${value.errorCode} - ${value.message}');
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
