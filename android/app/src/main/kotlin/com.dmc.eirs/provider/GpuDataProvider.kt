package com.dmc.eirs.provider

import android.app.ActivityManager

class GpuDataProvider(
    private val activityManager: ActivityManager
) {

    /**
     * Returns the GLES version of the device as a string.
     *
     * @return A string representation of the GLES version on the device.
     */
    fun getGlEsVersion(): String {
        return activityManager.deviceConfigurationInfo.glEsVersion
    }
}