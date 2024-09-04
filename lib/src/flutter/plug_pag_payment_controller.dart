import 'package:flutter/widgets.dart';

import '../plug_pag/plug_pag.dart';

enum PlugPagPaymentControllerStatus {
  ready,
  loading,
  digitPassword,
  error,
  finished,
  aborted,
}

class PlugPagPaymentControllerState {
  PlugPagPaymentControllerState({
    this.status = PlugPagPaymentControllerStatus.ready,
    this.code,
    this.message,
    this.passwordDigitsCounter = 0,
    this.transactionResult,
  })  : hasCode = code != null,
        hasMessage = message != null;

  final PlugPagPaymentControllerStatus status;
  final String? code, message;
  final bool hasCode, hasMessage;
  final int passwordDigitsCounter;
  final PlugPagTransactionResult? transactionResult;

  String get hiddenPassword =>
      List.generate(passwordDigitsCounter, (_) => '*').join();

  PlugPagPaymentControllerState copyWith({
    PlugPagPaymentControllerStatus? status,
    String? code,
    String? message,
    int? passwordDigitsCounter,
    PlugPagTransactionResult? transactionResult,
  }) {
    return PlugPagPaymentControllerState(
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      passwordDigitsCounter:
          passwordDigitsCounter ?? this.passwordDigitsCounter,
      transactionResult: transactionResult ?? this.transactionResult,
    );
  }
}

typedef _S = PlugPagPaymentControllerStatus;

class PlugPagPaymentController extends ChangeNotifier {
  final _plugPag = PlugPag();
  var state = PlugPagPaymentControllerState();
  late final _PlugPagPaymentEventListener _listener;

  PlugPagPaymentController() {
    _listener = _PlugPagPaymentEventListener(_onEvent);
    _plugPag.setEventListener(_listener);
    _plugPag.onException(_onError);
  }

  void _onEvent(PlugPagEventData data) {
    state = switch (data.eventCode) {
      PlugPagEventData.EVENT_CODE_DIGIT_PASSWORD => state.copyWith(
          status: _S.digitPassword,
          passwordDigitsCounter: state.passwordDigitsCounter + 1,
        ),
      PlugPagEventData.EVENT_CODE_NO_PASSWORD => state.copyWith(
          status: _S.digitPassword,
          passwordDigitsCounter: 0,
        ),
      _ => state.copyWith(
          status: _S.loading,
          message: data.customMessage,
          passwordDigitsCounter: 0,
        ),
    };
    notifyListeners();
  }

  void _onError(Object ex) {
    state = PlugPagPaymentControllerState(
      status: _S.error,
      message: ex.toString(),
    );
    notifyListeners();
  }

  void _onAbortResult(result) {
    state = PlugPagPaymentControllerState(
      status: result.result == PlugPag.RET_OK ? _S.aborted : _S.error,
    );
    notifyListeners();
  }

  void _onDoPaymentResult(PlugPagTransactionResult result) {
    state = switch (result.result) {
      PlugPag.RET_OK => PlugPagPaymentControllerState(
          status: _S.finished,
          transactionResult: result,
        ),
      PlugPag.OPERATION_ABORTED => PlugPagPaymentControllerState(
          status: _S.aborted,
        ),
      _ => PlugPagPaymentControllerState(
          status: _S.error,
          code: result.errorCode,
          message: result.message,
        ),
    };
    notifyListeners();
  }

  @override
  void dispose() {
    _plugPag.removeListener(_listener);
    _plugPag.onException(null);
    super.dispose();
  }

  void restart() {
    state = PlugPagPaymentControllerState();
    notifyListeners();
  }

  Future<List<PlugPagInstallment>> calculateInstallments(
    double amount,
    PlugPagPaymentDataInstallmentType installmentType,
  ) async {
    final a = await _plugPag.calculateInstallmentsFromDouble(
      saleValue: amount,
      installmentType: installmentType,
    );
    return a;
  }

  void doPayment(PlugPagPaymentData paymentData) {
    state = PlugPagPaymentControllerState(status: _S.loading);
    notifyListeners();
    _plugPag.doPayment(paymentData).then(_onDoPaymentResult);
  }

  void abort() {
    state = PlugPagPaymentControllerState(status: _S.loading);
    notifyListeners();
    _plugPag.abort().then(_onAbortResult);
  }

  void voidPayment(PlugPagVoidData voidData) {
    state = PlugPagPaymentControllerState(status: _S.loading);
    notifyListeners();
    _plugPag.voidPayment(voidData).then(_onDoPaymentResult);
  }
}

class _PlugPagPaymentEventListener extends PlugPagEventListener {
  final void Function(PlugPagEventData data) _onEvent;
  _PlugPagPaymentEventListener(void Function(PlugPagEventData data) onEvent)
      : _onEvent = onEvent;

  @override
  void onEvent(PlugPagEventData data) => _onEvent(data);
}
