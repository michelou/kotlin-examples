// Example 4-6, 4-7

public inline fun IntArray.reduce(op: (acc: Int, Int) -> Int): Int {
    if (isEmpty())
        throw UnsupportedOperationException("Empty array can't be reduced.")
    var accumulator = this[0]
    for (index in 1..lastIndex) {
        accumulator = op(accumulator, this[index])
    }
    return accumulator
}

fun sumReduce(vararg nums: Int) =
    nums.reduce { acc, i -> acc + i }

fun sumReduceDoubles(vararg nums: Int) =
    nums.reduce { acc, i -> acc + 2 * i }

fun main() {
    val nums = intArrayOf(1, 3, 5, 7)
    println("nums = ${nums.contentToString()}")
    println("sumReduce(*nums) = ${sumReduce(*nums)}")
    println()
    println("sumReduceDoubles(*nums) = ${sumReduceDoubles(*nums)}")
}
