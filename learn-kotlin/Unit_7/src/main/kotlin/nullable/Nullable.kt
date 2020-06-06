/*
 * Copyright 2018 Makoto Consulting Group, Inc
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 *
 */

package com.makotogo.learn.kotlin.nullable

import com.makotogo.learn.kotlin.defaultargs.createLocalDate
import java.time.LocalDate
import java.time.format.DateTimeFormatter

fun formatLocalDateLenient(localDate: LocalDate, formatString: String?): String {
    return formatLocalDate(localDate, formatString ?: "yyyy/MM/dd")
}

fun formatLocalDate(localDate: LocalDate, formatString: String): String {
    val dateTimeFormatter = DateTimeFormatter.ofPattern(formatString)
    return localDate.format(dateTimeFormatter)
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {

    var formatString: String? = null

    println("Hooray! It's: ${formatLocalDateLenient(createLocalDate(1999, 12, 31), formatString)}")

    formatString = "dd MMMM yyyy"

    println("Hooray! It's: ${formatLocalDate(createLocalDate(1999, 12, 31), formatString)}")
}
