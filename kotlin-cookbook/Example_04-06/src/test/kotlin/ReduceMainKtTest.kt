// Example 4-8

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

internal class ReduceMainKtTest {

    @Test
    fun `sum using reduce`() {
        val numbers = intArrayOf(3, 1, 4, 1, 5, 9)
        assertAll(
            { assertEquals(numbers.sum(), sumReduce(*numbers)) },
            { assertThrows(UnsupportedOperationException::class.java) {
                  sumReduce()
              }
            }
        )
    }

}
