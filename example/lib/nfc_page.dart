import 'package:flutter/material.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

enum NfcPageAction { init, startNfc, readNfc, stopNfc }

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  late final NfcService _nfcService;
  NfcPageAction action = NfcPageAction.init;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> Function(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) get showToast => ScaffoldMessenger.of(context).showSnackBar;

  Future doAction() {
    return switch (action) {
      NfcPageAction.init => Future.value(true),
      NfcPageAction.startNfc => _nfcService.startNfc(),
      NfcPageAction.stopNfc => _nfcService.stopNfc(),
      NfcPageAction.readNfc =>
        _nfcService.readNfcCardSerial(const Duration(seconds: 10)),
    };
  }

  @override
  void initState() {
    _nfcService = PlugPagNfcService(onUnexpectedError: (err) {
      showToast(SnackBar(
        content: Text(err.toString()),
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
                    return Text(
                      snapshot.data?.toString() ?? 'Sem serial',
                    );
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

class NfcServiceException implements Exception {}

class NfcServiceNotStartedException implements Exception {}

class NfcServiceReadingException implements Exception {}

abstract class NfcService {
  Future<bool> startNfc();
  Future<bool> stopNfc();
  Future<String?> readNfcCardSerial(Duration timeout);
}

class PlugPagNfcService implements NfcService {
  late final PlugPag _plugPag;

  PlugPagNfcService({Function(Exception ex)? onUnexpectedError}) {
    _plugPag = PlugPag();
    _plugPag.onException(onUnexpectedError);
  }

  @override
  Future<bool> startNfc() async {
    await _plugPag.abort();
    return _plugPag.startNFCCardDirectly().then(
          (value) => value == PlugPag.NFC_RET_OK,
          onError: (e) => throw NfcServiceException(),
        );
  }

  @override
  Future<bool> stopNfc() async {
    await _plugPag.abort();
    return _plugPag.stopNFCCardDirectly().then(
          (value) => value == PlugPag.NFC_RET_OK,
          onError: (e) => throw NfcServiceException(),
        );
  }

  @override
  Future<String?> readNfcCardSerial(Duration timeout) async {
    final result = await _plugPag.detectNfcCardDirectly(
      PlugPagNearFieldCardData.ONLY_M,
      timeout.inSeconds,
    );
    if (result.result == PlugPag.NFC_RET_OK) {
      return result.serialNumberAsHexString;
    }
    return null;
  }
}
