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
import java.lang.reflect.InvocationHandler
import java.lang.reflect.Proxy
import kotlin.reflect.full.memberProperties

class PlugPagMethodCallHandler(context: Context, private val channel: MethodChannel) :
    MethodCallHandler {
    private val ppfDataClass = "ppf_data_class"
    private val ppfDataClassParams = "ppf_data_class_params"
    private val ppfListenerClass = "ppf_listener_class"
    private val ppfListenerHash = "ppf_listener_hash"
    private val ppfInvokeListener = "ppf_invoke_listener"
    private val ppfInvokeListenerMethod = "ppf_invoke_listener_method"
    private val ppfInvokeListenerMethodArgs = "ppf_invoke_listener_method_args"
    private val ppfError = "ppf_error"

    private val plugPag: PlugPag

    init {
        plugPag = PlugPag(context)
    }

    private fun getJavaType(p: Any?) = when (p?.javaClass?.name) {
        "java.lang.Integer" -> Integer.TYPE
        else -> p?.javaClass
    }

    private fun instantiateDataObject(argMap: Map<*, *>): Any {
        val className = argMap[ppfDataClass] as? String
        if (className !== null) {
            val classInvoker = Class.forName(className)
            if (argMap.containsKey(ppfDataClassParams)) {
                val classConstructorParams = argMap[ppfDataClassParams] as ArrayList<*>
                val classConstructorParamsTypes = classConstructorParams.map { p -> getJavaType(p) }
                return classInvoker
                    .getDeclaredConstructor(*classConstructorParamsTypes.toTypedArray())
                    .newInstance(*classConstructorParams.toTypedArray())
            }
            return classInvoker.getDeclaredConstructor().newInstance()
        }
        throw ClassNotFoundException()
    }

    private fun typetoMethodChannel(obj: Any?): Any? {
        if (obj is String || obj is Int || obj is Boolean || obj == null) {
            return obj
        }
        return toHashMap(obj).ifEmpty { obj }
    }

    private fun objectToMethodChannel(obj: Any?): Any? {
        if (obj == null) return null
        return if (obj::class.java.isArray) {
            val arr = mutableListOf<Any?>()
            for (o in obj as Array<*>) {
                arr.add(typetoMethodChannel(o))
            }
            arr
        } else {
            typetoMethodChannel(obj)
        }
    }

    private fun instantiateListenerObject(
        argMap: Map<*, *>
    ): Any {
        val className = argMap[ppfListenerClass] as String
        val clazz = Class.forName(className)

        val handler = InvocationHandler { _, method, args ->
            try {
                val res = hashMapOf(
                    ppfListenerHash to argMap[ppfListenerHash],
                    ppfInvokeListenerMethod to method.name,
                    ppfInvokeListenerMethodArgs to args.map { objectToMethodChannel(it) }
                )
                channel.invokeMethod(ppfInvokeListener, res)
            } catch (e: Exception) {
                channel.invokeMethod(
                    ppfError, hashMapOf(
                        "errorCode" to e.getErrorCodeOrUnknown(),
                        "message" to e.getMessageOrUnknown(),
                        "stackTrace" to e.stackTraceToString(),
                    )
                )
            }
        }

        return Proxy.newProxyInstance(clazz.classLoader, arrayOf(clazz), handler);
    }

    private fun toHashMap(obj: Any?): HashMap<String, Any?> {
        val map = HashMap<String, Any?>()
        if (obj == null) return map

        for (prop in obj::class.memberProperties) {
            map[prop.name] = prop.getter.call(obj)
        }
        return map
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val (plugPagMethodParams, plugPagMethodParamsTypes) = processParams(call.arguments)
            val plugPagMethod = PlugPag::class.java.getMethod(
                call.method,
                *plugPagMethodParamsTypes.toTypedArray()
            )

            CoroutineScope(Dispatchers.IO).launch {
                kotlin.runCatching {
                    plugPagMethod.invoke(plugPag, *plugPagMethodParams.toTypedArray())
                }.onSuccess {
                    result.success(objectToMethodChannel(it))
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

    private fun processParams(callArguments: Any): Pair<MutableList<Any?>, MutableList<Class<out Any>?>> {
        val params = mutableListOf<Any?>()
        val paramsTypes = mutableListOf<Class<out Any>?>()
        if (callArguments is ArrayList<*>) {
            for (arg in callArguments) {
                if (arg is HashMap<*, *>) {
                    if (arg.containsKey(ppfDataClass)) {
                        val obj = instantiateDataObject(arg)
                        params.add(obj)
                        paramsTypes.add(getJavaType(obj))
                    } else if (arg.containsKey(ppfListenerClass)) {
                        params.add(instantiateListenerObject(arg))
                        paramsTypes.add(Class.forName(arg[ppfListenerClass] as String))
                    }
                } else {
                    params.add(arg)
                    paramsTypes.add(getJavaType(arg))
                }
            }
        }
        return params to paramsTypes
    }
}