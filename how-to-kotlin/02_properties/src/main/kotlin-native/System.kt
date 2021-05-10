package _02_properties

import kotlinx.cinterop.*
import platform.posix.getenv
import platform.posix.system

fun System_getProperty(name: String): String? = when (name) {
    "os.arch" ->
        getenv("PROCESSOR_ARCHITECTURE")?.toKString()
    "os.name" ->
        getenv("OS")?.toKString()
    "os.version" -> {
        system("powershell -C \"[Environment]::OSVersion\"")
        "0.0"
    }
    else ->
        "?"
}
