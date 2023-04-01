package com.dmc.eirs.provider

import android.app.ActivityManager
import android.util.Log
import com.dmc.eirs.model.RamInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class RamDataProvider(
    private val activityManager: ActivityManager,
    private val settings: Settings
) {

    private fun getTotalBytes(): Long {
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        return memoryInfo.totalMem
    }

    private fun getAvailableBytes(): Long {
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        return memoryInfo.availMem
    }

    private fun getAvailablePercentage(): Int {
        val total = getTotalBytes().toDouble()
        val available = getAvailableBytes().toDouble()
        return (available / total * 100).toInt()
    }

    private fun getThreshold(): Long {
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        return memoryInfo.threshold
    }

    fun getRamInformation(): Flow<RamInfo> = flow {
        while (true) {
            val total = getTotalBytes()
            val available = getAvailableBytes()
            val availablePercentage = getAvailablePercentage()
            val threshold = getThreshold()
            emit(RamInfo(total, available, availablePercentage, threshold))
            Log.e("ram freq", settings.ramRefreshRate.toString())

            delay(settings.ramRefreshRate)
        }
    }.distinctUntilChanged()
        .flowOn(Dispatchers.IO)
}