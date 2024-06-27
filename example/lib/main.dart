import 'package:flutter/material.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pagseguro_plugpag_flutter'),
      ),
      body: ListView(children: [
        ListTile(
          title: const Text('Verificar autenticação da maquininha'),
          subtitle: const Text('isAuthenticated'),
          onTap: () => callMethod(
            () => _plugPag.isAuthenticated().then((value) =>
                Text('Maquininha ${value ? '' : ' não'} autenticada')),
          ),
        ),
        ListTile(
          title: const Text('Ativar maquininha com código 749879'),
          subtitle: const Text('initializeAndActivatePinpad'),
          onTap: () => callMethod(
            () => _plugPag
                .initializeAndActivatePinpad(PlugPagActivationData('749879'))
                .then((value) {
              if (value.result == PlugPag.RET_OK) {
                return const Text('Maquininha ativada');
              } else {
                return Text('Erro: ${value.errorCode} - ${value.errorMessage}');
              }
            }),
          ),
        ),
        ListTile(
          title: const Text('Desativar maquininha com código 749879'),
          subtitle: const Text('deactivate'),
          onTap: () => callMethod(
            () => _plugPag
                .deactivate(PlugPagActivationData('749879'))
                .then((value) {
              if (value.result == PlugPag.RET_OK) {
                return const Text('Maquininha desativada');
              } else {
                return Text('Erro: ${value.errorCode} - ${value.errorMessage}');
              }
            }),
          ),
        )
      ]),
    );
  }
}
