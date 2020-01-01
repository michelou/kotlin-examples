# <span id="top">*Learn Kotlin* Tutorial</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from the <a href="https://developer.ibm.com/series/learn-kotlin/">Learn Kotlin</a> tutorial <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

## [Unit 4][unit_4]

This tutorial part presents the Kotlin primitive types and literals, i.e. [Boolean](Unit_4/src/main/kotlin/BooleanExample.kt), [Byte](Unit_4/src/main/kotlin/ByteExample.kt), [Char](Unit_4/src/main/kotlin/CharExample.kt), [Double](Unit_4/src/main/kotlin/DoubleExample.kt), [Float](Unit_4/src/main/kotlin/FloatExample.kt), [Int](Unit_4/src/main/kotlin/IntExample.kt), [Long](Unit_4/src/main/kotlin/LongExample.kt) and [Short](Unit_4/src/main/kotlin/ShortExample.kt).

<pre style="font-size:80%;">
<b>&gt; build</b>
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

For instance, command **`build clean run`** executes all examples while command **`build clean run:Double`** executes *only* example [DoubleExample.kt](Unit_4/src/main/kotlin/DoubleExample.kt):

<pre style="font-size:80%;">
<b>&gt; build clean run:Double</b>
The value of doubleMin is: 4.9E-324
The value of doubleMax is: 1.7976931348623157E308
The value of double(1000000000000.0001) is: 1.0000000000000001E12
The value of double(1.0e22) is: 1.0E22
The value of double(-Double.MAX_VALUE) is: -1.7976931348623157E308
</pre>

## [Unit 5][unit_5]

This tutorial part presents Kotling binary operators and basic functions
- either in source file [src\main\kotlin\Examples.kt](Unit_5/src/main/kotlin/Examples.kt)
- or in script file [src\Examples.kts](Unit_5/src/Examples.kts)

<pre style="font-size:80%;">
<b>&gt; build</b>
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

For instance, command **`build -script -verbose run`** executes the script file [src\Examples.kts](Unit_5/src/Examples.kts) instead of the source file [src\main\kotlin\Examples.kt](Unit_5/src/main/kotlin/Examples.kt):

<pre>
<b>&gt; build -script -verbose run</b>
Execute Kotlin script file "src\Examples.kts"
byte10 = 10
</pre>

## [Unit 6][unit_6]

This tutorial part introduces Kotlin classes, i.e. class [Person](src/main/kotlin/example1/Person.kt).

<pre style="font-size:80%;">
<b>&gt; build</b>
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

## [Unit 7][unit_7]

This tutorial part presents more advanced Kotlin features, such as default arguments, function types, names arguments and nullable variables.

<pre style="font-size:80%;">
<b>&gt; build</b>
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

## Footnotes

<a name="footnote_01">[1]</a> ***Learn Kotlin* Tutorial** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Tutorial by Steven Perry:
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

*[mics](http://lampwww.epfl.ch/~michelou/)/January 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[unit_4]: https://developer.ibm.com/tutorials/learn-kotlin-4/
[unit_5]: https://developer.ibm.com/tutorials/learn-kotlin-5/
[unit_6]: https://developer.ibm.com/tutorials/learn-kotlin-6/
[unit_7]: https://developer.ibm.com/tutorials/learn-kotlin-7/