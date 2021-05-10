package org.example.test

import org.example.main
import org.junit.Assert.assertEquals
import org.junit.Test

class HelloWorldJUnitTest {

    @Test
    fun test1() {
        val stdout = captureStdout { main(arrayOf("Bob")) }
        assertEquals("test1", stdout, "Hello World!$eol")
    }

    init {
        System.setOut(java.io.PrintStream(baos))
    }

    companion object {
        private val eol = System.getProperty("line.separator")

        private val baos = java.io.ByteArrayOutputStream()

        fun captureStdout(block: () -> Unit): String {
            block()
            val stdout = baos.toString()
            baos.reset()
            return stdout
        }
    }
}
