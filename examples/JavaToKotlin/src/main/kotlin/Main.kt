// see https://developer.android.com/kotlin/interop

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    // Property prefixes
    var user = User()
    var name = user.name // Invokes user.getName()
    val active = user.isActive // Invokes user.isActive()
    println("name=$name active=$active")

    user.name = "Bob" // Invokes user.setName(String)
    name = user.name
    println("name=$name active=$active")

    // Operator overloading
    val one = IntBox(1)
    val two = IntBox(2)
    val three = one + two // Invokes one.plus(two)
    println("three=$three")

    // Lambda arguments
    // fun sayHi(callback: (String) -> Unit) = { s: String -> callback(s) }
    // greeter.sayHi { println("Greeting", "Hello, $it!") }
}
