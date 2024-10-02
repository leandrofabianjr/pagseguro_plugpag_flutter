import 'package:flutter/material.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  late final PlugPag plugPag;

  Future<PlugPagNFCInfosResultDirectly> readNfc() async {
    final resultStartNfc = await plugPag.startNFCCardDirectly();
    if (resultStartNfc != PlugPag.NFC_RET_OK) {
      throw Exception('Erro ao iniciar leitor NFC');
    } else {
      try {
        final plugPagNFCInfos = await plugPag.detectNfcCardDirectly(
            PlugPagNearFieldCardData.ONLY_M, 10);
        plugPag.stopNFCCardDirectly();
        return plugPagNFCInfos;
      } catch (e) {
        plugPag.stopNFCCardDirectly();
        throw Exception('Cartão não identificado: $e');
      }
    }
  }

  @override
  void initState() {
    plugPag = PlugPag();
    plugPag.onException((cathError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      body: Center(
          child: FutureBuilder(
              future: readNfc(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data?.serialNumber?.toString() ?? 'Nada',
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const CircularProgressIndicator();
              })),
    );
  }
}
