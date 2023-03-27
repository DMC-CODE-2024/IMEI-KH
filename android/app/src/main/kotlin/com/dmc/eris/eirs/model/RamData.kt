package com.dmc.eris.eirs.model


data class RamData(
    val total: String,
    val available: String,
    val percentageAvailable: Int,
    val threshold: String
)