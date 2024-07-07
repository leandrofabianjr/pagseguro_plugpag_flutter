package com.leandrofabianjr.pagseguro_plugpag_flutter

import android.content.Context
import br.com.uol.pagseguro.plugpagservice.wrapper.PlugPag
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PlugPagAdapter(context: Context) {
    private val plugPag = PlugPag(context)

    fun callMethod(
        methodName: String,
        methodArguments: Any?,
        onResult: (result: Any?) -> Unit,
        onListenerResponse: (method: String, arguments: Any?) -> Unit,
    ) {
        val dynamicObj = DynamicObjectHelper(methodArguments, onListenerResponse)

        val plugPagMethod = PlugPag::class.java.getMethod(
            methodName, *dynamicObj.methodParametersTypes
        )

        CoroutineScope(Dispatchers.IO).launch {
            kotlin.runCatching {
                plugPagMethod.invoke(plugPag, *dynamicObj.methodParameters)
            }.onSuccess {
                val result = DynamicObjectHelper.objectOrArrayToMethodChannel(it)
                onResult(result)
            }.onFailure {
                throw it
            }
        }
    }
}