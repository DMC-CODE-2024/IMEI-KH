package com.dmc.eirs.model

import android.hardware.Sensor

data class SensorInfo(
        val sensorList: List<Sensor>,
        val totalNumberSensor: Int,
        val sensorDetails :ArrayList<SensorDetails>
)

data class SensorDetails(
        val sensorName:String,
        val sensorVendor: String,
        val sensorVersion: Int,
        val sensorResolution: Float,
        val sensorPower: Float,
        val sensorMaximumRange: Float,
)
