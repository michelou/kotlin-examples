import kotlin.assert

/**
 * The main function that drives the program
 */
@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    javaClassProperty()
    binaryOperators()
    functions()
}

fun javaClassProperty() {
    val byte10: Byte = 10
    val shortTen: Short = 10
    val int10: Int = 10
    val longTen: Long = 10L
    val floatTen: Float = 10.0f
    val double10: Double = 10.0
    val charA: Char = 'a'
    val booleanTrue: Boolean = true
    val greeting: String = "Hello"
    val anything: Any = 10

    println("byte10 = $byte10")
    println("booleanTrue = $booleanTrue")

    assert(byte10.javaClass == java.lang.Byte.TYPE)
    assert(shortTen.javaClass == java.lang.Short.TYPE)
    assert(int10.javaClass == java.lang.Integer.TYPE)
    assert(longTen.javaClass == java.lang.Long.TYPE)
    assert(floatTen.javaClass == java.lang.Float.TYPE)
    assert(double10.javaClass == java.lang.Double.TYPE)
    assert(charA.javaClass == java.lang.Character.TYPE)

    println("assert(booleanTrue.javaClass == java.lang.Boolean.TYPE)")
    assert(booleanTrue.javaClass == java.lang.Boolean.TYPE)
    println("assert(booleanTrue.javaClass == java.lang.Boolean::class.java)")
    assert(booleanTrue.javaClass == java.lang.Boolean::class.java)

    assert(greeting.javaClass == java.lang.String::class.java)
    assert(anything.javaClass == java.lang.Object::class.java)
}

fun binaryOperators() {
    val i = 1
    println("i = $i")

    var product = i * 10
    var sum = i + 10
    println("product = i * 10 = $product")
    println("sum1 = i + 10 = $sum")

    product *= 2
    sum += 2
    println("product *= 2 => product = $product")
    println("sum += 2 => sum = $sum")

    var product2 = product shr 1
    println("product2 = product shr 1 = $product2")
}

fun functions() {
    fun saySomething(name: String): String { return "Hello there, $name" }
    println("saySomething(\"Steve\") = ${saySomething("Steve")}")

    fun saySomething2(name: String, country: String) =
        "Hello there, $name, your are from $country"
    println("saySomething2(\"Steve\", \"USA\") = ${saySomething2("Steve", "USA")}")
}
