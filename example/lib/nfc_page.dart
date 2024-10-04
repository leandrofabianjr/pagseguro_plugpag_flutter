import 'package:flutter/material.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

enum NfcPageAction { init, startNfc, readNfc, stopNfc }

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  late final PlugPag plugPag;
  NfcPageAction action = NfcPageAction.init;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) get showToast => ScaffoldMessenger.of(context).showSnackBar;

  Future doAction() {
    return switch (action) {
      NfcPageAction.init => Future.value(true),
      NfcPageAction.startNfc => plugPag.startNFCCardDirectly(),
      NfcPageAction.stopNfc => plugPag.stopNFCCardDirectly(),
      NfcPageAction.readNfc =>
        plugPag.detectNfcCardDirectly(PlugPagNearFieldCardData.ONLY_M, 3),
    };
  }

  @override
  void initState() {
    plugPag = PlugPag();
    plugPag.onException((cathError) {
      showToast(SnackBar(
        content: Text(cathError.toString()),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder(
            future: doAction(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                switch (action) {
                  case NfcPageAction.init:
                    return const SizedBox();
                  case NfcPageAction.startNfc:
                    return const Text('NFC Iniciado');
                  case NfcPageAction.readNfc:
                    if (snapshot.data is PlugPagNearFieldCardData) {
                      return Text(
                        snapshot.data?.serialNumber?.toString() ?? 'Sem serial',
                      );
                    } else {
                      return const Text('Inicie o NFC antes de ler!');
                    }
                  case NfcPageAction.stopNfc:
                    return const Text('NFC Parado');
                }
              }
              if (snapshot.hasError) {
                if (snapshot.error is PlugPagException) {
                  return Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return Text(
                  'Erro inesperado: ${snapshot.error.toString()}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          ElevatedButton(
            onPressed: () => setState(() => action = NfcPageAction.startNfc),
            child: const Text('Iniciar NFC'),
          ),
          ElevatedButton(
            onPressed: () => setState(() => action = NfcPageAction.readNfc),
            child: const Text('Ler NFC'),
          ),
          ElevatedButton(
            onPressed: () => setState(() => action = NfcPageAction.stopNfc),
            child: const Text('Parar NFC'),
          ),
        ],
      ),
    );
  }
}
