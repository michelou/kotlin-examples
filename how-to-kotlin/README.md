# <span id="top">*How to Kotlin* code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples from <a href="https://events.google.com/io2018/schedule/?section=may-10&sid=7387180b-b1dd-49c3-bddf-de3f87ae1990">Andrey Breslav's talk</a> "<i>How to Koltin</i>" at <a href="https://events.google.com/io2018/schedule/?section=may-10" rel="external">Google I/O 2018</a>  (9:30 am).<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>/<a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html">Gradle scripts</a> for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

In this document we present the following [Kotlin] code examples:

- [01_bean](01_bean/) - [Bean](#bean)
- [02_properties](02_properties/) - [Properties](#properties)
- [03_functions](03_functions/) - [Functions](#functions)
- [04_expressions](04_expressions/) - [Expressions](#expressions)
- [04_functional](04_functional/) - [Lambdas](#lambdas)
- [05_coroutines](05_coroutines/) - [CallbackToCoroutines](#callbacks)
- [05_coroutines](05_coroutines/) - [ThreadsVsCoroutines](#threads)
- [06_lazy_seq](06_lazy_seq) - [LazySequence](#lazy_sequence)
- [07_conventions](07_conventions) - [Conventions](#conventions)
- [08_DSLs](09_DSLs) - [LocalSealedCasts](#local_sealed_casts)

We provide several ways to build/run our [Kotlin] code examples:

| Build tool          | Configuration file(s)  | Parent file(s) | Environment(s) |
|---------------------|------------------------|----------------|----------------|
| [**`ant.bat`**][apache_ant_cli] | [**`build.xml`**](HelloWorld/build.xml) | &nbsp; | Multiplatform <sup><b>a)</b></sup> |
| [**`build.bat`**](01_bean/build.bat) | &nbsp;                 | [**`cpath.bat`**](cpath.bat) <sup><b>b)</b></sup> | MS Windows |
| [**`build.sh`**](HelloWorld/build.sh) | &nbsp; |  | [Cygwin]/[MSYS2]/Unix |
| **`gradle.exe`**    | [**`build.gradle`**](01_bean/build.gradle) | [**`common.gradle`**](common.gradle) | Multiplatform |
| **`mvn.cmd`**       | [**`pom.xml`**](01_bean/pom.xml) | [**`pom.xml`**](pom.xml)  | Multiplatform |
| [**`make.exe`**][gmake_cli] | [**`Makefile`**](HelloWorld/Makefile) | [**`Makefile.inc`**](./Makefile.inc)  | Multiplatform |
<div style="margin:0 30% 0 8px;font-size:90%;">
<sup><b>a)</b></sup></b> Multiplatform = MS Windows / Cygwin / MSYS2 / Unix.<br/>
<sup><b>b)</b></sup> This utility batch file manages <a href="https://maven.apache.org/">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>&nbsp;
</div>

Batch command [**`build.bat`**](01_bean/build.bat) with no argument (or with subcommand **`help`**) displays the help message.

<pre style="font-size:80%;">
<b>&gt; <a href="01_bean/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug      show commands executed by this script
    -native     generated native executable
    -timer      display total elapsed time
    -verbose    display progress messages

  Subcommands:
    clean       delete generated files
    compile     generate class files
    help        display this help message
    lint        analyze Kotlin source files with KtLint
    run         execute the generated program
</pre>

> **:mag_right:** Adding ption **`-debug`**  also prints the executed commands:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="01_bean/build.bat">build</a> -debug clean run</b>
> [build] Options    : _TIMER=0 _VERBOSE=0
> [build] Subcommands: _CLEAN=1 _COMPILE=1 _DETEKT=0 _DOC=0 _LINT=0 _RUN=1
> [build] Variables  : "KOTLIN_HOME=C:\opt\kotlinc-1.5.10"
> [buidl] Variables  : "KOTLIN_NATIVE_HOME=C:\opt\kotlin-native-windows-1.5.10"
> [build] Variables  : _MAIN_CLASS=_01_bean.BeanKt
> [build] rmdir /s /q "K:\how-to-kotlin\01_bean\target"
> [build] "C:\opt\kotlinc-1.5.10\bin\kotlinc.bat" "@K:\how-to-kotlin\01_bean\target\kotlinc_opts.txt" "@K:\how-to-kotlin\01_bean\target\kotlinc_sources.txt"
> [build] "C:\opt\kotlinc-1.5.10\bin\kotlin.bat" -cp "K:\how-to-kotlin\01_bean\target\classes" _01_bean.BeanKt
> fist=Jane, last=Doe
> [build] _EXITCODE=0
> </pre>

## <span id="bean">Bean</span>

This example is about [data classes][kotlin_data_classes] whose main purpose is to hold data.

Command [**`build clean run`**](01_bean/build.bat) compiles source file [**`Bean.kt`**](01_bean/src/main/kotlin/Bean.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="01_bean/build.bat">build</a> clean run</b>
fist=Jane, last=Doe
</pre>

Command [**`gradle -q clean run`**][gradle_cli] (build script [**`build.gradle`**](01_bean/build.gradle) and property file [**`gradle.properties`**](01_bean/gradle.properties)) performs the same operations:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run</b>
fist=Jane, last=Doe
</pre>

Command [**`mvn -q clean compile exec:java`**][mvn_cli] (build script [**`pom.xml`**](01_bean/pom.xml) prints the same result:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html">mvn</a> -q clean compile exec:java</b>
fist=Jane, last=Doe
</pre>

## <span id="properties">Properties</span>

This example is about [lazy properties][kotlin_lazy_props] whose value is initialized at the moment of the first access.

Command [**`build clean run`**](02_properties/build.bat) compiles source file [**`Properties.kt`**](02_properties/src/main/kotlin/Properties.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="02_properties/build.bat">build</a> clean run</b>
Computing...
Windows 10 v10.0 (amd64)
Windows 10 v10.0 (amd64)
Windows 10 v10.0 (amd64)
Computing...
Windows 10 v10.0 (amd64)
Windows 10 v10.0 (amd64)
Windows 10 v10.0 (amd64)
</pre>

## <span id="functions">Functions</span>

This example is about [extension functions][kotlin_extensions].

Command **`build clean run`** compiles source file [**`Functions.kt`**](03_functions/src/main/kotlin/Functions.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="03_functions/build.bat">build</a> clean run</b>
Jane
Jane
Jane
</pre>

## <span id="expressions">Expressions</span>

This example 
Command **`build clean run`** compiles source files [**`Expressions.kt`**](04_expressions/src/main/kotlin/Expressions.kt) and executes the generated Java class files.

<pre style="font-size:80%;">
<b>&gt; <a href="04_expressions/build.bat">build</a> clean run</b>
a = 1, b = null, c = true
k1 -> 1
k2 -> 2
k3 -> 3
Not this time
</pre>

## <span id="lambdas">Lambdas</span>

This example is about [higher-order functions and lambdas][kotlin_lambdas] in [Kotlin].

Command [**`build clean run`**](04_functional/build.bat) compiles source file [**`Lambdas.kt`**](04_functional/src/main/kotlin/Lambdas.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="04_functional/build.bat">build</a> clean run</b>
a = 1, b = null, c = true
k1 -> 1
k2 -> 2
k3 -> 3
Yay!
Luck!
</pre>

## <span id="callbacks">CallbacksToCoroutines</span>

## <span id="threads">ThreadsVsCoroutines</span>

## <span id="lazy_sequence">LazySequence</span>

## <span id="conventions">Conventions</span>

This example is about [operator conventions][kotlin_conventions], an elegant way to overload operators in [Kotlin][kotlin].

Command [**`build clean run`**](07_conventions/build.bat) compiles source file [**`Conventions.kt`**](07_conventions/src/main/kotlin/Conventions.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="07_conventions/build.bat">build</a> clean run</b>
date: Date(day=25, month=2, year=2018)
day/month/year: 25/2/2018
date belongs to Month(month=3, year=2018): false
date range: Date(day=1, month=1, year=2018)..Date(day=31, month=12, year=2018)
</pre>

## <span id="local_sealed_casts">LocalSealedCasts</span>

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[cygwin]: https://cygwin.com/install.html
[gmake_cli]: https://www.gnu.org/software/make/manual/make.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[kotlin]: https://kotlinlang.org/
[kotlin_conventions]: https://kotlinlang.org/docs/reference/operator-overloading.html
[kotlin_data_classes]: https://kotlinlang.org/docs/reference/data-classes.html
[kotlin_extensions]: https://kotlinlang.org/docs/tutorials/kotlin-for-py/extension-functionsproperties.html
[kotlin_lambdas]: https://kotlinlang.org/docs/reference/lambdas.html
[kotlin_lazy_props]: https://www.kotlindevelopment.com/lazy-property/
[mvn_cli]: https://maven.apache.org/ref/3.8.1/maven-embedder/cli.html
[msys2]: https://www.msys2.org/
