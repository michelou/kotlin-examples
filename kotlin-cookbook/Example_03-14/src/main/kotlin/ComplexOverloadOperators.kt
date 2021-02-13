// Example 3-14

import org.apache.commons.math3.complex.Complex

operator fun Complex.plus(c: Complex) = this.add(c)
operator fun Complex.plus(d: Double) = this.add(d)
operator fun Complex.minus(c: Complex) = this.subtract(c)
operator fun Complex.minus(d: Double) = this.subtract(d)
operator fun Complex.div(c: Complex) = this.divide(c)
operator fun Complex.div(d: Double) = this.divide(d)
operator fun Complex.times(c: Complex) = this.multiply(c)
operator fun Complex.times(d: Double) = this.multiply(d)
operator fun Complex.times(i: Int) = this.multiply(i)
operator fun Double.times(c: Complex) = c.multiply(this)
operator fun Complex.unaryMinus() = this.negate()

fun main() {
    val x = Complex(1.0, 3.0)
    val y = Complex(2.0, 5.0)
    println("x   = ${x}")
    println("y   = ${y}")
    println("x+y = ${x+y}")  // (xr + yr, xi + yi)
    println("x*y = ${x*y}")  // (xr * yr - xi * yi, xr * yi + xi * yr)
}
