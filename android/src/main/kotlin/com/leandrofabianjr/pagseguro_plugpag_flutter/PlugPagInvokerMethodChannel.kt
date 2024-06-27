package com.leandrofabianjr.pagseguro_plugpag_flutter

import android.content.Context
import br.com.uol.pagseguro.plugpagservice.wrapper.PlugPag
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getErrorCodeOrUnknown
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getMessageOrUnknown
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlin.reflect.full.memberProperties

class PlugPagInvokerMethodChannel(context: Context) : MethodCallHandler {
    private val plugPag: PlugPag

    init {
        plugPag = PlugPag(context)
    }

    private fun instantiateDynamicClass(argMap: Map<*, *>): Any {
        val className = argMap["ppf_class"] as? String
        if (className !== null) {
            val classInvoker = Class.forName(className)
            if (argMap.containsKey("ppf_params")) {
                val classConstructorParams = argMap["ppf_params"] as ArrayList<*>;
                return classInvoker
                    .getDeclaredConstructor(
                        *classConstructorParams.map { p -> p?.javaClass }.toTypedArray()
                    )
                    .newInstance(*classConstructorParams.toTypedArray())
            }
            return classInvoker.getDeclaredConstructor().newInstance()
        }
        throw ClassNotFoundException()
    }

    private fun <T : Any> toHashMap(obj: T): HashMap<String, Any?> {
        val map = HashMap<String, Any?>()
        for (prop in obj::class.memberProperties) {
            map[prop.name] = prop.getter.call(obj)
        }
        return map
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val plugPagMethodParams = processParams(call)
            val plugPagMethod = PlugPag::class.java.getMethod(
                call.method,
                *plugPagMethodParams.map { p -> p?.javaClass }.toTypedArray()
            )

            CoroutineScope(Dispatchers.IO).launch {
                kotlin.runCatching {
                    plugPagMethod.invoke(plugPag, *plugPagMethodParams.toTypedArray())
                }.onSuccess {
                    result.success(toHashMap(it).ifEmpty { it })
                }.onFailure { throw it }
            }

        } catch (e: NoSuchFieldException) {
            result.notImplemented()
        } catch (e: NoSuchMethodException) {
            result.notImplemented()
        } catch (e: ClassNotFoundException) {
            result.notImplemented()
        } catch (e: Exception) {
            result.error(e.getErrorCodeOrUnknown(), e.getMessageOrUnknown(), null)
        }
    }

    private fun processParams(call: MethodCall): MutableList<Any?> {
        val params = mutableListOf<Any?>()

        if (call.arguments is ArrayList<*>) {
            val arguments = call.arguments as ArrayList<*>
            for (arg in arguments) {
                if (arg is HashMap<*, *>) {
                    if (arg.containsKey("ppf_class")) {
                        params.add(instantiateDynamicClass(arg))
                    }
                } else {
                    params.add(arg)
                }
            }
        }
        return params
    }

}