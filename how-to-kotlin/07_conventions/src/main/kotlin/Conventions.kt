package _07_conventions

data class Date(
    var day: Int,
    var month: Int,
    var year: Int
) : Comparable<Date> {
    override fun compareTo(other: Date): Int {
        if (this.year > other.year) {
            return this.year.compareTo(other.year)
        }
        if (this.month > other.month) {
            return this.month.compareTo(other.month)
        }
        return this.day.compareTo(other.day)
    }
}

operator fun Date.get(index: Int): Int {
    return when (index) {
        0 -> day
        1 -> month
        2 -> year
        else -> throw IndexOutOfBoundsException("Invalid index")
    }
}

operator fun Date.set(index: Int, value: Int) {
    return when (index) {
        0 -> day = value
        1 -> month = value
        2 -> year = value
        else -> throw IndexOutOfBoundsException("Invalid index")
    }
}

data class Month(var month: Int, var year: Int)

private operator fun Month.contains(date: Date): Boolean {
    return month == date.month && year == date.year
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val date = Date(25, 2, 2018)
    println("date: $date")

    // "get" convention
    val day = date[0]
    val month = date[1]
    val year = date[2]
    println("day/month/year: $day/$month/$year")

    // "set" convention
    date[1] = 7

    // "in" convention ("contains" operator method)
    val march2018 = Month(3, 2018)
    println("date belongs to $march2018: ${date in march2018}")

    // "rangeTo" convention ("Comparable" interface)
    val yearStart = Date(1, 1, 2018)
    val yearEnd = Date(31, 12, 2018)
    val dateRange = yearStart..yearEnd
    println("date range: $dateRange")
}
