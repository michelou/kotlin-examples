// Example 3-13

data class Point(val x: Int, val y: Int)

operator fun Point.unaryMinus() = Point(-x, -y)

val point = Point(10, 20)

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    println(-point)
}
