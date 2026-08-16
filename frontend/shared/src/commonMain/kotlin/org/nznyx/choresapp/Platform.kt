package org.nznyx.choresapp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform