package com.dmc.eirs.provider

import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.provider.Settings
import android.provider.Settings.SettingNotFoundException
import android.util.DisplayMetrics
import android.view.Surface
import android.view.WindowManager
import androidx.annotation.RequiresApi
import com.dmc.eirs.model.DisplayInfo
import kotlinx.coroutines.flow.flow
import kotlin.math.pow
import kotlin.math.sqrt


class DisplayDataProvider(private val context: Context) {
    @RequiresApi(Build.VERSION_CODES.R)
    fun getDisplayInfo() = flow {
        emit(
                DisplayInfo(
                        displayHeight = displayHeight,
                        displayWidth = displayWidth,
                        navigationBarHeight = navigationBarHeight,
                        physicalSize = physicalSize,
                        fontScale = fontScale,
                        refreshRate = refreshRate,
                        orientation = orientation,
                        rotation = rotation,
                        isHdrCapable = isHdrCapable,
                        isNightModeActive = isNightModeActive,
                        isScreenRound = isScreenRound,
                        isScreenWideColorGamut = isScreenWideColorGamut,
                        isBrightnessAutoMode = isBrightnessAutoMode,
                        brightnessLevel = brightnessLevel,
                        screenTimeout = screenTimeout
                )
        )
    }

    /**
     * To get the resolution of the device's display's height
     * It does include the navigation bar height
     * If you wanted to remove navigation bar height then subtract display height and navigation height
     * @return display height in pixels
     */
    private val displayHeight: Int
        get() = (context.resources.displayMetrics.heightPixels) + navigationBarHeight

    /**
     * To get the resolution of the device's  display's width
     * @return display width in pixels
     */
    private val displayWidth: Int
        get() = context.resources.displayMetrics.widthPixels

    /**
     * In some cases , you might have to include or exclude the navigation bar height or width
     * So this method can be used to get the navigation bar height
     * @return navigationBarHeight
     */
    private val navigationBarHeight: Int
        get() {
            val metrics = DisplayMetrics()
            val windowManager =
                    context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            windowManager.defaultDisplay.getMetrics(metrics)
            val usableHeight = metrics.heightPixels
            windowManager.defaultDisplay.getRealMetrics(metrics)
            val realHeight = metrics.heightPixels
            return if (realHeight > usableHeight) {
                realHeight - usableHeight
            } else {
                0
            }
        }

    /**
     * To get the physical size of the device
     * @return physicalSize in double
     */
    private val physicalSize: Double
        get() {
            val dm = DisplayMetrics()
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            windowManager.defaultDisplay.getMetrics(dm)
            val x = (displayWidth / dm.xdpi).toDouble().pow(2.0)
            val y = (displayHeight / dm.ydpi).toDouble().pow(2.0)
            return sqrt(x + y)
        }

    /**
     * To get the font scale of the display
     * @return font scale in float
     */
    private val fontScale: Float
        get() = context.resources.configuration.fontScale

    /**
     * To get the device's display's refresh rate in frame per second
     * @return display refresh rate in float
     */
    private val refreshRate: Float
        get() {
            val display =
                    (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).defaultDisplay
            return display.refreshRate
        }

    /**
     * To get the device's rotation angle
     * Portrait ----- 1
     * Landscape ---- 2
     * Undefined ---- 0
     * @return orientation in the int
     */
    private val orientation: Int
        get() = context.resources.configuration.orientation//-90
    //+90
    /**
     * To get rotation of the device
     * This will give orientation like normal and reverse
     * @return rotation angle in integer
     */
    private val rotation: Int
        get() {
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val angle: Int
            val rotation = windowManager.defaultDisplay.rotation
            angle = when (rotation) {
                Surface.ROTATION_90 -> 90 //-90
                Surface.ROTATION_180 -> 180
                Surface.ROTATION_270 -> 270 //+90
                else -> 0
            }
            return angle
        }

    /**
     * To check Hdr Capabilities of the screen
     * @return hdr capabilities in boolean
     */
    @get:RequiresApi(api = Build.VERSION_CODES.O)
    val isHdrCapable: Boolean
        get() {
            val configuration: Configuration = context.resources.configuration
            return configuration.isScreenHdr
        }

    /**
     * To check if night mode is active or not
     * @return status of night mode in boolean
     */
    @get:RequiresApi(api = Build.VERSION_CODES.R)
    val isNightModeActive: Boolean
        get() {
            val configuration: Configuration = context.resources.configuration
            return configuration.isNightModeActive
        }

    /**
     * To check if Screen is rounded or not
     * @return status of the rounded screen in boolean
     */
    private val isScreenRound: Boolean
        get() {
            val configuration: Configuration = context.resources.configuration
            return configuration.isScreenRound
        }

    /**
     * To check if screen wide color gamut or not
     * @return boolean
     */
    @get:RequiresApi(api = Build.VERSION_CODES.O)
    val isScreenWideColorGamut: Boolean
        get() {
            val configuration: Configuration = context.resources.configuration
            return configuration.isScreenWideColorGamut
        }

    /**
     * To check if automatic brightness mode is active or not
     * @return boolean (if autoMode then true else false)
     */
    private val isBrightnessAutoMode: Boolean
        get() = try {
            val brightnesses = Settings.System.getInt(
                    context.contentResolver,
                    Settings.System.SCREEN_BRIGHTNESS_MODE
            )
            brightnesses == 1
        } catch (e: SettingNotFoundException) {
            e.printStackTrace()
            false
        }

    /**
     * To get the active brightness level of the screen
     * There might not be any ways to get the brightness at auto-mode so(From StackOverFlow),
     * what we can do is triggerBrightnessMode to Manual and then measure screen brightness and
     * again change them to automatic
     * @return brightness level from 0 to 225
     */
    private val brightnessLevel: Int
        get() {
       /*     val contentResolver = context.contentResolver
            var a = 0
            var mode = 0
            try {
                mode =
                        Settings.System.getInt(contentResolver, Settings.System.SCREEN_BRIGHTNESS_MODE)
            } catch (e: SettingNotFoundException) {
                e.printStackTrace()
            }
            if (mode == Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC) {
                a = 1
                Settings.System.putInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS_MODE,
                        Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL
                )
            }
            val brightnessLevel =
                    Settings.System.getInt(contentResolver, Settings.System.SCREEN_BRIGHTNESS, 125)
            if (a == 1) {
                Settings.System.putInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS_MODE,
                        Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC
                )
            }*/
            //return brightnessLevel
            return 0
        }

    /**
     * To trigger brightness mode (automatic to manual and vice-versa)
     * @return void
     */
    fun triggerBrightnessMode() {
        val contentResolver = context.contentResolver
        try {
            val mode =
                    Settings.System.getInt(contentResolver, Settings.System.SCREEN_BRIGHTNESS_MODE)
            if (mode == Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC) {
                Settings.System.putInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS_MODE,
                        Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL
                )
            } else {
                Settings.System.putInt(
                        contentResolver,
                        Settings.System.SCREEN_BRIGHTNESS_MODE,
                        Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC
                )
            }
        } catch (e: SettingNotFoundException) {
            e.printStackTrace()
        }
    }

    /**
     * To get the screen timeout value of the android device
     * @return int (will return 0 if exception is caught)
     */
    private val screenTimeout: Int
        get() {
            return try {
                Settings.System.getInt(context.contentResolver, Settings.System.SCREEN_OFF_TIMEOUT)
            } catch (e: SettingNotFoundException) {
                e.printStackTrace()
                0
            }
        }
}