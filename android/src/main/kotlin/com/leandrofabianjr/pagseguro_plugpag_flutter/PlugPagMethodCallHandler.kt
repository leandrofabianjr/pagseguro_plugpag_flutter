package com.leandrofabianjr.pagseguro_plugpag_flutter

import android.content.Context
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getErrorCodeOrUnknown
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getMessageOrUnknown
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class PlugPagMethodCallHandler(
    context: Context,
    private val invokeMethod: (method: String, arguments: Any?) -> Unit,
) : MethodCallHandler {
    private val adapter = PlugPagAdapter(context)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {

            adapter.callMethod(
                methodArguments = call.arguments,
                methodName = call.method,
                onListenerResponse = invokeMethod,
                onResult = result::success,
            )

        } catch (e: Exception) {
            when (e) {
                is NoSuchFieldException, is NoSuchMethodException, is ClassNotFoundException -> {
                    result.notImplemented()
                }

                else -> {
                    result.error(
                        e.getErrorCodeOrUnknown(), e.getMessageOrUnknown(), e.stackTraceToString()
                    )
                    DynamicObjectHelper.sendCustomException(e, invokeMethod)
                }
            }
        }
    }
}