package com.dmc.eirs.provider

import android.content.Context
import android.os.Build
import android.os.Build.VERSION_CODES
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import java.util.*


class SystemInformation(  private val context: Context) {

    /** Returns API Level of the android device  */
    val apiLevel: Int
        get() = Build.VERSION.SDK_INT

    /** Returns Android Version Name  */
    val versionName: String
        get() {
            val fields = VERSION_CODES::class.java.fields
            var name = fields[Build.VERSION.SDK_INT + 1].name
            if (name == "O") name = "Oreo"
            if (name == "N") name = "Nougat"
            if (name == "M") name = "Marshmallow"
            if (name.startsWith("O_")) name = "Oreo++"
            if (name.startsWith("N_")) name = "Nougat++"
            return name
        }

    /**
     * It returns the security patch date
     * Since Build.VERSION.SECURITY_PATCH is added in api 23
     * Added other method to get the latest security patch date
     */
    val securityPathDate: String
        get() {
            if (Build.VERSION.SDK_INT >= 23) {
                return Build.VERSION.SECURITY_PATCH
            } else {
                try {
                    val process = ProcessBuilder()
                        .command("/system/bin/getprop")
                        .redirectErrorStream(true)
                        .start()
                    val `is` = process.inputStream
                    val br = BufferedReader(InputStreamReader(`is`))
                    var line: String
                    val str = StringBuilder()
                    while (br.readLine().also { line = it } != null) {
                        str.append(line).append("\n")
                        if (str.toString().contains("security_patch")) {
                            val split = line.split(":".toRegex()).toTypedArray()
                            if (split.size == 2) {
                                return split[1]
                            }
                            break
                        }
                    }
                    br.close()
                    process.destroy()
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }
            return ""
        }

    /**
     * It will return the api level's release date of the android
     * I've written it manually
     * @Return Date ifNotFound then null
     */
    val androidSdkReleaseDate: Date?
        get() {
            val sdk = Build.VERSION.SDK_INT
            val calendar = Calendar.getInstance()
            return if (sdk == 1) {
                calendar[Calendar.MONTH] = 8
                calendar[Calendar.DATE] = 23
                calendar[Calendar.YEAR] = 2008
                calendar.time
            } else if (sdk == 2) {
                calendar[Calendar.MONTH] = 1
                calendar[Calendar.DATE] = 9
                calendar[Calendar.YEAR] = 2009
                calendar.time
            } else if (sdk == 3) {
                calendar[Calendar.MONTH] = 3
                calendar[Calendar.DATE] = 27
                calendar[Calendar.YEAR] = 2009
                calendar.time
            } else if (sdk == 4) {
                calendar[Calendar.MONTH] = 8
                calendar[Calendar.DATE] = 15
                calendar[Calendar.YEAR] = 2009
                calendar.time
            } else if (sdk == 5) {
                calendar[Calendar.MONTH] = 9
                calendar[Calendar.DATE] = 27
                calendar[Calendar.YEAR] = 2009
                calendar.time
            } else if (sdk == 6) {
                calendar[Calendar.MONTH] = 11
                calendar[Calendar.DATE] = 3
                calendar[Calendar.YEAR] = 2009
                calendar.time
            } else if (sdk == 7) {
                calendar[Calendar.MONTH] = 0
                calendar[Calendar.DATE] = 11
                calendar[Calendar.YEAR] = 2010
                calendar.time
            } else if (sdk == 8) {
                calendar[Calendar.MONTH] = 4
                calendar[Calendar.DATE] = 20
                calendar[Calendar.YEAR] = 2010
                calendar.time
            } else if (sdk == 9) {
                calendar[Calendar.MONTH] = 11
                calendar[Calendar.DATE] = 6
                calendar[Calendar.YEAR] = 2010
                calendar.time
            } else if (sdk == 10) {
                calendar[Calendar.MONTH] = 1
                calendar[Calendar.DATE] = 9
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 11) {
                calendar[Calendar.MONTH] = 1
                calendar[Calendar.DATE] = 22
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 12) {
                calendar[Calendar.MONTH] = 4
                calendar[Calendar.DATE] = 10
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 13) {
                calendar[Calendar.MONTH] = 6
                calendar[Calendar.DATE] = 15
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 14) {
                calendar[Calendar.MONTH] = 9
                calendar[Calendar.DATE] = 18
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 15) {
                calendar[Calendar.MONTH] = 11
                calendar[Calendar.DATE] = 16
                calendar[Calendar.YEAR] = 2011
                calendar.time
            } else if (sdk == 16) {
                calendar[Calendar.MONTH] = 6
                calendar[Calendar.DATE] = 9
                calendar[Calendar.YEAR] = 2012
                calendar.time
            } else if (sdk == 17) {
                calendar[Calendar.MONTH] = 10
                calendar[Calendar.DATE] = 13
                calendar[Calendar.YEAR] = 2012
                calendar.time
            } else if (sdk == 18) {
                calendar[Calendar.MONTH] = 6
                calendar[Calendar.DATE] = 24
                calendar[Calendar.YEAR] = 2013
                calendar.time
            } else if (sdk == 19) {
                calendar[Calendar.MONTH] = 9
                calendar[Calendar.DATE] = 31
                calendar[Calendar.YEAR] = 2013
                calendar.time
            } else if (sdk == 20) {
                calendar[Calendar.MONTH] = 5
                calendar[Calendar.DATE] = 25
                calendar[Calendar.YEAR] = 2014
                calendar.time
            } else if (sdk == 21) {
                calendar[Calendar.MONTH] = 10
                calendar[Calendar.DATE] = 4
                calendar[Calendar.YEAR] = 2014
                calendar.time
            } else if (sdk == 22) {
                calendar[Calendar.MONTH] = 2
                calendar[Calendar.DATE] = 2
                calendar[Calendar.YEAR] = 2015
                calendar.time
            } else if (sdk == 23) {
                calendar[Calendar.MONTH] = 9
                calendar[Calendar.DATE] = 2
                calendar[Calendar.YEAR] = 2015
                calendar.time
            } else if (sdk == 24) {
                calendar[Calendar.MONTH] = 7
                calendar[Calendar.DATE] = 22
                calendar[Calendar.YEAR] = 2016
                calendar.time
            } else if (sdk == 25) {
                calendar[Calendar.MONTH] = 9
                calendar[Calendar.DATE] = 4
                calendar[Calendar.YEAR] = 2016
                calendar.time
            } else if (sdk == 26) {
                calendar[Calendar.MONTH] = 6
                calendar[Calendar.DATE] = 21
                calendar[Calendar.YEAR] = 2017
                calendar.time
            } else if (sdk == 27) {
                calendar[Calendar.MONTH] = 11
                calendar[Calendar.DATE] = 5
                calendar[Calendar.YEAR] = 2017
                calendar.time
            } else if (sdk == 28) {
                calendar[Calendar.MONTH] = 6
                calendar[Calendar.DATE] = 6
                calendar[Calendar.YEAR] = 2018
                calendar.time
            } else if (sdk == 29) {
                calendar[Calendar.MONTH] = 8
                calendar[Calendar.DATE] = 7
                calendar[Calendar.YEAR] = 2019
                calendar.time
            } else if (sdk == 30) {
                calendar[Calendar.MONTH] = 8
                calendar[Calendar.DATE] = 8
                calendar[Calendar.YEAR] = 2020
                calendar.time
            } else {
                null
            }
        }

    /**
     * To get the bootloader version
     */
    val bootloader: String
        get() = Build.BOOTLOADER
    val kernalVersion: String
        get() {
            var process: Process? = null
            try {
                process = Runtime.getRuntime().exec("uname -a")
            } catch (e: IOException) {
                e.printStackTrace()
            }
            var `is`: InputStream? = null
            return try {
                `is` = if (process!!.waitFor() == 0) {
                    process.inputStream
                } else {
                    process.errorStream
                }
                val br = BufferedReader(InputStreamReader(`is`))
                val line = br.readLine()
                br.close()
                line
            } catch (e: InterruptedException) {
                e.printStackTrace()
                "Error"
            } catch (e: IOException) {
                e.printStackTrace()
                "Error"
            }
        }

    //en
    val language: String
        get() = Locale.getDefault().language //en

    // eng
    val iso3Language: String
        get() = Locale.getDefault().isO3Language // eng

    // US
    val country: String
        get() = Locale.getDefault().country // US

    //USA
    val iso3Country: String
        get() = Locale.getDefault().isO3Country //USA

    // United States
    val displayCountry: String
        get() = Locale.getDefault().displayCountry // United States

    // English(United States)
    val displayName: String
        get() = Locale.getDefault().displayName // English(United States)

    // English
    val displayLanguage: String
        get() = Locale.getDefault().displayLanguage // English

    // en-US
    val languageTag: String
        get() = Locale.getDefault().toLanguageTag() // en-US
}