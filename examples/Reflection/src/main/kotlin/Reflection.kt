// see https://discuss.kotlinlang.org/t/compile-time-functions-macros/2097/13

import kotlin.reflect.KMutableProperty
import kotlin.reflect.full.memberProperties

data class Person(
    val name: String,
    var age: Int
)

fun main(args: Array<String>) {
    print("Source code:")
    println("""
    data class Person(
        val name: String,
        var age: Int
    )
    """)
    println("Methods:")
    Person::class.java.declaredMethods.forEach {
        println("    fun ${it.name}: ${it.returnType}")
    }
    println("\nMembers:")
    Person::class.memberProperties.forEach {
        println("    ${ if (it is KMutableProperty<*>) "var" else "val" } ${it.name}: ${it.returnType}")
    }
}
