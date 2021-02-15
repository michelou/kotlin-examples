package _06_lazy_seq

import kotlin.sequences.sequence

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val seq = sequence {
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
