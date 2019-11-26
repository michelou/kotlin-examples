package _03_functions

// Extension functions
fun String.getFirstWord(separator: String = " "): String {
    val index = indexOf(separator)
    return if (index < 0) this else substring(0, index)
}

// Extension properties
val String.firstWord: String

get() {
    val index = indexOf(" ")
    return if (index < 0) this else substring(0, index)
}

// Extension properties (combined)
val String.firstWord2: String
get() = this.getFirstWord()

fun main(args: Array<String>) {
    println("Jane Doe".getFirstWord())
    println("Jane Doe".firstWord)
    println("Jane Doe".firstWord2)
}
