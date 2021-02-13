// Example 4-2

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

internal class FoldMainKtTest {

    @Test
    internal fun `sum using fold`() {
        val numbers = intArrayOf(3, 1, 4, 1, 5, 9)
        assertEquals(numbers.sum(), sum(*numbers))
    }

}
