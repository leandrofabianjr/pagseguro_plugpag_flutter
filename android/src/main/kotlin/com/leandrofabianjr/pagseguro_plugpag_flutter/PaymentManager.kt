//package br.com.oticket.oticket_pagseguro_android
//
//import androidx.lifecycle.ViewModel
//import androidx.lifecycle.viewModelScope
//import br.com.uol.pagseguro.plugpagservice.wrapper.*
//import kotlinx.coroutines.Dispatchers
//import kotlinx.coroutines.launch
//import kotlinx.coroutines.withContext
//
//class PaymentVariables(map: HashMap<String, Any>) {
//    val amount: Int by map
//    val installments: Int? by map
//}
//
//class PaymentManager(
//    private val plugPag: PlugPag,
//    private val response: OticketResponse,
//    private val vars: PaymentVariables
//) : ViewModel() {
//
//    private var passwordDigitsCounter = 0
//
//    @Throws
//    fun startTerminalDebitPayment() {
//        val paymentData =
//            PlugPagPaymentData(
//                PlugPag.TYPE_DEBITO,
//                vars.amount,
//                PlugPag.INSTALLMENT_TYPE_A_VISTA,
//                vars.installments ?: 1,
//                "OTICKET",
//                true
//            )
//        startTerminalPayment(paymentData)
//    }
//
//    @Throws
//    fun startTerminalCreditPayment() {
//        val installments = vars.installments ?: 1
//        val type =
//            if (installments > 1) PlugPag.INSTALLMENT_TYPE_PARC_COMPRADOR else PlugPag.INSTALLMENT_TYPE_A_VISTA
//        val paymentData =
//            PlugPagPaymentData(
//                PlugPag.TYPE_CREDITO,
//                vars.amount,
//                type,
//                installments,
//                "OTICKET",
//                true
//            )
//        startTerminalPayment(paymentData)
//    }
//
//    @Throws
//    fun startTerminalPixPayment() {
//        val paymentData = PlugPagPaymentData(
//            PlugPag.TYPE_PIX,
//            vars.amount,
//            PlugPag.INSTALLMENT_TYPE_A_VISTA,
//            1,
//            "OTICKET",
//            true,
//        )
//        startTerminalPayment(paymentData)
//    }
//
//    @Throws
//    private fun startTerminalPayment(paymentData: PlugPagPaymentData) {
//        viewModelScope.launch(Dispatchers.Main) {
//            // response.onSuccess(
//            //     (1..10).map { ('0'..'9').random() }.joinToString("")
//            // )
//
//           val result = withContext(Dispatchers.IO) {
//               setCustomPrinterDialog()
//               setListener()
//               setPrintListener()
//
//               plugPag.doPayment(paymentData)
//           }
//           if (result.result == PlugPag.RET_OK) {
////                response.onSuccess(resultMessage(result));
//               response.onSuccess(result.transactionCode!!)
//           } else {
//               response.onError("(${result.errorCode}) ${result.message}")
//           }
//        }
//    }
//
//    @Throws
//    private fun setCustomPrinterDialog() {
//        val customDialog = PlugPagCustomPrinterLayout()
//        customDialog.title = "Imprimir via do cliente?"
//        customDialog.buttonBackgroundColor = "#0d1d2b"
//
//        plugPag.setPlugPagCustomPrinterLayout(customDialog)
//    }
//
//    @Throws
//    private fun setListener() {
//        plugPag.setEventListener(object : PlugPagEventListener {
//            override fun onEvent(data: PlugPagEventData) {
//                when (data.eventCode) {
//                    PlugPagEventData.EVENT_CODE_DIGIT_PASSWORD -> {
//                        passwordDigitsCounter++
//                        response.onPassword(passwordDigitsCounter)
//                    }
//                    PlugPagEventData.EVENT_CODE_NO_PASSWORD -> {
//                        passwordDigitsCounter = 0
//                        response.onPassword(passwordDigitsCounter)
//                    }
//                    else -> {
//                        if (data.customMessage != null) {
//                            response.onMessage(data.customMessage)
//                        }
//                    }
//                }
//            }
//        })
//    }
//
//    private fun setPrintListener() {
//        plugPag.setPrinterListener(PrinterListener(response))
//    }
//
//    class PrinterListener(private val response: OticketResponse) : PlugPagPrinterListener {
//        override fun onError(data: PlugPagPrintResult) {
//            response.onError("Erro de impressão: (${data.errorCode}) ${data.message}")
//        }
//
//        override fun onSuccess(data: PlugPagPrintResult) {}
//    }
//}