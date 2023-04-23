package com.dmc.eirs.model

data class DisplayInfo(
        val displayHeight: Int?,
        val displayWidth: Int?,
        val navigationBarHeight: Int?,
        val physicalSize: Double?,
        val fontScale: Float?,
        val refreshRate: Float?,
        val orientation: Int?,
        val rotation: Int?,
        val isHdrCapable: Boolean = false,
        val isNightModeActive: Boolean = false,
        val isScreenRound: Boolean = false,
        val isScreenWideColorGamut: Boolean = false,
        val isBrightnessAutoMode: Boolean = false,
        val brightnessLevel: Int?,
        val screenTimeout: Int?
)
