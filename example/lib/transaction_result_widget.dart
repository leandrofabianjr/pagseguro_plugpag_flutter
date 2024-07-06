import 'package:flutter/material.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';

class TransactionResultWidget extends StatelessWidget {
  const TransactionResultWidget(this.transactionResult,
      {super.key, this.title});

  final PlugPagTransactionResult transactionResult;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final map = transactionResult.toMap().entries.toList();
    map.sort((a, b) => a.key.compareTo(b.key));
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Resultado da transação')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Atributo')),
              DataColumn(label: Text('Valor')),
            ],
            rows: map
                .map((e) => DataRow(cells: [
                      DataCell(Text(e.key)),
                      DataCell(
                        Text(e.value == null ? 'null' : e.value.toString()),
                      )
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}
