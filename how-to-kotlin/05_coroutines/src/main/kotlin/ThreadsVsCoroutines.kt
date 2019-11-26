package _05_coroutines

import kotlinx.coroutines.async
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking

fun main(args: Array<String>) = coroutines(100_000)

fun coroutines(n: Int) = runBlocking {
    val jobs = List(n) {
        async {
            delay(1000L) // 1 second job
            println(it)
        }
    }
    jobs.forEach { it.join() }
}
