package com.dmc.eris.eirs.provider

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.util.Log
import com.dmc.eris.eirs.R
import com.dmc.eris.eirs.model.BatteryInfo
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow

class BatteryDataProvider constructor(private val context: Context) {

    /**
     * @return [Intent] with battery information
     */
    private fun getBatteryStatusIntent(): Intent? {
        val iFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        return context.registerReceiver(null, iFilter)
    }

    private fun getBatteryLevel(batteryStatus: Intent?): String {
        val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: return ""
        val scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: return ""
        val batteryPct = (level / scale.toFloat()) * 100
        return "${batteryPct.round2()}%"
    }

    private fun getBatteryHealth(batteryStatus: Intent?): String {
        val health = batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: return ""
        return getBatteryHealthStatus(health)
    }

    private fun getBatteryVoltage(batteryStatus: Intent?): String {
        val voltage = batteryStatus?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: return ""
        return "${voltage / 1000.0}V"
    }

    private fun getBatteryTemperature(): String {
        val iFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        val batteryStatus = context.registerReceiver(null, iFilter)
        val temperature = (
                batteryStatus?.getIntExtra(
                    BatteryManager.EXTRA_TEMPERATURE,
                    0
                ) ?: 0
                ) / 10

        return "%.2s".format(temperature.toFloat())
    }

    private fun getBatteryTechnology(batteryStatus: Intent?): String {
        return batteryStatus?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: ""
    }

    private fun getIsCharging(batteryStatus: Intent?): Boolean {
        val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: return false
        return status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
    }

    private fun getChargingType(batteryStatus: Intent?): String {
        val chargePlug = batteryStatus?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) ?: return ""
        val usbCharge = chargePlug == BatteryManager.BATTERY_PLUGGED_USB
        val acCharge = chargePlug == BatteryManager.BATTERY_PLUGGED_AC
        return when {
            usbCharge -> "USB"
            acCharge -> "AC"
            else -> "Unknown"
        }
    }

    @SuppressLint("PrivateApi")
    private fun getBatteryCapacity(): String {
        var capacity = -1.0
        try {
            val powerProfile = Class.forName("com.android.internal.os.PowerProfile")
                .getConstructor(Context::class.java).newInstance(context)
            capacity = Class
                .forName("com.android.internal.os.PowerProfile")
                .getMethod("getAveragePower", String::class.java)
                .invoke(powerProfile, "battery.capacity") as Double
        } catch (e: Exception) {
            Log.e("Error", "occurred", e)
        }
        return "${capacity.toFloat().round2()}mAh"
    }

    private fun getBatteryHealthStatus(healthInt: Int): String {
        return when (healthInt) {
            BatteryManager.BATTERY_HEALTH_COLD -> context.resources.getString(R.string.battery_cold)
            BatteryManager.BATTERY_HEALTH_GOOD -> context.getString(R.string.battery_good)
            BatteryManager.BATTERY_HEALTH_DEAD -> context.getString(R.string.battery_dead)
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> context.getString(R.string.battery_overheat)
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> context.getString(R.string.battery_overvoltage)
            BatteryManager.BATTERY_HEALTH_UNKNOWN -> context.getString(R.string.battery_unknown)
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> context.getString(R.string.battery_unspecified_failure)
            else -> context.getString(R.string.battery_unknown)
        }
    }

    fun getBatteryStatus() = flow {
        val batteryStatus = getBatteryStatusIntent()
        while (true) {
            emit(
                BatteryInfo(
                    level = getBatteryLevel(batteryStatus),
                    health = getBatteryHealth(batteryStatus),
                    voltage = getBatteryVoltage(batteryStatus),
                    temperature = getBatteryTemperature(),
                    capacity = getBatteryCapacity(),
                    technology = getBatteryTechnology(batteryStatus),
                    isCharging = getIsCharging(batteryStatus),
                    chargingType = getChargingType(batteryStatus)
                )
            )
            delay(1000)
        }
    }
}