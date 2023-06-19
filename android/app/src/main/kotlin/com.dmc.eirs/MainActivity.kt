package com.dmc.eirs

import android.os.Build
import androidx.annotation.RequiresApi
import androidx.lifecycle.lifecycleScope
import com.dmc.eirs.model.DeviceDetails
import com.dmc.eirs.provider.*
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val batteryInfo: BatteryDataProvider by lazy { BatteryDataProvider(this) }
    private val cameraInfo: CameraDataProvider by lazy { CameraDataProvider(this) }
    private val deviceInfo: DeviceDataProvider by lazy { DeviceDataProvider(this) }
    private val displayInfo: DisplayDataProvider by lazy { DisplayDataProvider(this) }
    private val memoryInfo: MemoryDataProvider by lazy { MemoryDataProvider(this) }
    private val sensorInfo: SensorDataProvider by lazy { SensorDataProvider(this) }
    private val deviceDetailsBuilder = DeviceDetails.Builder()

    @RequiresApi(Build.VERSION_CODES.R)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceInfo") {
                lifecycleScope.launch {
                    batteryInfo.getBatteryStatus().collect { batteryInfo ->
                        deviceDetailsBuilder.setBatteryInfo(batteryInfo)
                    }
                    deviceInfo.getDeviceInfo().collect { deviceInfo ->
                        deviceDetailsBuilder.setDeviceInfo(deviceInfo)
                    }
                    displayInfo.getDisplayInfo().collect { displayInfo ->
                        deviceDetailsBuilder.setDisplayInfo(displayInfo)
                    }
                    memoryInfo.getMemoryInfo().collect { memoryInfo ->
                        deviceDetailsBuilder.setMemoryInfo(memoryInfo)
                    }
                    sensorInfo.getSensorInfo().collect { sensorInfo ->
                        deviceDetailsBuilder.setSensorInfo(sensorInfo)
                    }
                    cameraInfo.getCameraInformation().collect{cameraInfo->
                        deviceDetailsBuilder.setCameraInfo(cameraInfo)
                    }
                }
                result.success(Gson().toJson(deviceDetailsBuilder.build()))
            } else {
                result.notImplemented()
            }
        }
    }


    companion object {
        private const val CHANNEL = "com.dmc.eirs/deviceInfo"
    }
}
