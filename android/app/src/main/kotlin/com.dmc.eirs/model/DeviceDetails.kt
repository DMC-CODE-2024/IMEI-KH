package com.dmc.eirs.model

data class DeviceDetails(
        val deviceInfo: DeviceInfo?,
        val batteryInfo: BatteryInfo?,
        val displayInfo: DisplayInfo?,
        val memoryInfo: MemoryInfo?,
        val sensorInfo: SensorInfo?
) {

    private constructor(builder: Builder) : this(builder.deviceInfo, builder.batteryInfo, builder.displayInfo, builder.memoryInfo, builder.sensorInfo)

    class Builder {
        var deviceInfo: DeviceInfo? = null
            private set

        var batteryInfo: BatteryInfo? = null
            private set

        var displayInfo: DisplayInfo? = null
            private set

        var memoryInfo: MemoryInfo? = null
            private set

        var sensorInfo: SensorInfo? = null
            private set

        fun setDeviceInfo(deviceInfo: DeviceInfo) = apply { this.deviceInfo = deviceInfo }
        fun setBatteryInfo(batteryInfo: BatteryInfo) = apply { this.batteryInfo = batteryInfo }
        fun setDisplayInfo(displayInfo: DisplayInfo) = apply { this.displayInfo = displayInfo }
        fun setMemoryInfo(memoryInfo: MemoryInfo) = apply { this.memoryInfo = memoryInfo }
        fun setSensorInfo(sensorInfo: SensorInfo) = apply { this.sensorInfo = sensorInfo }

        fun build():DeviceDetails = DeviceDetails(this)
    }
}