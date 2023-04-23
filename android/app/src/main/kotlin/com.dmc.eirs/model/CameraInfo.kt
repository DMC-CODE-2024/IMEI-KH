package com.dmc.eirs.model

data class CameraInfo(
        val isCameraAvailable: Boolean = false,
        val isFlashAvailable: Boolean = false,
        val cameraIds: Array<String>? = null,
        val numberOfCameras: Int = 0,
        val antibandingModes: IntArray? = null,
        val aberrationModes: IntArray? = null,
        val autoExposureModes: IntArray? = null,
        val autoFocusModes: IntArray? = null,
        val effects: IntArray? = null,
        val whiteBalanceModes: IntArray? = null,
        val videoStabilizationModes: IntArray? = null,
        val maximumAutoFocusRegions: Int,
        val maximumAutoExposureRegions: Int,
        val maximumAutoWhiteBalanceRegions: Int
)
