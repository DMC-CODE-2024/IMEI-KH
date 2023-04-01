package com.dmc.eirs.provider

import android.app.ActivityManager
import android.content.Context
import android.os.Environment
import android.os.StatFs


class MemoryInformation(private val context: Context) {
    /**
     * To get the total RAM of the device
     * Remember , these terms :
     * long kb = 1024
     * long mb = kb*1024
     * long Gb = mb * 1024
     * @return total ram in long
     */
    val totalRam: Long
        get() = memoryInfo().totalMem

    /**
     * To get the total available RAM
     * @return remaining ram in long
     */
    val availableRam: Long
        get() = memoryInfo().availMem

    /**
     * To get the used ram of the device
     * @return used ram in long
     */
    val usedRam: Long
        get() = totalRam - availableRam

    /**
     * To check if external memory is available or not
     * @return boolean
     */
    val isExternalMemoryAvailable: Boolean
        get() = (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED)

    /**
     * Get available internal memory size
     * @return long
     */
    val availableInternalMemorySize: Long
        get() {
            val path = Environment.getDataDirectory()
            val statFs = StatFs(path.path)
            val blockSize = statFs.blockSizeLong
            val availableBlocks = statFs.availableBlocksLong
            return availableBlocks * blockSize
        }

    /**
     * Get total internal memory size
     * @return long
     */
    val totalInternalMemorySize: Long
        get() {
            val path = Environment.getDataDirectory()
            val statFs = StatFs(path.path)
            val blockSize = statFs.blockSizeLong
            val totalBlocks = statFs.blockCountLong
            return blockSize * totalBlocks
        }

    /**
     * Get the used internal memory size
     * @return long
     */
    val usedInternalMemorySize: Long
        get() = if (totalInternalMemorySize > availableInternalMemorySize) {
            totalInternalMemorySize - availableInternalMemorySize
        } else {
            -11111111
        }

    /**
     * Get the available external memory size
     * @return long (if memory is not available then it will return -111111111
     */
    val totalExternalStorageSize: Long
        get() {
            return if (isExternalMemoryAvailable) {
                val path = Environment.getExternalStorageDirectory()
                val statFs = StatFs(path.path)
                val blockSize = statFs.blockSizeLong
                val totalBlocks = statFs.blockCountLong
                blockSize * totalBlocks
            } else {
                -1111111111
            }
        }

    /**
     * Get the total external storage available
     * @return long
     */
    val availableExternalStorageSize: Long
        get() {
            return if (isExternalMemoryAvailable) {
                val path = Environment.getExternalStorageDirectory()
                val statFs = StatFs(path.path)
                val blockSize = statFs.blockSizeLong
                val availableBlocks = statFs.availableBlocksLong
                blockSize * availableBlocks
            } else {
                -1111111111
            }
        }

    /**
     * Get the used external memory space
     * @return long
     */
    val usedExternalStorageSize: Long
        get() {
            return if (isExternalMemoryAvailable) {
                if (totalExternalStorageSize > availableExternalStorageSize) {
                    totalExternalStorageSize - availableExternalStorageSize
                } else {
                    -1111111111
                }
            } else {
                -1111111111
            }
        }

    private fun memoryInfo(): ActivityManager.MemoryInfo {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        return memoryInfo
    }
}