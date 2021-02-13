// Example 3-10

class Customer(val name: String) {
    private var _messages: List<String>? = null

    val messages: List<String>
        get() {
            if (_messages == null) {
                _messages = loadMessages()
            }
            return _messages!!
        }

    private fun loadMessages(): MutableList<String> =
        mutableListOf(
            "Initial contact",
            "Convinced them to use Kotlin",
            "Sold training class. Sweet."
        ).also { println("Loaded messages") }
}

class CustomerLazy(val name: String) {
    val messages: List<String> by lazy { loadMessages() }
    
    private fun loadMessages(): MutableList<String> =
        mutableListOf(
            "Initial contact",
            "Convinced them to use Kotlin",
            "Sold training class. Sweet."
        ).also { println("Loaded messages") }
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val customer = Customer("Fred")
    println("Customer name: " + customer.name)
}
