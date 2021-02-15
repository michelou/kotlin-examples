package _01_bean

data class FullName(val first: String, val last: String)

fun parseName(name: String): FullName {
    val space = name.indexOf(' ')
    return FullName(
        name.substring(0, space),
        name.substring(space + 1)
    )
}

fun parseName2(name: String): FullName {
    val space = name.indexOf(' ')
    if (space < 0) { return FullName("", name) }
    return FullName(
        name.substring(0, space),
        name.substring(space + 1)
    )
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val name = parseName("Jane Doe")
    val first = name.first
    val last = name.last
    println("fist=$first, last=$last")

    if (name != parseName("Jane Doe")) {
        println("!!!!!!!!!!!!!!!!!!!!!!")
        println("Equals doesn't work :(")
        println("!!!!!!!!!!!!!!!!!!!!!!")
    }
}
