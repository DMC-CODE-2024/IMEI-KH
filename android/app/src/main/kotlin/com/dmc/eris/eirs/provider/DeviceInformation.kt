package com.dmc.eris.eirs.provider

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.text.TextUtils
import androidx.annotation.RequiresApi
import androidx.annotation.RequiresPermission
import java.io.File


class DeviceInformation(private val context: Context) {

    /**
     * It returns the device model name
     */
    val modelName: String
        get() = Build.MODEL

    /**
     * It returns the consumer friendly device name
     */
    val deviceName: String
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
    val manufacturerName: String
        get() = Build.MANUFACTURER

    /** Returns the board name of the device  */
    val boardName: String
        get() = Build.BOARD

    /** Returns the hardware name of the device  */
    val hardwareName: String
        get() = Build.HARDWARE

    /** Returns the brand name of the device  */
    val brandName: String
        get() = Build.BRAND

    /** Returns the android device id   */
    @get:SuppressLint("HardwareIds")
    val deviceId: String
        get() = android.provider.Settings.Secure.getString(context.contentResolver, android.provider.Settings.Secure.ANDROID_ID)

    /** Returns the build fingerprint of the android device  */
    val buildFingerPrint: String
        get() = Build.FINGERPRINT

    /** Returns Phone type either it is GSM  or CDMA or SIP  */
    val deviceType: String
        get() {
            val telephonyManager =
                context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val phoneType = telephonyManager.phoneType
            return if (phoneType == TelephonyManager.PHONE_TYPE_CDMA) {
                "CDMA"
            } else if (phoneType == TelephonyManager.PHONE_TYPE_GSM) {
                "GSM"
            } else if (phoneType == TelephonyManager.PHONE_TYPE_SIP) {
                "SIP"
            } else {
                ""
            }
        }

    /** Checks whether USB Host is supported or not  */
    val isUsbHostSupported: Boolean
        get() = context.getPackageManager()
            .hasSystemFeature(PackageManager.FEATURE_USB_HOST)// A method have to be implemented to get number of simSlot in less than Lollipop

    /** Returns the number of sim slot available in android device  */
    val numberOfSimSlot: Int
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            val subscriptionManager = SubscriptionManager.from(context)
            subscriptionManager.activeSubscriptionInfoCountMax
        } else {
            // A method have to be implemented to get number of simSlot in less than Lollipop
            1
        }

    /*
       * Returns the device imei number of the particular slot
       * Remember the slot number should starts with 1
       * To access Imei in android sdk version more than 29 ,
       * Special permissions should be required ..
       */
    @RequiresApi(api = Build.VERSION_CODES.M)
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
    val buildTime: Long
        get() = Build.TIME
    val productName: String
        get() = Build.PRODUCT
    val codeName: String
        get() = Build.VERSION.CODENAME
    val radioVersion: String
        get() = Build.getRadioVersion()
    val displayVersion: String
        get() = Build.DISPLAY
    val host: String
        get() = Build.HOST
    val buildUser: String
        get() = Build.USER
    val serial: String
        get() = Build.SERIAL

    /**
     * It will check whether device is rooted or not
     * @return boolean
     */
    val isRooted: Boolean
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