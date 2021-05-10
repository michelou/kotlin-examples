class Greeter {
    fun sayHi(callback: (String) -> Unit) {
        log("call callback function")
        callback("hi")
    }
    // https://discuss.kotlinlang.org/t/how-to-pass-a-function-as-parameter-to-another/848
    fun foo(m: String, bar: (m: String) -> Unit) {
        bar(m)
    }
}

class KotlinClass {
    companion object {
        @JvmStatic fun doWork() {
            log("call companion function")
        }
    }
}

fun log(msg: String) {
    println("[kt] $msg")
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val greeter = Greeter()
    greeter.foo("a message") {
        log("this is a message: $it")
    }

    fun buz(m: String) {
        log("another message: $m")
    }
    greeter.foo("a message", ::buz)
}
