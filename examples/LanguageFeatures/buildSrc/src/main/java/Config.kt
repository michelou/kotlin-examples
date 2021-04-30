import java.io.File
import java.io.FileInputStream
import java.util.Properties

object Config: Properties() {
    init {
        val fis = FileInputStream("gradle.properties")
        this.load(fis)
        System.getenv("KOTLIN_HOME")?.let { setProperty("KOTLIN_HOME", it) }
        // println("appVersion="+getProperty("appVersion"))
    }

    val appGroup      = getProperty("appGroup",      "org.example")
    val appVersion    = getProperty("appVersion",    "1.0-SNAPSHOT")
    val kotlinHome    = getProperty("kotlinHome",    "c:/opt/kotlinc-1.4.32/")
    val kotlinVersion = getProperty("kotlinVersion", "1.4.32")
    val mainClassName = getProperty("mainClassName", "org.example.main.HelloWorldKt")
    val ktLintJar     = getProperty("ktLintJar",     "C:/opt/ktlint-0.41.0/ktlint.jar")

    fun filesInDir(dirPath: String, fileExt: String = ".kt"): List<String> {
        return File(dirPath).walk().filter { it.name.endsWith(fileExt) }.map { it.absolutePath }.toList()
    }
}
