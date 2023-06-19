package com.dmc.eirs.model

data class DeviceDetails(
        val deviceInfo: DeviceInfo?,
        val batteryInfo: BatteryInfo?,
        val displayInfo: DisplayInfo?,
        val memoryInfo: MemoryInfo?,
        val sensorInfo: SensorInfo?,
        val cameraInfo: CameraInfo?
) {

    private constructor(builder: Builder) : this(builder.deviceInfo, builder.batteryInfo, builder.displayInfo, builder.memoryInfo, builder.sensorInfo,builder.cameraInfo)

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

        var cameraInfo: CameraInfo? = null
            private set

        fun setDeviceInfo(deviceInfo: DeviceInfo) = apply { this.deviceInfo = deviceInfo }
        fun setBatteryInfo(batteryInfo: BatteryInfo) = apply { this.batteryInfo = batteryInfo }
        fun setDisplayInfo(displayInfo: DisplayInfo) = apply { this.displayInfo = displayInfo }
        fun setMemoryInfo(memoryInfo: MemoryInfo) = apply { this.memoryInfo = memoryInfo }
        fun setSensorInfo(sensorInfo: SensorInfo) = apply { this.sensorInfo = sensorInfo }
        fun setCameraInfo(cameraInfo: CameraInfo) = apply { this.cameraInfo = cameraInfo }

        fun build():DeviceDetails = DeviceDetails(this)
    }
}