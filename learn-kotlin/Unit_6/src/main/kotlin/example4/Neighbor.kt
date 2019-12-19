package com.makotogo.learn.kotlin.example4

fun main(args: Array<String>) {
    println(publicProperty)
    println(internalProperty)

    val internalClass = InternalClass("Neighbor.internalClass")
    println(internalClass.name)

    val parent = Parent("Parent")
    println(parent.name)
    println(parent.internalClass.name)
}
