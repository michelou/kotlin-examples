import org.junit.Assert.assertEquals
import org.junit.Test

import kotlin.reflect.KMutableProperty
import kotlin.reflect.full.memberProperties

class RefelectionJUnitTest {
//
    @Test
    fun test1() {
        val stdout = captureStdout {
            val methods = Person::class.java.declaredMethods
            val sorted = methods.sortedBy { it.name } // to ensure predictable order
            sorted.forEach {
                printlf("fun ${it.name}: ${it.returnType}")
            }
        }
        assertEquals("test1", "\n"+stdout, """
fun component1: class java.lang.String
fun component2: int
fun copy: class Person
fun copy${'$'}default: class Person
fun equals: boolean
fun getAge: int
fun getName: class java.lang.String
fun hashCode: int
fun setAge: void
fun toString: class java.lang.String
""")
    }

    @Test
    fun test2() {
        val stdout = captureStdout {
            Person::class.memberProperties.forEach {
                printlf("${ if (it is KMutableProperty<*>) "var" else "val" } ${it.name}: ${it.returnType}")
            }
        }
        assertEquals("test2", "\n"+stdout, """
var age: kotlin.Int
val name: kotlin.String
""")
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
