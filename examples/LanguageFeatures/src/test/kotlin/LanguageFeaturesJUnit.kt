package org.example.main

import org.junit.Assert.*
import org.junit.Test

class LanguageFeaturesJUnitTest {

    @Test
    fun test1() {
        // Extension functions
        assertEquals("test1", 50.multiplyBy5(), 250)

        assertEquals("test1", "John".greet(), "John we welcome you!")
    }

}
