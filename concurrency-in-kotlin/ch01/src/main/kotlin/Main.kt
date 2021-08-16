// Concurrency in Kotlin, Packt 2018, pp. 11-13

package chapter1

import kotlinx.coroutines.Job
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlin.system.measureTimeMillis

/** Suspend function 'coroutineScope' must be called from a coroutine or
 *  another suspend function.
 */
suspend fun createCoroutines(amount: Int) = coroutineScope {
    val jobs = ArrayList<Job>()
    for (i in 1..amount) {
        jobs += launch {
            println("Started $i in ${Thread.currentThread().name}")
            delay(1000)
            println("Finished $i in ${Thread.currentThread().name}")
        }
    }
    jobs.forEach {
        it.join()
    }
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) = runBlocking {
    println("${Thread.activeCount()} threads active at the start")
    val time = measureTimeMillis {
        createCoroutines(10)
    }
    println("${Thread.activeCount()} threads active at the end")
    println("Took $time ms")
}
