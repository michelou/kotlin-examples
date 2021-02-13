// Example 5-40

import java.time.LocalDate

class LocalDateProgression(
    override val start: LocalDate,
    override val endInclusive: LocalDate,
    val step: Long = 1
): Iterable<LocalDate>, ClosedRange<LocalDate> {
    override fun iterator(): Iterator<LocalDate> =
        LocalDateProgressionIterator(start, endInclusive, step)
    infix fun step(days: Long) =
        LocalDateProgression(start, endInclusive, days)
}

internal class LocalDateProgressionIterator(
    start: LocalDate,
    val endInclusive: LocalDate,
    val step: Long
) : Iterator<LocalDate> {
    private var current = start

    override fun hasNext() = current <= endInclusive

    override fun next(): LocalDate {
        val next = current
        current = current.plusDays(step)
        return next
    }

}

operator fun LocalDate.rangeTo(other: LocalDate) =
     LocalDateProgression(this, other)

fun main() {
    val startDate = LocalDate.now()
    val endDate = startDate.plusDays(5)

    println("startDate = $startDate")
    println("endDate   = $endDate")
    println()
    (startDate..endDate).forEach { localDate ->
        println("localDate = $localDate")
    }
}
