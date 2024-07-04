import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:provider/provider.dart';

extension on String {
  double get asDouble => double.tryParse(replaceAll(',', '.')) ?? 0;

  String get asBRL {
    final numbers = (int.tryParse(replaceAll(RegExp('[^0-9]'), '')) ?? 0)
        .toString()
        .replaceAll(RegExp('[^0-9]'), '')
        .padLeft(3, '0');
    return '${numbers.substring(0, numbers.length - 2)},${numbers.substring(numbers.length - 2)}';
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlugPagPaymentController(),
      child: const PaymentPageView(),
    );
  }
}

class PaymentPageView extends StatefulWidget {
  const PaymentPageView({super.key});

  @override
  State<PaymentPageView> createState() => _PaymentPageViewState();
}

class _PaymentPageViewState extends State<PaymentPageView> {
  final _formKey = GlobalKey<FormState>();
  final _valorTxtController = TextEditingController();
  final _referenciaTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void doPayment() {
    if (_formKey.currentState?.validate() == true) {
      context.read<PlugPagPaymentController>().doPayment(
            PlugPagPaymentData.fromDoubleAmount(
              type: PlugPagPaymentDataType.credito,
              amount: _valorTxtController.text.asDouble,
              userReference: _referenciaTxtController.text,
              installmentType: PlugPagPaymentDataInstallmentType.aVista,
              printReceipt: true,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento com Cartão'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PlugPagPaymentController>(
            builder: (context, controller, child) {
              final state = controller.state;
              switch (state.status) {
                case PlugPagPaymentControllerStatus.ready:
                  return child!;
                case PlugPagPaymentControllerStatus.loading:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      Text(state.message ?? 'Aguarde'),
                      TextButton(
                        onPressed: controller.abort,
                        child: const Text('Cancelar'),
                      )
                    ],
                  );
                case PlugPagPaymentControllerStatus.digitPassword:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Digite sua senha:'),
                      Text(state.hiddenPassword),
                    ],
                  );
                case PlugPagPaymentControllerStatus.error:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Erro:'),
                      if (state.hasCode) Text(state.code!),
                      if (state.hasMessage) Text(state.message!),
                    ],
                  );
                case PlugPagPaymentControllerStatus.finished:
                  return SingleChildScrollView(
                    child: TransactionResultWidget(state.transactionResult!),
                  );
                case PlugPagPaymentControllerStatus.aborted:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Transação cancelada'),
                      TextButton(
                        onPressed: controller.restart,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  );
              }
            },
            child: _buildform(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: doPayment,
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildform() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          TextFormField(
            controller: _valorTxtController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Align(widthFactor: 0, child: Text('R\$')),
              labelText: 'Valor da transação',
            ),
            validator: (value) {
              return (value ?? '').asDouble > 0
                  ? null
                  : 'Valor deve ser maior que R\$ 1.00';
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction(
                (_, newValue) => TextEditingValue(text: newValue.text.asBRL),
              )
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _referenciaTxtController,
            keyboardType: TextInputType.text,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Referência',
            ),
            validator: (value) {
              return (value ?? '').isNotEmpty ? null : 'Não pode ser vazio';
            },
          ),
        ],
      ),
    );
  }
}

class TransactionResultWidget extends StatelessWidget {
  const TransactionResultWidget(this.transactionResult, {super.key});

  final PlugPagTransactionResult transactionResult;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Atributo')),
          DataColumn(label: Text('Valor')),
        ],
        rows: [
          if (transactionResult.message != null)
            DataRow(
              cells: [
                const DataCell(Text('Message:')),
                DataCell(Text(transactionResult.message!)),
              ],
            ),
          if (transactionResult.errorCode != null)
            DataRow(
              cells: [
                const DataCell(Text('ErrorCode:')),
                DataCell(Text(transactionResult.errorCode!)),
              ],
            ),
          if (transactionResult.transactionCode != null)
            DataRow(
              cells: [
                const DataCell(Text('TransactionCode:')),
                DataCell(Text(transactionResult.transactionCode!)),
              ],
            ),
          if (transactionResult.transactionId != null)
            DataRow(
              cells: [
                const DataCell(Text('TransactionId:')),
                DataCell(Text(transactionResult.transactionId!)),
              ],
            ),
          if (transactionResult.date != null)
            DataRow(
              cells: [
                const DataCell(Text('Date:')),
                DataCell(Text(transactionResult.date!)),
              ],
            ),
          if (transactionResult.time != null)
            DataRow(
              cells: [
                const DataCell(Text('Time:')),
                DataCell(Text(transactionResult.time!)),
              ],
            ),
          if (transactionResult.hostNsu != null)
            DataRow(
              cells: [
                const DataCell(Text('HostNsu:')),
                DataCell(Text(transactionResult.hostNsu!)),
              ],
            ),
          if (transactionResult.cardBrand != null)
            DataRow(
              cells: [
                const DataCell(Text('CardBrand:')),
                DataCell(Text(transactionResult.cardBrand!)),
              ],
            ),
          if (transactionResult.bin != null)
            DataRow(
              cells: [
                const DataCell(Text('Bin:')),
                DataCell(Text(transactionResult.bin!)),
              ],
            ),
          if (transactionResult.holder != null)
            DataRow(
              cells: [
                const DataCell(Text('Holder:')),
                DataCell(Text(transactionResult.holder!)),
              ],
            ),
          if (transactionResult.userReference != null)
            DataRow(
              cells: [
                const DataCell(Text('UserReference:')),
                DataCell(Text(transactionResult.userReference!)),
              ],
            ),
          if (transactionResult.terminalSerialNumber != null)
            DataRow(
              cells: [
                const DataCell(Text('TerminalSerialNumber:')),
                DataCell(Text(transactionResult.terminalSerialNumber!)),
              ],
            ),
          if (transactionResult.amount != null)
            DataRow(
              cells: [
                const DataCell(Text('Amount:')),
                DataCell(Text(transactionResult.amount!)),
              ],
            ),
          if (transactionResult.availableBalance != null)
            DataRow(
              cells: [
                const DataCell(Text('AvailableBalance:')),
                DataCell(Text(transactionResult.availableBalance!)),
              ],
            ),
          if (transactionResult.cardApplication != null)
            DataRow(
              cells: [
                const DataCell(Text('CardApplication:')),
                DataCell(Text(transactionResult.cardApplication!)),
              ],
            ),
          if (transactionResult.label != null)
            DataRow(
              cells: [
                const DataCell(Text('Label:')),
                DataCell(Text(transactionResult.label!)),
              ],
            ),
          if (transactionResult.holderName != null)
            DataRow(
              cells: [
                const DataCell(Text('HolderName:')),
                DataCell(Text(transactionResult.holderName!)),
              ],
            ),
          if (transactionResult.extendedHolderName != null)
            DataRow(
              cells: [
                const DataCell(Text('ExtendedHolderName:')),
                DataCell(Text(transactionResult.extendedHolderName!)),
              ],
            ),
          if (transactionResult.cardIssuerNationality != null)
            DataRow(
              cells: [
                const DataCell(Text('CardIssuerNationality:')),
                DataCell(Text(transactionResult.cardIssuerNationality!.name)),
              ],
            ),
        ],
      ),
    );
  }
}
