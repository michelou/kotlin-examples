# <span id="top">*Learn Kotlin* Tutorial</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from the <a href="https://developer.ibm.com/series/learn-kotlin/" rel="external">Learn Kotlin</a> tutorial <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> (<a href="https://github.com/jstevenperry/IBM-Developer/tree/master/Kotlin">GitHub</a> repository).<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

> **:mag_right:** The following Kotlin code examples, *originally* written by [Steven Perry](https://github.com/jstevenperry) in 2018, have updated to Kotlin 1.4 and formatted with [Ktlint](https://ktlint.github.io/).

## <span id="unit_4">[Unit 4][unit_4]</span>

This tutorial part presents the Kotlin primitive types and literals, i.e. [Boolean](Unit_4/src/main/kotlin/BooleanExample.kt), [Byte](Unit_4/src/main/kotlin/ByteExample.kt), [Char](Unit_4/src/main/kotlin/CharExample.kt), [Double](Unit_4/src/main/kotlin/DoubleExample.kt), [Float](Unit_4/src/main/kotlin/FloatExample.kt), [Int](Unit_4/src/main/kotlin/IntExample.kt), [Long](Unit_4/src/main/kotlin/LongExample.kt) and [Short](Unit_4/src/main/kotlin/ShortExample.kt).

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_4/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug            show commands executed by this script
    -timer            display total elapsed time
    -verbose          display progress messages
&nbsp;
  Subcommands:
    clean             delete generated files
    compile[:&lt;name&gt;]  generate class files
    help              display this help message
    lint[:&lt;name&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;name&gt;]      execute the generated program
  Valid names are: All (default), Boolean, Byte, Char, Double, Float, Int, Long, Short
</pre>

For instance, command **`build clean run`** executes all examples while command **`build clean run:Double`** executes *only* example [**`DoubleExample.kt`**](Unit_4/src/main/kotlin/DoubleExample.kt):

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_4/build.bat">build</a> clean run:Double</b>
The value of doubleMin is: 4.9E-324
The value of doubleMax is: 1.7976931348623157E308
The value of double(1000000000000.0001) is: 1.0000000000000001E12
The value of double(1.0e22) is: 1.0E22
The value of double(-Double.MAX_VALUE) is: -1.7976931348623157E308
</pre>

## <span id="unit_5">[Unit 5][unit_5]</span>

This tutorial part presents [Kotlin] binary operators and basic functions
- either in source file [**`Examples.kt`**](Unit_5/src/main/kotlin/Examples.kt)
- or in script file [**`Examples.kts`**](Unit_5/src/Examples.kts)

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_5/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug            show commands executed by this script
    -script           execute the Kotlin script
    -timer            display total elapsed time
    -verbose          display progress messages

  Subcommands:
    clean             delete generated files
    compile[:&lt;name&gt;]  generate class files
    help              display this help message
    lint[:&lt;name&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;name&gt;]      execute the generated program
  Valid names are: all (default), examples
</pre>

For instance, command **`build -script -verbose run`** executes the script file [`Examples.kts`](Unit_5/src/Examples.kts) instead of the source file [`Examples.kt`](Unit_5/src/main/kotlin/Examples.kt):

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_5/build.bat">build</a> -script -verbose run</b>
Execute Kotlin script file "src\Examples.kts"
byte10 = 10
</pre>

## <span id="unit_6">[Unit 6][unit_6]</span>

This tutorial part introduces Kotlin classes, i.e. class [**`Person.kt`**](Unit_6/src/main/kotlin/example1/Person.kt).

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_6/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug         show commands executed by this script
    -timer         display total elapsed time
    -verbose       display progress messages
&nbsp;
  Subcommands:
    clean          delete generated files
    compile[:&lt;n&gt;]  generate class files
    help           display this help message
    lint[:&lt;n&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;n&gt;]      execute the generated program
  Valid values: n=1..4 (default=2)
</pre>

## <span id="unit_7">[Unit 7][unit_7]</span>

This tutorial part presents more advanced Kotlin features, such as default arguments, function types, names arguments and nullable variables i.e. [**`Default.kt`**](Unit_7/src/main/kotlin/defaultargs), [**`FunctionTypes.kt`**](Unit_7/src/main/kotlin/functiontypes), [**`Named.kt`**](Unit_7/src/main/kotlin/namedargs) and [**`Nullable.kt`**](Unit_7/src/main/kotlin/nullable).

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_7/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug            show commands executed by this script
    -timer            display total elapsed time
    -verbose          display progress messages

  Subcommands:
    clean             delete generated files
    compile[:&lt;name&gt;]  generate class files
    help              display this help message
    lint[:&lt;name&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;name&gt;]      execute the generated program
  Valid names are: defaultargs (default), functiontypes, namedargs, nullable
</pre>

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***Learn Kotlin* Tutorial** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Tutorial by Steven Perry (<a href="https://github.com/jstevenperry/IBM-Developer/tree/master/Kotlin">GitHub</a> repository):
</p>
<ul>
<li><a href="https://developer.ibm.com/series/learn-kotlin/">Unit 1</a> : Overview of the Kotlin learning path.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-2/">Unit 2</a> : Set up your Kotlin development environment.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-3/">Unit 3</a> : Object- and function-oriented programming concepts and principles.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-4/">Unit 4</a> : Get started with Kotlin.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-5/">Unit 5</a> : More Kotlin basics.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-6/">Unit 6</a> : Your first Kotlin class.</li>
<li><a href="https://developer.ibm.com/tutorials/learn-kotlin-7/">Unit 7</a> : All about functions.</li>
</ul>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[unit_4]: https://developer.ibm.com/tutorials/learn-kotlin-4/
[unit_5]: https://developer.ibm.com/tutorials/learn-kotlin-5/
[unit_6]: https://developer.ibm.com/tutorials/learn-kotlin-6/
[unit_7]: https://developer.ibm.com/tutorials/learn-kotlin-7/
