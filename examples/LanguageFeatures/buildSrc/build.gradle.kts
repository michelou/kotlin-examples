import org.gradle.kotlin.dsl.`kotlin-dsl`

plugins {
    `kotlin-dsl`
}

kotlinDslPluginOptions {
    experimentalWarning.set(false)
}

buildDir = file("target")

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("compiler", "1.3.72"))
}
