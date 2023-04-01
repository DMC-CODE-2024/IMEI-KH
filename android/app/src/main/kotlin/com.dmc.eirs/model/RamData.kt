package com.dmc.eirs.model


data class RamData(
    val total: String,
    val available: String,
    val percentageAvailable: Int,
    val threshold: String
)