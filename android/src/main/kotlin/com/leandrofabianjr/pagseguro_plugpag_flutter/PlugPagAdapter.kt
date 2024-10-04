package com.leandrofabianjr.pagseguro_plugpag_flutter

import android.content.Context
import br.com.uol.pagseguro.plugpagservice.wrapper.PlugPag
import br.com.uol.pagseguro.plugpagservice.wrapper.exception.PlugPagException
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getErrorCodeOrUnknown
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getMessageOrUnknown
import com.leandrofabianjr.pagseguro_plugpag_flutter.DynamicObjectHelper.Companion.PPF_PLUGPAG_ERROR
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class PlugPagAdapter(context: Context) {
    private val plugPag = PlugPag(context)

    fun callMethod(
        methodName: String,
        methodArguments: Any?,
        onSuccess: (result: Any?) -> Unit,
        onFailure: (errorCode: String,
                    errorMessage: String?,
                    errorDetails: Any?) -> Unit,
        onListenerResponse: (method: String, arguments: Any?) -> Unit,
    ) {
        val dynamicObj = DynamicObjectHelper(methodArguments, onListenerResponse)

        val plugPagMethod = PlugPag::class.java.getMethod(
            methodName, *dynamicObj.methodParametersTypes
        )

        CoroutineScope(Dispatchers.Main).launch {
            try {
                val res = withContext(Dispatchers.IO) {
                    plugPagMethod.invoke(plugPag, *dynamicObj.methodParameters)
                }
                val result = DynamicObjectHelper.objectOrArrayToMethodChannel(res)
                onSuccess(result)
            } catch (e: Exception) {
                if (e.cause is PlugPagException) {
                    val ppException = (e.cause as PlugPagException)
                    val code = PPF_PLUGPAG_ERROR;
                    val details = DynamicObjectHelper.objectOrArrayToMethodChannel(ppException)

                    onFailure(code, null, details)
                } else {
                    val code = e.getErrorCodeOrUnknown()
                    val message = e.getMessageOrUnknown()
                    val details = e.stackTraceToString()

                    onFailure(code, message, details)
                }
            }
        }
    }
}