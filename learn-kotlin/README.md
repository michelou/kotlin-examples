# <span id="top">*Learn Kotlin* Tutorial</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/" rel="external"><img src="../docs/kotlin.png" width="120" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <a href="."><code>learn-kotlin\</code></a> gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from the <a href="https://developer.ibm.com/series/learn-kotlin/" rel="external">Learn Kotlin</a> tutorial <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> (<a href="https://github.com/jstevenperry/IBM-Developer/tree/master/Kotlin" rel="external">GitHub</a> repository).<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

> **:mag_right:** The following Kotlin code examples, *originally* written by [Steven Perry](https://github.com/jstevenperry) in 2018, have been updated to Kotlin 1.6 and formatted with [Ktlint](https://ktlint.github.io/).

## <span id="unit_02">[Unit 2][unit_02]</span>

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Unit_02/build.bat">build.bat</a>
|   <a href="./Unit_02/build.gradle">build.gradle</a>
|   <a href="./Unit_02/build.sh">build.sh</a>
|   <a href="./Unit_02/build.xml">build.xml</a>
|   <a href="./Unit_02/gradle.properties">gradle.properties</a>
|   <a href="./Unit_02/Makefile">Makefile</a>
|   <a href="./Unit_02/pom.xml">pom.xml</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>kotlin</b>
                <a href="./Unit_02/src/main/kotlin/Example1.kt">Example1.kt</a>
                <a href="./Unit_02/src/main/kotlin/Example2.kt">Example2.kt</a>
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="./Unit_02/build.bat">build</a> -verbose clean run</b>
Compile 2 Kotlin source files to directory "target\classes"
Execute Kotlin main class "com.makotojava.learn.kotlin.example2.Example2Kt"
Greetings from example 2
</pre>

## <span id="unit_04">[Unit 4][unit_04]</span>

This tutorial part presents the Kotlin primitive types and literals; it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Unit_04/00download.txt">00download.txt</a>
|   <a href="./Unit_04/build.bat">build.bat</a>
|   <a href="./Unit_04/build.gradle">build.gradle</a>
|   <a href="./Unit_04/build.sh">build.sh</a>
|   <a href="./Unit_04/build.xml">build.xml</a>
|   <a href="./Unit_04/gradle.properties">gradle.properties</a>
|   <a href="./Unit_04/Makefile">Makefile</a>
|   <a href="./Unit_04/pom.xml">pom.xml</a>
\---<b>src</b>
    +---<b>main</b>
    |   \---<b>kotlin</b>
    |           <a href="./Unit_04/src/main/kotlin/BooleanExample.kt">BooleanExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/ByteExample.kt">ByteExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/CharExample.kt">CharExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/DoubleExample.kt">DoubleExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/FloatExample.kt">FloatExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/IntExample.kt">IntExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/LongExample.kt">LongExample.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/Primitives.kt">Primitives.kt</a>
    |           <a href="./Unit_04/src/main/kotlin/ShortExample.kt">ShortExample.kt</a>
    \---<b>test</b>
        \---<b>kotlin</b>
                <a href="./Unit_04/src/test/kotlin/PrimitivesTest.kt">PrimitivesTest.kt</a>
</pre>

For instance, command **`build clean run`** executes all examples while command **`build clean run:Double`** executes *only* example [**`DoubleExample.kt`**](Unit_04/src/main/kotlin/DoubleExample.kt):

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_04/build.bat">build</a> clean run:Double</b>
The value of doubleMin is: 4.9E-324
The value of doubleMax is: 1.7976931348623157E308
The value of double(1000000000000.0001) is: 1.0000000000000001E12
The value of double(1.0e22) is: 1.0E22
The value of double(-Double.MAX_VALUE) is: -1.7976931348623157E308
</pre>

## <span id="unit_05">[Unit 5][unit_05]</span>

This tutorial part presents [Kotlin] binary operators and basic functions
- either in source file [**`Examples.kt`**](Unit_05/src/main/kotlin/Examples.kt)
- or in script file [**`Examples.kts`**](Unit_05/src/Examples.kts)

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_05/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug            print commands executed by this script
    -script           execute the Kotlin script
    -timer            print total execution time
    -verbose          print progress messages

  Subcommands:
    clean             delete generated files
    compile[:&lt;name&gt;]  generate class files
    help              print this help message
    lint[:&lt;name&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;name&gt;]      execute the generated program
  Valid names are: all (default), examples
</pre>

For instance, command **`build -script -verbose run`** executes the script file [`Examples.kts`](Unit_05/src/Examples.kts) instead of the source file [`Examples.kt`](Unit_05/src/main/kotlin/Examples.kt):

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_05/build.bat">build</a> -script -verbose run</b>
Execute Kotlin script file "src\Examples.kts"
byte10 = 10
</pre>

## <span id="unit_06">[Unit 6][unit_06]</span> [**&#x25B4;**](#top)

This tutorial part introduces [Kotlin] classes; it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Unit_06/00download.txt">00download.txt</a>
|   <a href="./Unit_06/build.bat">build.bat</a>
|   <a href="./Unit_06/build.gradle">build.gradle</a>
|   <a href="./Unit_06/build.sh">build.sh</a>
|   <a href="./Unit_06/build.xml">build.xml</a>
|   <a href="./Unit_06/gradle.properties">gradle.properties</a>
|   <a href="./Unit_06/Makefile">Makefile</a>
|   <a href="./Unit_06/pom.xml">pom.xml</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>kotlin</b>
            +---<b>example1</b>
            |       <a href="./Unit_06/src/main/kotlin/example1/Person.kt">Person.kt</a>
            +---<b>example2</b>
            |       <a href="./Unit_06/src/main/kotlin/example2/Person.kt">Person.kt</a>
            +---<b>example3</b>
            |       <a href="./Unit_06/src/main/kotlin/example3/Person.kt">Person.kt</a>
            \---<b>example4</b>
                    <a href="./Unit_06/src/main/kotlin/example4/Family.kt">Family.kt</a>
                    <a href="./Unit_06/src/main/kotlin/example4/Neighbor.kt">Neighbor.kt</a>
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_06/build.bat">build</a> -verbose clean run</b>
Compile 5 Kotlin source files to directory "target\classes"
Execute Kotlin main class "com.makotogo.learn.kotlin.example2.PersonKt"
Person: Family Name=Neumann, Given Name=Susan, Date of Birth=1980-03-17
</pre>

## <span id="unit_07">[Unit 7][unit_07]</span>

This tutorial part presents more advanced [Kotlin] features, such as default arguments, function types, names arguments and nullable variables i.e. [**`Default.kt`**](Unit_07/src/main/kotlin/defaultargs), [**`FunctionTypes.kt`**](Unit_07/src/main/kotlin/functiontypes), [**`Named.kt`**](Unit_07/src/main/kotlin/namedargs) and [**`Nullable.kt`**](Unit_07/src/main/kotlin/nullable).

<pre style="font-size:80%;">
<b>&gt; <a href="Unit_07/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug            print commands executed by this script
    -timer            print total execution time
    -verbose          print progress messages

  Subcommands:
    clean             delete generated files
    compile[:&lt;name&gt;]  generate class files
    help              print this help message
    lint[:&lt;name&gt;]     analyze Kotlin source files and flag programming/stylistic errors
    run[:&lt;name&gt;]      execute the generated program
  Valid names are: defaultargs (default), functiontypes, namedargs, nullable
</pre>

## <span id="unit_08">Unit 8</span>

Source file [`Strings.kt`](Unit_08/src/main/kotlin/Strings.kt) presents the usage of string literals, string templates and string operations.

## <span id="unit_09">Unit 9</span> [**&#x25B4;**](#top)

Source file [`Equality.kt`](Unit_09/src/main/kotlin/Equality.kt) presents the differences betwen stuctural and reference equality; other files present their usage with comparison operators ([`Comparison.kt`](Unit_09/src/main/kotlin/Comparison.kt)) and conditional constructs ([`If.kt`](Unit_09/src/main/kotlin/If.kt), [`When.kt`](Unit_09/src/main/kotlin/When.kt)).

## <span id="unit_10">Unit 10</span>

This unit presents iterative constructs; it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f | <a href="">findstr</a> /v /b [A-Z]</b>
|   <a href="./Unit_10/build.bat">build.bat</a>
|   <a href="./Unit_10/build.gradle">build.gradle</a>
|   <a href="./Unit_10/build.xml">build.xml</a>
|   <a href="./Unit_10/gradle.properties">gradle.properties</a>
|   <a href="./Unit_10/Makefile">Makefile</a>
|   <a href="./Unit_10/pom.xml">pom.xml</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>kotlin</b>
                <a href="./Unit_10/src/main/kotlin/Arrays.kt">Arrays.kt</a>
                <a href="./Unit_10/src/main/kotlin/For.kt">For.kt</a>
                <a href="./Unit_10/src/main/kotlin/Main.kt">Main.kt</a>
                <a href="./Unit_10/src/main/kotlin/Ranges.kt">Ranges.kt</a>
                <a href="./Unit_10/src/main/kotlin/While.kt">While.kt</a>
</pre>

## <span id="footnotes">Footnotes</span>

<span name="footnote_01">[1]</span> ***Learn Kotlin* Tutorial** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
The 7 first units from Steven Perry's tutorial (<a href="https://github.com/jstevenperry/IBM-Developer/tree/master/Kotlin">GitHub</a> repository) are available from <a href="https://developer.ibm.com">IBM Developer</a> network :
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

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[kotlin]: https://kotlinlang.org/
[unit_02]: https://developer.ibm.com/tutorials/learn-kotlin-2/
[unit_04]: https://developer.ibm.com/tutorials/learn-kotlin-4/
[unit_05]: https://developer.ibm.com/tutorials/learn-kotlin-5/
[unit_06]: https://developer.ibm.com/tutorials/learn-kotlin-6/
[unit_07]: https://developer.ibm.com/tutorials/learn-kotlin-7/
