// see https://discuss.kotlinlang.org/t/compile-time-functions-macros/2097/13

import kotlin.reflect.KMutableProperty
import kotlin.reflect.full.memberProperties

data class Person(
    val name: String,
    var age: Int
)

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    print("Source code:")
    printlf("""
    data class Person(
        val name: String,
        var age: Int
    )""")
    printlf()
    printlf("Methods:")
    val methods = Person::class.java.declaredMethods
    val sorted = methods.sortedBy { it.name } // to ensure predictable order
    sorted.forEach {
        printlf("    fun ${it.name}: ${it.returnType}")
    }
    printlf()
    printlf("Members:")
    Person::class.memberProperties.forEach {
        printlf("    ${ if (it is KMutableProperty<*>) "var" else "val" } ${it.name}: ${it.returnType}")
    }
}

fun printlf(s: String = "") { print("$s\n") }
