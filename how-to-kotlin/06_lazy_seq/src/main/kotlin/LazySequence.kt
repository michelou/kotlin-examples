package _06_lazy_seq

import kotlin.coroutines.experimental.buildSequence

fun main(args: Array<String>) {
    val seq = buildSequence {
        var a = 1
        var b = 1

        while (true) {
            yield(a)
            val tmp = a
            a = b
            b += tmp
        }
    }

    println(seq.take(20).toList())
}
