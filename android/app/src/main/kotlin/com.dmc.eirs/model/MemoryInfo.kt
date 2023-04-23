package com.dmc.eirs.model

data class MemoryInfo(
        val totalRam: Long,
        val availableRam: Long,
        val usedRam: Long,
        val isExternalMemoryAvailable: Boolean,
        val availableInternalMemorySize: Long,
        val totalInternalMemorySize: Long,
        val usedInternalMemorySize: Long,
        val totalExternalStorageSize: Long,
        val availableExternalStorageSize: Long,
        val usedExternalStorageSize: Long
)