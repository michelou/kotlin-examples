package _07_conventions

import org.junit.Assert.assertEquals
import org.junit.Test
import kotlin.test.assertFailsWith

class ConventionsJUnitTest {

    @Test
    fun test1() {
        val date = Date(25, 2, 2018)
        assertEquals("Month", 2, date[1])
    }

}
