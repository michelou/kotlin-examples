// Example 3-13

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test

internal class PointMainKtTest {

    @Test
    internal fun `point with negative axes`() {
        val point = Point(10, 20)
        Assertions.assertEquals(-point.x, -10)
    }

}
