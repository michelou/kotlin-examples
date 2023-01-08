package org.example.main

import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate
import com.makotogo.learn.kotlin.model.Guest
import com.makotogo.learn.kotlin.util.*

class PropertiesJUnitTest {

    @Test
    fun test1() {
        val guest = Guest(
            familyName = "Lane",
            givenName = "Bog",
            dateOfBirth = LocalDate.of(1982, 8, 15),
            taxIdNumber = "000-777-9648",
            purpose = "Package Delivery"
        )

        assertEquals("test1", "${guest.familyName}", "Lane")
    }

}
