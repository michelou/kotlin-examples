import org.jetbrains.kotlin.gradle.plugin.KotlinSourceSet
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

import Config  // buildSrc/main/java/Config.kt

plugins {
    checkstyle
    java
    kotlin("jvm") version "${Config.kotlinVersion}"   // id("org.jetbrains.kotlin.jvm") version "1.3.60"
}

group = "${Config.appGroup}"
version = "${Config.appVersion}"

description = """Kotlin/JVM code example"""

sourceSets["main"].java.srcDir("src/main/java")
sourceSets["main"].withConvention(KotlinSourceSet::class) {
    kotlin.srcDir("src/main/kotlin")
    // kotlin.include("**/myTests/*.kt")
}

buildDir = file("target")   // Default: buildDir = file("build")

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

// see https://github.com/JetBrains/kotlin/blob/master/libraries/tools/
// - Tool options   ==> kotlin-gradle-plugin-api/src/main/kotlin/org/jetbrains/kotlin/gradle/dsl/KotlinCommonToolOptions.kt
// - Common options ==> kotlin-gradle-plugin-api/src/main/kotlin/org/jetbrains/kotlin/gradle/dsl/KotlinCommonOptions.kt
// - JVM options    ==> kotlin-gradle-plugin/src/main/kotlin/org/jetbrains/kotlin/gradle/dsl/KotlinJvmOptions.kt
val compileKotlin: KotlinCompile by tasks

// Tool options
// compileKotlin.kotlinOptions.allWarningsAsErrors = false
// compileKotlin.kotlinOptions.suppressWarnings = true
// compileKotlin.kotlinOptions.verbose = false
// compileKotlin.kotlinOptions.freeCompilerArgs = listOf("-Xjsr305=strict")

// Common options
compileKotlin.kotlinOptions.apiVersion = "1.3"
compileKotlin.kotlinOptions.languageVersion = "1.3"

// JVM options
// compileKotlin.kotlinOptions.includeRuntime = false
compileKotlin.kotlinOptions.jvmTarget = "1.8"

val ktLintOpts by extra { arrayOf(
    "--reporter=plain",
    "--reporter=checkstyle,output=$buildDir/ktlint-report.xml"
)}

tasks {
    register<JavaExec>("lint") {
        description = "Analyze Kotlin source files with KtLint"
        main = "-jar"
        args = mutableListOf(Config.ktLintJar) + Config.filesInDir("src/main/kotlin/")
    }
    register<JavaExec>("run") {
        dependsOn(":compileKotlin")
        description = "Execute main class ${Config.mainClassName}"
        // https://docs.gradle.org/current/userguide/working_with_files.html#sec:file_trees
        classpath = fileTree(Config.kotlinHome+"/lib") { include("*stdlib.jar") } + sourceSets["main"].output.classesDirs
        main = Config.mainClassName
        args = listOf("")
    }
}

repositories {
    mavenCentral()
    jcenter()
}

dependencies {
    api(kotlin("stdlib", "${Config.kotlinVersion}"))
    // implementation("org.jetbrains.kotlin:kotlin-stdlib:1.3.60")
    implementation(kotlin("stdlib", "${Config.kotlinVersion}"))
    testImplementation(kotlin("stdlib", "${Config.kotlinVersion}"))
    testImplementation(kotlin("test-junit", "${Config.kotlinVersion}"))
    api("junit:junit:4.12")
    implementation("junit:junit:4.12")
    testImplementation("junit:junit:4.12")
}