package _02_properties

private var _os: String? = null
val osAvoid: String
    get() {
        if (_os == null) {
            println("Computing...")
            _os = System.getProperty("os.name") +
                    " v" + System.getProperty("os.version") +
                    " (" + System.getProperty("os.arch") + ")"
        }
        return _os!!
    }

val os: String by lazy {
    println("Computing...")
    System.getProperty("os.name") +
        " v" + System.getProperty("os.version") +
        " (" + System.getProperty("os.arch") + ")"
    }

fun main(args: Array<String>) {
    for (i in 1..3)
        println(osAvoid)
    for (i in 1..3)
        println(os)
}
