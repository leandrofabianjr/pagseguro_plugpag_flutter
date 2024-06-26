package com.leandrofabianjr.pagseguro_plugpag_flutter

import br.com.uol.pagseguro.plugpagservice.wrapper.PlugPag
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getErrorCodeOrUnknown
import br.com.uol.pagseguro.plugpagservice.wrapper.extensions.getMessageOrUnknown
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlin.reflect.full.memberProperties

/** PagseguroPlugpagFlutterPlugin */
class PagseguroPlugpagFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var plugPag: PlugPag

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pagseguro_plugpag_flutter")
        channel.setMethodCallHandler(this)
        plugPag = PlugPag(flutterPluginBinding.applicationContext)
    }

    private inline fun <reified T : Any> T.toMethodChannel(): Map<String, Any?> {
        val props = T::class.memberProperties.associateBy { it.name }
        return props.keys.associateWith { props[it]?.get(this) }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        try {
            fun instantiateDynamicClass(argMap: Map<*, *>): Any {
                val possibleClassName = argMap["ppf_class"] as? String
                if (possibleClassName !== null) {
                    val realClassName = Class.forName(possibleClassName)
                    if (argMap.containsKey("ppf_params")) {
                        val constructorParams = argMap["ppf_params"] as ArrayList<*>;
                        val constructorParamsTypes = constructorParams.map { p -> p?.javaClass }
                        return realClassName
                            .getDeclaredConstructor(*constructorParamsTypes.toTypedArray())
                            .newInstance(*constructorParams.toTypedArray())
                    }
                    return realClassName.getDeclaredConstructor().newInstance()
                }
                throw ClassNotFoundException()
            }

            fun <T : Any> toHashMap(obj: T): HashMap<String, Any?> {
                val map = HashMap<String, Any?>()
                for (prop in obj::class.memberProperties) {
                    map[prop.name] = prop.getter.call(obj)
                }
                return map
            }

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

            val paramsTypes = params.map { p -> p?.javaClass }

            val method = PlugPag::class.java.getMethod(call.method, *paramsTypes.toTypedArray())

            CoroutineScope(Dispatchers.IO).launch {
                kotlin.runCatching {

//                        commandsByName[method]?.invoke(message) ?: error("Unknown method: $method")
//                        plugPag.initializeAndActivatePinpad(PlugPagActivationData("749879"))
                    if (params.isEmpty()) {
                        method.invoke(plugPag)
                    } else {
                        method.invoke(plugPag, *params.toTypedArray())
                    }
                }.onSuccess {
                    val map = toHashMap(it)
                    if (map.isNotEmpty()) {
                        result.success(map)
                    } else {
                        result.success(it)
                    }
                }.onFailure {
                    result.error(it.getErrorCodeOrUnknown(), it.getMessageOrUnknown(), null)
                }
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

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
