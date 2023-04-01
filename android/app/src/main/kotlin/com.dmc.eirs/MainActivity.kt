package com.dmc.eirs

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val deviceInfoManager = DeviceInfoManager(this)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceInfo") {
                val deviceInfoList = deviceInfoManager.getDeviceInfo()

                if (!deviceInfoList.isNullOrEmpty()) {
                    result.success(deviceInfoList)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }


    companion object {
        private const val CHANNEL = "com.dmc.eris.eirs/deviceInfo"
    }
}
