package _02_properties

import kotlin.properties.Delegates

var observeMe by Delegates.observable("a") {
    p, old, new -> println("${p.name} goes $old -> $new")
}

fun main(args: Array<String>) {
    println("\nObservable property:")
    observeMe = "bb"
    observeMe = "ccc"
    observeMe = "dddd"
}
