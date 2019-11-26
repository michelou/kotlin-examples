package _04_expressions

class Example(val a: Int, val b: String?, val c: Boolean)

fun main(args: Array<String>) {
    val ex = Example(1, null, true)
    with(ex) {
        println("a = $a, b = $b, c = $c")
    }

    val map = mapOf("k1" to 1, "k2" to 2, "k3" to 3)
    for ((key, value) in map.entries) {
        println("$key -> $value")
    }

    val s = if (System.currentTimeMillis() % 2L == 0L) {
        println("Yay!")
        "Luck!"
    } else {
        "Not this time"
    }
    println(s)
}

fun test(e: Example): String = when (e.a) {
    1, 3, 5 -> "Odd"
    in setOf(0, 2, 4) -> "Even"
    else -> "Too big"
}

fun test2(str: String?): String? {
    println(str?.length)

    str?.forEach(::println)

    str ?: return null

    return ""
}
