import org.junit.Assert.assertEquals
import org.junit.Test

class QuickSortJUnitTest {

    @Test
    fun test1() {
        val array = intArrayOf(64, 25, 12, 22, 11)
        quickSort(array, 0, array.size - 1)
        assertEquals("test1", 11, array[0])
    }
}
