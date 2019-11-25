import Config  // buildSrc/main/java/Config.kt

plugins {
    kotlin("multiplatform") version "${Config.kotlinVersion}"
}

group = "${Config.appGroup}"
version = "${Config.appVersion}"

description = """Kotlin/Native code example"""

buildDir = file("target")

// see https://kotlinlang.org/docs/reference/building-mpp-with-gradle.html
kotlin {
    mingwX64() {
        binaries {
            executable() {
                baseName = "HelloWorld"
                entryPoint = "org.example.main"
                println("Executable path: ${outputFile.absolutePath}")
            }
        }
    }
}
