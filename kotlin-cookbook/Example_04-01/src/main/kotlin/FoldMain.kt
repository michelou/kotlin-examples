// Example 4-1 / 4-3

import java.math.BigInteger;

fun sum(vararg nums: Int) =
    nums.fold(0) { acc, n -> acc + n }

fun sumWithTrace(vararg nums: Int) =
    nums.fold(0) { acc, n ->
        println("acc = $acc, n = $n")
        acc + n
    }

fun factorialFold(n: Long): BigInteger =
    when (n) {
        0L, 1L -> BigInteger.ONE
        else   -> (2..n).fold(BigInteger.ONE) { acc, i ->
            acc * BigInteger.valueOf(i)
        }
    }

fun fibonacciFold(n: Int) =
    (2 until n).fold(1 to 1) { (prev, curr), _ ->
        curr to (prev + curr)
    }.second

fun main() {
    val nums = intArrayOf(1, 3, 5, 7)
    println("nums = ${nums.contentToString()}")
    println("sum(*nums) = ${sum(*nums)}")
    println()
    println("sumWithTrace(*nums) = ${sumWithTrace(*nums)}")
    println()
    println("factorialFold(20) = ${factorialFold(20)}")
    println()
    println("fibonacciFold(20) = ${fibonacciFold(20)}")
}
