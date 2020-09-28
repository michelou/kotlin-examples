package com.makotojava.learn.kotlin.example2

fun sayHello(message: String) {
    println(message)
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    sayHello("Greetings from example 2")
}
