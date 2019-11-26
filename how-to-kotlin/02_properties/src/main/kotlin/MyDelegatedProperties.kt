package _02_properties

import kotlin.reflect.KProperty

class Prop(var field: String) {
    operator fun getValue(thisRef: Any?, p: KProperty<*>): String {
        println("Your read me")
        return field
    }
    operator fun setValue(thisRef: Any?, p: KProperty<*>, v: String) {
        println("Your write me")
        field = v
    }
}

fun main(args: Array<String>) {
    var p1 by Prop("initial")
    var p2 by Prop("initial")
    var p3 by Prop("initial")
    println("p1=$p1")
    println("p2=$p2")
    println("p3=$p3")
    p1 = "hello"
    println("p1=$p1")
}
