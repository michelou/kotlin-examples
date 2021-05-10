package _01_bean

import org.junit.Assert.assertEquals
import org.junit.Test
import kotlin.test.assertFailsWith

class BeanJUnitTest {

    @Test
    fun testParseName() {
        val name = parseName("Jane Doe")
        assertEquals("First name", "Jane", name.first)
    }

    @Test
    fun testParsNameException() {
        // https://kotlinlang.org/api/latest/kotlin.test/kotlin.test/assert-fails-with.html
        assertFailsWith<StringIndexOutOfBoundsException> {
            val name = parseName("SpongeBob")
            name.first
        }
    }

    @Test
    fun testParseName2FirstEmpty() {
        val name = parseName2("SpongeBob")
        assertEquals("First name", "", name.first)
    }
}
