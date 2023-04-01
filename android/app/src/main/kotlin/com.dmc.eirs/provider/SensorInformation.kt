package com.dmc.eirs.provider

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager


class SensorInformation(private val context: Context) {
    /**
     * It will return all the sensors list available in the device.
     * TO get power/version/resolution/vendor etc  of these sensors,
     * use for-each to get sensor one by one and use other methods
     * @return all sensors in List<Sensor>
    </Sensor> */
    val sensorList: List<Sensor>
        get() {
            val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
            return sensorManager.getSensorList(Sensor.TYPE_ALL)
        }

    /**
     * It will return the total number of sensors in the device
     * @return sensor's counts in int
     */
    fun getTotalNumberOfSensors(): Int {
        return sensorList.size
    }

    /**
     * It will return the sensor's vendor
     * @param sensor
     * @return sensor's vendor in String
     */
    fun getSensorVendor(sensor: Sensor): String {
        return sensor.vendor
    }

    /**
     * It will return the sensor's version
     * @param sensor
     * @return sensor's version in the int
     */
    fun getSensorVersion(sensor: Sensor): Int {
        return sensor.version
    }

    /**
     * It will return the sensor's resolution
     * @param sensor
     * @return sensor's resolution in float
     */
    fun getSensorResolution(sensor: Sensor): Float {
        return sensor.resolution
    }

    /**
     * It will return the sensor's power
     * @param sensor
     * @return sensor's power in float( in mAh)
     */
    fun getSensorPower(sensor: Sensor): Float {
        return sensor.power
    }

    /**
     * It will return the sensor's maximum range in float
     * @param sensor
     * @return sensor's maximum range in float
     */
    fun getSensorMaximumRange(sensor: Sensor): Float {
        return sensor.maximumRange
    }

    /**
     * It will return name of sensor from sensor
     * I've used switch-case and compared with sensor type to give String name
     * @param sensor
     * @return Sensor name in String
     */
    fun getSensorName(sensor: Sensor): String {
        val sensorType = sensor.type
        return when (sensorType) {
            Sensor.TYPE_ACCELEROMETER -> "Accelerometer"
            Sensor.TYPE_AMBIENT_TEMPERATURE -> "Ambient Temperature"
            Sensor.TYPE_GAME_ROTATION_VECTOR -> "Game Rotation Vector"
            Sensor.TYPE_GRAVITY -> "Gravity"
            Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR -> "Geomagnetic Rotation Vector"
            Sensor.TYPE_GYROSCOPE -> "Gyroscope"
            Sensor.TYPE_HEART_BEAT -> "Heart Beat"
            Sensor.TYPE_HEART_RATE -> "Heart Rate"
            Sensor.TYPE_LIGHT -> "Light"
            Sensor.TYPE_LINEAR_ACCELERATION -> "Linear Acceleration"
            Sensor.TYPE_MAGNETIC_FIELD -> "Magnetic Field"
            Sensor.TYPE_PRESSURE -> "Pressure"
            Sensor.TYPE_RELATIVE_HUMIDITY -> "Humidity"
            Sensor.TYPE_ROTATION_VECTOR -> "Rotation Vector"
            Sensor.TYPE_STEP_COUNTER -> "Step Counter"
            Sensor.TYPE_SIGNIFICANT_MOTION -> "Significant Motion"
            Sensor.TYPE_STEP_DETECTOR -> "Step Detector"
            else -> "Unknown"
        }
    }
}