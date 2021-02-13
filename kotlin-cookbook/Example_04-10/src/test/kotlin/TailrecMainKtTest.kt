// Example 4-11

import org.hamcrest.MatcherAssert.assertThat
import org.hamcrest.Matchers.`is`

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

import java.math.BigInteger

internal class TailrecMainKtTest {

    @Test
    fun `check recursive factorial`() {
        assertAll(
            { assertThat(recursiveFactorial(0), `is`(BigInteger.ONE)) },
            { assertThat(recursiveFactorial(1), `is`(BigInteger.ONE)) },
            { assertThat(recursiveFactorial(2), `is`(BigInteger.valueOf(2))) },
            { assertThat(recursiveFactorial(5), `is`(BigInteger.valueOf(120))) },
            { assertThrows(StackOverflowError::class.java) {
                recursiveFactorial(10_000)
            }}
        )
    }

    @Test
    fun `factorial tests`() {
        assertAll(
            { assertThat(factorial(0), `is`(BigInteger.ONE)) },
            { assertThat(factorial(1), `is`(BigInteger.ONE)) },
            { assertThat(factorial(2), `is`(BigInteger.valueOf(2))) },
            { assertThat(factorial(5), `is`(BigInteger.valueOf(120))) },
            { assertThat(factorial(15000).toString().length, `is`(56130)) }
        )
    }

}
