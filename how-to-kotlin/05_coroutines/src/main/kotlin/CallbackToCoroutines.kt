package _05_coroutines

import kotlin.coroutines.*
import kotlinx.coroutines.runBlocking

class CallbackService(val name: String) {
    class Response(val from: CallbackService, val message: String)

    fun request(from: String, callback: (Response) -> Unit) {
        // Do work...
        callback(Response(this, "hi $from\n -- Yours, $name"))
    }
}

fun main(args: Array<String>) {
    val s1 = CallbackService("1")
    val s2 = CallbackService("2")

    runBlocking {
        val r1 = s1.request(s2.name)
        println(r1.message)
        val r2 = s2.request(s1.name)
        println(r2.message)

        for (from in listOf("a", "b", "c")) {
            println(s1.request(from).message)
        }
    }
}

// Extension function
suspend fun CallbackService.request(from: String) =
    suspendCoroutine<CallbackService.Response> { cont ->
        try {
            request(from) { r ->
                cont.resume(r)
            }
        } catch (e: Throwable) {
            cont.resumeWithException(e)
        }
    }
