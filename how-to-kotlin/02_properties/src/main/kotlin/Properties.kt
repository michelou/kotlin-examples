package _02_properties

private var _os: String? = null
val osAvoid: String
    get() {
        if (_os == null) {
            println("Computing...")
            _os = System_getProperty("os.name") +
                " v" + System_getProperty("os.version") +
                " (" + System_getProperty("os.arch") + ")"
        }
        return _os!!
    }

val os: String by lazy {
    println("Computing...")
    System_getProperty("os.name") +
        " v" + System_getProperty("os.version") +
        " (" + System_getProperty("os.arch") + ")"
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    for (i in 1..3)
        println(osAvoid)
    for (i in 1..3)
        println(os)
}
