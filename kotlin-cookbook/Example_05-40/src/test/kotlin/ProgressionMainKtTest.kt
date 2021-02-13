// Example 5-42

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

import java.time.LocalDate

internal class ProgressionKtTest {

    @Test
    fun `use LocalDate as a progression`() {
        val startDate = LocalDate.now()
        val endDate = startDate.plusDays(5)

        val dateRange = startDate..endDate
        dateRange.forEachIndexed { index, localDate ->
            assertEquals(localDate, startDate.plusDays(index.toLong()))
        }

        val dateList = dateRange.map { it.toString() }
        assertEquals(6, dateList.size)
    }

    @Test
    fun `use LocalDate as a progression with a step`() {
        val startDate = LocalDate.now()
        val endDate = startDate.plusDays(5)

        val dateRange = startDate..endDate step 2
        dateRange.forEachIndexed { index, localDate ->
            assertEquals(localDate, startDate.plusDays(index.toLong() * 2))
        }

        val dateList = dateRange.map { it.toString() }
        assertEquals(3, dateList.size)
    }

}
