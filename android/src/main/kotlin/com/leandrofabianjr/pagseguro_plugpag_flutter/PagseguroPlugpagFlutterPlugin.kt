package com.leandrofabianjr.pagseguro_plugpag_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** PagseguroPlugpagFlutterPlugin */
class PagseguroPlugpagFlutterPlugin : FlutterPlugin {
    private val CHANNEL = "pagseguro_plugpag_flutter_channel"

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(
            PlugPagInvokerMethodChannel(flutterPluginBinding.applicationContext)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
