package org.example.main

// Sources:
//   https://kotlinexpertise.com/kotlin-features-miss-java/
//   https://android.jlelse.eu/kotlin-best-features-a3facac4d6fd

// Kotlin doesn't have new and semicolons are optional.

// see https://kotlinlang.org/api/latest/jvm/stdlib/
import kotlin.random.Random

// Single expression functions
fun trueOrFalse() = Random.nextBoolean()

// Default parameters
fun test(a: Int, printToConsole: Boolean = true) {
    if (printToConsole) println("int a: " + a)
}

// Multiple method calls on a single instance
class Turtle {
    fun penDown() { println("penDown") }
    fun penUp() { println("penUp") }
    fun turn(degrees: Double) { println("turn $degrees") }
    fun forward(pixels: Double) { println("forward $pixels") }
}

// Extension functions
fun Int.multi() = this * 5
fun String.greet(): String = this.plus(" we welcome you!")

// High order functions
fun addValue(f: (Int, Int) -> Int): Int = f(10, 20)

fun main(args: Array<String>) {
    val a = 1
    test(a, false)
    test(2)

    // Multiple method calls on a single instance
    with(Turtle()) {
        penDown()
        for (i in 1..4) {
            forward(100.0)
            turn(90.0)
        }
        penUp()
    }

    // Extension functions
    println(50.multi())
    println("John".greet())

    // High order functions
    println(addValue { num1, num2 -> num1 * num2 }) // This will print 200
    println(addValue { num1, num2 -> num1 - num2 }) // This will print -10

    // By default all the object are null safe so they will not accept null as a value
    // You need to explicitly define them by adding ? after its type.
    var str1: String = "name"
    // str1 = null //  error: null can not be a value of a non-null type String
    println(str1.length)

    // see src/org/jetbrains/kotlin/diagnostics/rendering/DefaultErrorMessages.java
    @Suppress("VARIABLE_WITH_REDUNDANT_INITIALIZER")
    var str2: String? = "name"
    str2 = null
    println(str2?.length)
}
