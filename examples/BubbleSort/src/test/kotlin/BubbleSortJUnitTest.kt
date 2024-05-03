import org.junit.Assert.assertEquals
import org.junit.Test

class BubbleSortJUnitTest {

    @Test
    fun test1() {
        val array = intArrayOf(64, 25, 12, 22, 11)
        bubbleSort(array)
        assertEquals("test1", 11, array[0])
    }
}
