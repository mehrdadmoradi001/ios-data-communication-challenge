package com.example.zanis_data_communication

import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.nio.charset.StandardCharsets

class FlutterDataPlugin: FlutterPlugin, MethodCallHandler {
    // Method channel
    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private val dataCommunicationManager = DataCommunicationManager.getInstance()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.zanis.data_communication")
        channel.setMethodCallHandler(this)

        // Setup data listeners
        setupDataListeners()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "startDataListening" -> {
                dataCommunicationManager.startDataSimulation()
                result.success(true)
            }
            "stopDataListening" -> {
                dataCommunicationManager.stopDataSimulation()
                result.success(true)
            }
            "getDeviceInfo" -> {
                // Return device info
                val deviceInfo = HashMap<String, Any>().apply {
                    put("model", Build.MODEL)
                    put("systemVersion", Build.VERSION.RELEASE)
                    put("manufacturer", Build.MANUFACTURER)
                }
                result.success(deviceInfo)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun setupDataListeners() {
        // Add listener to DataCommunicationManager
        dataCommunicationManager.addDataListener { data ->
            try {
                // Convert byte array to JSON
                val jsonString = String(data, StandardCharsets.UTF_8)
                val jsonObject = JSONObject(jsonString)

                // Convert to Map for Flutter
                val map = HashMap<String, Any>()
                val keys = jsonObject.keys()
                while (keys.hasNext()) {
                    val key = keys.next()
                    map[key] = jsonObject.get(key)
                }

                // Send to Flutter
                channel.invokeMethod("onDataReceived", map)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        dataCommunicationManager.cleanup()
    }
}