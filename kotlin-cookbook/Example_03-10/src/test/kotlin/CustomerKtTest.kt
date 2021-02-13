// Example 3-11

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test

internal class CustomerKtTest {

    @Test
    fun `load messages`() {
        val customer = Customer("Fred").apply { messages }
        Assertions.assertEquals(3, customer.messages.size)
    }

}
