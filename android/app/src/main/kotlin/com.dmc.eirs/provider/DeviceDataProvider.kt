package com.dmc.eirs.provider

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.text.TextUtils
import androidx.annotation.RequiresPermission
import com.dmc.eirs.model.DeviceInfo
import kotlinx.coroutines.flow.flow
import java.io.File


class DeviceDataProvider(private val context: Context) {
    fun getDeviceInfo() = flow {
        emit(
                DeviceInfo(
                        modelName = modelName,
                        deviceName = deviceName,
                        manufacturerName = manufacturerName,
                        boardName = boardName,
                        hardwareName = hardwareName,
                        brandName = brandName,
                        deviceId = deviceId,
                        buildFingerPrint = buildFingerPrint,
                        deviceType = deviceType,
                        isUsbHostSupported = isUsbHostSupported,
                        numberOfSimSlot = numberOfSimSlot,
                        imei = null,
                        buildTime = buildTime,
                        productName = productName,
                        codeName = codeName,
                        radioVersion = radioVersion,
                        displayVersion = displayVersion,
                        host = host,
                        buildUser = buildUser,
                        serial = serial,
                        isRooted = isRooted
                )
        )
    }

    /**
     * It returns the device model name
     */
    private val modelName: String
        get() = Build.MODEL

    /**
     * It returns the consumer friendly device name
     */
    private val deviceName: String
        get() {
            val manufacture = Build.MANUFACTURER
            val model = Build.MODEL
            return if (model.startsWith(manufacture)) {
                capitalize(model)
            } else {
                capitalize(manufacture)
            }
        }

    /** Returns the device manafacturer name  */
    private val manufacturerName: String
        get() = Build.MANUFACTURER

    /** Returns the board name of the device  */
    private val boardName: String
        get() = Build.BOARD

    /** Returns the hardware name of the device  */
    private val hardwareName: String
        get() = Build.HARDWARE

    /** Returns the brand name of the device  */
    private val brandName: String
        get() = Build.BRAND

    /** Returns the android device id   */
    @get:SuppressLint("HardwareIds")
    val deviceId: String
        get() = android.provider.Settings.Secure.getString(context.contentResolver, android.provider.Settings.Secure.ANDROID_ID)

    /** Returns the build fingerprint of the android device  */
    private val buildFingerPrint: String
        get() = Build.FINGERPRINT

    /** Returns Phone type either it is GSM  or CDMA or SIP  */
    private val deviceType: String
        get() {
            val telephonyManager =
                    context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            return when (telephonyManager.phoneType) {
                TelephonyManager.PHONE_TYPE_CDMA -> {
                    "CDMA"
                }
                TelephonyManager.PHONE_TYPE_GSM -> {
                    "GSM"
                }
                TelephonyManager.PHONE_TYPE_SIP -> {
                    "SIP"
                }
                else -> {
                    ""
                }
            }
        }

    /** Checks whether USB Host is supported or not  */
    private val isUsbHostSupported: Boolean
        get() = context.packageManager
                .hasSystemFeature(PackageManager.FEATURE_USB_HOST)// A method have to be implemented to get number of simSlot in less than Lollipop

    /** Returns the number of sim slot available in android device  */
    private val numberOfSimSlot: Int
        get() = SubscriptionManager.from(context).activeSubscriptionInfoCountMax

    /*
       * Returns the device imei number of the particular slot
       * Remember the slot number should starts with 1
       * To access Imei in android sdk version more than 29 ,
       * Special permissions should be required ..
       */
    @SuppressLint("MissingPermission", "HardwareIds")
    @Deprecated("")
    @RequiresPermission(Manifest.permission.READ_PHONE_STATE)
    fun getImei(slotNumber: Int): String {
        val telephonyManager =
                context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        return telephonyManager.getDeviceId(slotNumber)
    }

    /*
       * Returns build time
       */
    private val buildTime: Long
        get() = Build.TIME
    private val productName: String
        get() = Build.PRODUCT
    private val codeName: String
        get() = Build.VERSION.CODENAME
    private val radioVersion: String
        get() = Build.getRadioVersion()
    private val displayVersion: String
        get() = Build.DISPLAY
    private val host: String
        get() = Build.HOST
    private val buildUser: String
        get() = Build.USER
    private val serial: String
        get() = Build.SERIAL

    /**
     * It will check whether device is rooted or not
     * @return boolean
     */
    private val isRooted: Boolean
        get() {
            val locations = arrayOf(
                    "/sbin",
                    "/system/bin",
                    "/system/xbin/",
                    "/system/sd/xbin",
                    "/system/bin/failsafe/",
                    "/data/local/xbin/",
                    "/data/local/bin/",
                    "/data/local/"
            )
            for (location in locations) {
                if (File(location + "su").exists()) {
                    return true
                }
            }
            return false
        }

    private fun capitalize(s: String): String {
        if (TextUtils.isEmpty(s)) {
            return s
        }
        val arr = s.toCharArray()
        var capitalizeNext = true
        var phrase = ""
        for (c in arr) {
            if (capitalizeNext && Character.isLetter(c)) {
                capitalizeNext = false
                continue
            } else if (Character.isWhitespace(c)) {
                capitalizeNext = true
            }
            phrase += c
        }
        return phrase
    }
}