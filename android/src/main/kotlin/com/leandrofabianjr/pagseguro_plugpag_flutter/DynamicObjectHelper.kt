package com.leandrofabianjr.pagseguro_plugpag_flutter

import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getErrorCodeOrUnknown
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getMessageOrUnknown
import java.lang.reflect.InvocationHandler
import java.lang.reflect.Proxy
import kotlin.reflect.full.memberProperties

class DynamicObjectHelper(
    private val methodArguments: Any?,
    private val onResponse: (method: String, arguments: Any?) -> Unit,
) {

    companion object {
        private const val PPF_CLASS = "ppf_class"
        private const val PPF_ARGS = "ppf_args"
        private const val PPF_DATA_CLASS = "ppf_data_class"
        private const val PPF_DATA_CLASS_PARAMS = "ppf_data_class_params"
        private const val PPF_LISTENER_CLASS = "ppf_listener_class"
        private const val PPF_LISTENER_HASH = "ppf_listener_hash"
        private const val PPF_INVOKE_LISTENER = "ppf_invoke_listener"
        private const val PPF_INVOKE_LISTENER_METHOD = "ppf_invoke_listener_method"
        private const val PPF_INVOKE_LISTENER_METHOD_ARGS = "ppf_invoke_listener_method_args"
        private const val PPF_ERROR = "ppf_error"
        private const val PPF_ERROR_CODE = "ppf_error_code"
        private const val PPF_ERROR_MESSAGE = "ppf_error_message"
        private const val PPF_ERROR_DETAILS = "ppf_error_details"

        fun objectOrArrayToMethodChannel(obj: Any?): Any? {
            if (obj == null) return null
            return if (obj is ArrayList<*> || obj::class.java.isArray) {
                val arr = mutableListOf<Any?>()
                val objArray = if (obj is ArrayList<*>) obj.toArray() else obj as Array<*>
                for (o in objArray) {
                    if (o == null) {
                        arr.add(null)
                    } else {
                        arr.add(objectOrArrayToMethodChannel(o))
                    }
                }
                arr
            } else {
                if (obj is Char) return obj.code

                if (obj is Boolean || obj is Int || obj is Long || obj is Double || obj is String || obj::class.memberProperties.isEmpty()) {
                    return obj
                }

                val map = HashMap<String, Any?>()
                for (prop in obj::class.memberProperties) {
                    val propValue = prop.getter.call(obj)
                    map[prop.name] = objectOrArrayToMethodChannel(propValue)
                }

                return hashMapOf(PPF_CLASS to obj::class.qualifiedName, PPF_ARGS to map)
            }
        }

        fun sendCustomException(
            e: Exception, onResponse: (method: String, arguments: Any?) -> Unit
        ) {
            onResponse(
                PPF_ERROR, hashMapOf(
                    PPF_ERROR_CODE to e.getErrorCodeOrUnknown(),
                    PPF_ERROR_MESSAGE to e.getMessageOrUnknown(),
                    PPF_ERROR_DETAILS to e.stackTraceToString(),
                )
            )
        }
    }

    init {
        processParams()
    }

    lateinit var methodParametersTypes: Array<Class<out Any>?>
        private set

    lateinit var methodParameters: Array<Any?>
        private set

    private fun convertToJavaType(p: Any?) = when (p?.javaClass?.name) {
        "java.lang.Integer" -> Integer.TYPE
        else -> p?.javaClass
    }

    private fun processParams() {
        val params = mutableListOf<Any?>()
        val paramsTypes = mutableListOf<Class<out Any>?>()

        if (methodArguments is ArrayList<*>) {
            for (arg in methodArguments) {
                if (arg is HashMap<*, *>) {
                    if (arg.containsKey(PPF_DATA_CLASS)) {
                        val obj = instantiateDataObject(arg)
                        params.add(obj)
                        paramsTypes.add(convertToJavaType(obj))
                    } else if (arg.containsKey(PPF_LISTENER_CLASS)) {
                        params.add(instantiateListenerObject(arg))
                        paramsTypes.add(Class.forName(arg[PPF_LISTENER_CLASS] as String))
                    }
                } else {
                    params.add(arg)
                    paramsTypes.add(convertToJavaType(arg))
                }
            }
        }
        methodParameters = params.toTypedArray()
        methodParametersTypes = paramsTypes.toTypedArray()
    }

    private fun instantiateDataObject(argMap: Map<*, *>): Any {
        val className = argMap[PPF_DATA_CLASS] as? String
        if (className !== null) {
            val classInvoker = Class.forName(className)
            if (argMap.containsKey(PPF_DATA_CLASS_PARAMS)) {
                val classConstructorParams = argMap[PPF_DATA_CLASS_PARAMS] as ArrayList<*>
                for (constructor in classInvoker.constructors) {
                    try {
                        return constructor.newInstance(*classConstructorParams.toTypedArray())
                    } catch (_: Exception) {
                        // this loop tries to instantiate all declared constructors
                        // without throwing any exception
                    }
                }
            } else {
                return classInvoker.getDeclaredConstructor().newInstance()
            }
        }
        throw ClassNotFoundException()
    }

    private fun instantiateListenerObject(
        argMap: Map<*, *>,
    ): Any {
        val className = argMap[PPF_LISTENER_CLASS] as String
        val clazz = Class.forName(className)
        val invocationHandler = InvocationHandler { _, method, args ->
            try {
                onResponse(
                    PPF_INVOKE_LISTENER, hashMapOf(
                        PPF_LISTENER_HASH to argMap[PPF_LISTENER_HASH],
                        PPF_INVOKE_LISTENER_METHOD to method.name,
                        PPF_INVOKE_LISTENER_METHOD_ARGS to args.map {
                            objectOrArrayToMethodChannel(it)
                        },
                    )
                )
            } catch (e: Exception) {
                sendCustomException(e, onResponse)
            }
        }
        return Proxy.newProxyInstance(clazz.classLoader, arrayOf(clazz), invocationHandler);
    }
}