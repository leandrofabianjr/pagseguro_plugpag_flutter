import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pagseguro_plugpag_flutter/pagseguro_plugpag_flutter.dart';
import 'package:provider/provider.dart';

import 'transaction_result_widget.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlugPagPaymentController(),
      child: Consumer<PlugPagPaymentController>(
        builder: (context, controller, child) {
          final state = controller.state;
          switch (state.status) {
            case PlugPagPaymentControllerStatus.ready:
              return child!;
            case PlugPagPaymentControllerStatus.digitPassword:
              return PaymentPageCenteredWidget([
                const Text('Digite sua senha:'),
                Text(state.hiddenPassword),
                TextButton(
                  onPressed: controller.abort,
                  child: const Text('Cancelar'),
                )
              ]);
            case PlugPagPaymentControllerStatus.loading:
              return PaymentPageCenteredWidget([
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(state.message ?? 'Aguarde'),
                TextButton(
                  onPressed: controller.abort,
                  child: const Text('Cancelar'),
                )
              ]);
            case PlugPagPaymentControllerStatus.finished:
              return TransactionResultWidget(state.transactionResult!);
            case PlugPagPaymentControllerStatus.error:
            case PlugPagPaymentControllerStatus.aborted:
              return PaymentPageCenteredWidget([
                Text(
                  state.status == PlugPagPaymentControllerStatus.aborted
                      ? 'Transação cancelada'
                      : 'Erro:',
                ),
                if (state.hasCode) Text(state.code!),
                if (state.hasMessage) Text(state.message!),
                TextButton(
                  onPressed: controller.restart,
                  child: const Text('Tentar novamente'),
                ),
              ]);
          }
        },
        child: const PaymentFormWidget(),
      ),
    );
  }
}

class PaymentPageCenteredWidget extends StatelessWidget {
  const PaymentPageCenteredWidget(this.children, {super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento com Cartão')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

extension on PlugPagPaymentDataType {
  String get name => switch (this) {
        PlugPagPaymentDataType.credito => 'Crédito',
        PlugPagPaymentDataType.debito => 'Débito',
        PlugPagPaymentDataType.voucher => 'Voucher (vale refeição)',
        PlugPagPaymentDataType.pix => 'Pix',
        PlugPagPaymentDataType.preautoCard => 'Pré-autorização via cartão',
        PlugPagPaymentDataType.preautoKeyed => 'Pré-autorização por digitação',
        PlugPagPaymentDataType.qrCode => 'QrCode Débito',
        PlugPagPaymentDataType.qrcodeCredito => 'QrCode Crédito',
      };
}

extension on PlugPagPaymentDataInstallmentType {
  String get name => switch (this) {
        PlugPagPaymentDataInstallmentType.aVista => 'À vista',
        PlugPagPaymentDataInstallmentType.parcVendedor => 'Sem juros',
        PlugPagPaymentDataInstallmentType.parcComprador => 'Com juros',
      };
}

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

class PaymentFormWidget extends StatefulWidget {
  const PaymentFormWidget({super.key});

  @override
  State<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState extends State<PaymentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final dropdownState = GlobalKey<FormFieldState>();
  var type = PlugPagPaymentDataType.credito;
  var amount = 0.0;
  var userReference = 'houston42';
  var installmentType = PlugPagPaymentDataInstallmentType.aVista;
  List<PlugPagInstallment> installmentOptions = [];
  var installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY;
  bool loadingInstallments = false;

  void _calculateInstallments(PlugPagPaymentDataInstallmentType value) async {
    if (value == PlugPagPaymentDataInstallmentType.aVista) {
      return setState(() {
        installmentOptions = [];
        installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY;
        installmentType = PlugPagPaymentDataInstallmentType.aVista;
      });
    }
    setState(() {
      loadingInstallments = true;
      installmentOptions = [];
      installmentType = value;
      installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY;
    });
    context
        .read<PlugPagPaymentController>()
        .calculateInstallments(amount, value)
        .then((value) {
      if (value.isEmpty) {
        installmentType = PlugPagPaymentDataInstallmentType.aVista;
      } else {
        installments = value.first.quantity;
      }
      installmentOptions = value;
    }).whenComplete(
      () => setState(() {
        loadingInstallments = false;
        dropdownState.currentState?.didChange(installmentType);
      }),
    );
  }

  void _doPayment() {
    if (_formKey.currentState?.validate() == true) {
      context.read<PlugPagPaymentController>().doPayment(
            PlugPagPaymentData.fromDoubleAmount(
              type: type,
              amount: amount,
              userReference: userReference,
              installmentType: installmentType,
              installments: installments,
              printReceipt: true,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo pagamento')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                DropdownButtonFormField<PlugPagPaymentDataType>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tipo',
                  ),
                  value: type,
                  items: PlugPagPaymentDataType.values
                      .map(
                        (e) => DropdownMenuItem<PlugPagPaymentDataType>(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    type = value!;
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: amount.toString().asBRL,
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
                      (_, newValue) =>
                          TextEditingValue(text: newValue.text.asBRL),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      amount = value.asDouble;
                      installments = PlugPag.A_VISTA_INSTALLMENT_QUANTITY;
                      installmentType =
                          PlugPagPaymentDataInstallmentType.aVista;
                      dropdownState.currentState?.didChange(installmentType);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: userReference,
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
                    return (value ?? '').isNotEmpty
                        ? null
                        : 'Não pode ser vazio';
                  },
                  onChanged: (value) => setState(() => userReference = value),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<PlugPagPaymentDataInstallmentType>(
                  key: dropdownState,
                  value: installmentType,
                  items: PlugPagPaymentDataInstallmentType.values
                      .map((e) =>
                          DropdownMenuItem<PlugPagPaymentDataInstallmentType>(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: loadingInstallments
                      ? null
                      : (value) => _calculateInstallments(value!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Parcelamento',
                  ),
                ),
                const SizedBox(height: 16),
                if (loadingInstallments)
                  const Center(child: CircularProgressIndicator()),
                if (!loadingInstallments &&
                    installmentType !=
                        PlugPagPaymentDataInstallmentType.aVista &&
                    installmentOptions.isEmpty)
                  const Text('Parcelamento não disponível'),
                if (!loadingInstallments && installmentOptions.isNotEmpty)
                  DropdownButtonFormField<int>(
                    value: installmentOptions.first.quantity,
                    items: installmentOptions
                        .map((e) => DropdownMenuItem<int>(
                              value: e.quantity,
                              child: Text(
                                  '${e.quantity} x ${e.amount.toString().asBRL.toString().asBRL} = ${e.total.toString().asBRL}'),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => installments = value!),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Número de parcelas',
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _doPayment,
                  child: const Text('Pagar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
