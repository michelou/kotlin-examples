import org.junit.Assert.assertEquals
import org.junit.Test

class SelectionSortJUnitTest {

    @Test
    fun test1() {
        val array = intArrayOf(64, 25, 12, 22, 11)
        selectionSort(array)
        assertEquals("test1", 11, array[0])
    }
}
