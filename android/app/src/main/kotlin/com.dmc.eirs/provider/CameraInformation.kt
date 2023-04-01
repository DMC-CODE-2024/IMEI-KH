package com.dmc.eirs.provider

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager


class CameraInformation(private val context: Context) {
    /**
     * Check if camera is available or not , FEATURE_CAMERA_ANY will look for all cameras(including rear cameras)
     * @return camera availability in boolean
     */
    val isCameraAvailable: Boolean
        get() = context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)

    /**
     * Check if flash is available or not in the camera
     * @return camera's flash availability in boolean
     */
    val isFlashAvailable: Boolean
        get() = context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)

    /**
     * Get all the cameraId lists
     * @return cameraIds in String array
     */
    val cameraIds: Array<String>?
        get() {
            val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
            return try {
                cameraManager.cameraIdList
            } catch (e: CameraAccessException) {
                e.printStackTrace()
                null
            }
        }

    /**
     * Get the number of the cameras in the device
     * It calls the getCameraIds() method which will give all the cameraIds lists and then return length
     * @return number of cameras in length
     */
    fun getNumberOfCameras(): Int {
        return cameraIds?.size ?: 0
    }

    /**
     * It will return the list of auto-exposure antibanding modes for aeAntibanding modes
     * that are supported by the camera device
     * CameraCharacteristics.CONTROL_AE_ANTIBANDING_MODE_50HZ = 1;
     * CameraCharacteristics.CONTROL_AE_ANTIBANDING_MODE_60HZ = 2;
     * CameraCharacteristics.CONTROL_AE_ANTIBANDING_MODE_AUTO = 3;
     * CameraCharacteristics.CONTROL_AE_ANTIBANDING_MODE_OFF
     * @return antibandingModes in String arrays
     */
    fun getAntibandingModes(cameraId: String): IntArray? {
        return getCharacteristics(
            cameraId,
            CameraCharacteristics.CONTROL_AE_AVAILABLE_ANTIBANDING_MODES
        )
    }

    /**
     * It will get List of aberration correction modes for android.colorCorrection.aberrationMode that are supported by this camera device.
     * Constants :
     * CameraCharacteristics.COLOR_CORRECTION_ABERRATION_MODE_FAST = 1;
     * CameraCharacteristics.COLOR_CORRECTION_ABERRATION_MODE_HIGH_QUALITY = 2 ;
     * CameraCharacteristics.COLOR_CORRECTION_ABERRATION_MODE_OFF = 0
     * @return available aberration modes in integerArray
     */
    fun getAberrationModes(cameraId: String): IntArray? {
        return getCharacteristics(
            cameraId,
            CameraCharacteristics.COLOR_CORRECTION_AVAILABLE_ABERRATION_MODES
        )
    }

    /**
     * It will return list of auto-exposure modes
     * Constants :
     * CameraCharacteristics.CONTROL_AE_MODE_OFF = 0;
     * CameraCharacteristics.CONTROL_AE_MODE_ON = 1;
     * CameraCharacteristics.CONTROL_AE_MODE_ON_AUTO_FLASH = 2;
     * CameraCharacteristics.CONTROL_AE_MODE_ON_ALWAYS_FLASH = 3;
     * CameraCharacteristics.CONTROL_AE_MODE_ON_AUTO_FLASH_REDEYE = 4;
     * @return all the autoExposureModes in int[] , compare to values above...by@oseamiya
     */
    fun getAutoExposureModes(cameraId: String): IntArray? {
        return getCharacteristics(cameraId, CameraCharacteristics.CONTROL_AE_AVAILABLE_MODES)
    }

    /**
     * It will return all the auto focus modes of the camera
     * Constants:
     * CameraCharacteristics.CONTROL_AF_MODE_OFF = 0;
     * CameraCharacteristics.CONTROL_AF_MODE_AUTO = 1;
     * CameraCharacteristics.CONTROL_AF_MODE_MACRO = 2;
     * CameraCharacteristics.CONTROL_AF_MODE_CONTINUOUS_VIDEO = 3;
     * CameraCharacteristics.CONTROL_AF_MODE_CONTINUOUS_PICTURE = 4;
     * CameraCharacteristics.CONTROL_AF_MODE_EDOF = 5;
     * @return all the auto-focus modes of camera
     */
    fun getAutoFocusModes(cameraId: String): IntArray? {
        return getCharacteristics(cameraId, CameraCharacteristics.CONTROL_AF_AVAILABLE_MODES)
    }

    /**
     * It will return all the available effects in the device
     * Constants:
     * CameraCharacteristics.CONTROL_EFFECT_MODE_OFF = 0;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_MONO = 1;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_NEGATIVE = 2;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_SEPIA = 4;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_POSTERIZE = 5;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_WHITEBOARD = 6;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_BLACKBOARD = 7;
     * CameraCharacteristics.CONTROL_EFFECT_MODE_AQUA = 8;
     */
    fun getEffects(cameraId: String): IntArray? {
        return getCharacteristics(cameraId, CameraCharacteristics.CONTROL_AVAILABLE_EFFECTS)
    }

    /**
     * It will return all the white balance modes available on the camera device
     * Constants:
     * CameraCharacteristics.CONTROL_AWB_MODE_OFF = 0;
     * CameraCharacteristics.CONTROL_AWB_MODE_AUTO = 1;
     * CameraCharacteristics.CONTROL_AWB_MODE_INCANDESCENT = 2;
     * CameraCharacteristics.CONTROL_AWB_MODE_FLUORESCENT = 3;
     * CameraCharacteristics.CONTROL_AWB_MODE_WARM_FLUORESCENT = 4;
     * CameraCharacteristics.CONTROL_AWB_MODE_DAYLIGHT = 5;
     * CameraCharacteristics.CONTROL_AWB_MODE_CLOUDY_DAYLIGHT = 6;
     * CameraCharacteristics.CONTROL_AWB_MODE_TWILIGHT = 7;
     * CameraCharacteristics.CONTROL_AWB_MODE_SHADE = 8;
     */
    fun getWhiteBalanceModes(cameraId: String): IntArray? {
        return getCharacteristics(cameraId, CameraCharacteristics.CONTROL_AWB_AVAILABLE_MODES)
    }

    /**
     * To get all the Video Stabilization Modes
     * Constants :
     * OFF ------> 1
     * ON--------> 2
     */
    fun getVideoStabilizationModes(cameraId: String): IntArray? {
        return getCharacteristics(
            cameraId,
            CameraCharacteristics.CONTROL_AVAILABLE_VIDEO_STABILIZATION_MODES
        )
    }

    /**
     * To get maximum number of metering regions that can be used by the auto-focus (AF) routine
     * @return int
     */
    fun getMaximumAutoFocusRegions(cameraId: String): Int {
        return getMaximumRegions(cameraId, CameraCharacteristics.CONTROL_MAX_REGIONS_AF)
    }

    /**
     * To get the maximum number of metering regions that can be used by the auto-exposure (AE) routine.
     * @return int
     */
    fun getMaximumAutoExposureRegions(cameraId: String): Int {
        return getMaximumRegions(cameraId, CameraCharacteristics.CONTROL_MAX_REGIONS_AE)
    }

    /**
     * To get the maximum number of metering regions that can be used by the auto-white balance (AWB) routine.
     * @return int
     */
    fun getMaximumAutoWhiteBalanceRegions(cameraId: String): Int {
        return getMaximumRegions(cameraId, CameraCharacteristics.CONTROL_MAX_REGIONS_AWB)
    }

    private fun getMaximumRegions(
        cameraId: String,
        characterSpecific: CameraCharacteristics.Key<Int>
    ): Int {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        var characteristics: CameraCharacteristics? = null
        try {
            characteristics = cameraManager.getCameraCharacteristics(cameraId)
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
        assert(characteristics != null)
        return characteristics!!.get(characterSpecific)!!
    }

    private fun getCharacteristics(
        cameraId: String,
        characterSpecificKey: CameraCharacteristics.Key<IntArray>
    ): IntArray? {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        var characteristics: CameraCharacteristics? = null
        try {
            characteristics = cameraManager.getCameraCharacteristics(cameraId)
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
        return characteristics!!.get(characterSpecificKey)
    }
}