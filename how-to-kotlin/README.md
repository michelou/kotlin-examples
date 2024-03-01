# <span id="top">*How to Kotlin* code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="../docs/kotlin.png" width="120" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <code>how-to-kotlin\</code> contains <a href="https://kotlinlang.org/">Kotlin</a> code examples from <a href="https://events.google.com/io2018/schedule/?section=may-10&sid=7387180b-b1dd-49c3-bddf-de3f87ae1990">Andrey Breslav's talk</a> "<i>How to Koltin</i>" at <a href="https://events.google.com/io2018/schedule/?section=may-10" rel="external">Google I/O 2018</a>  (9:30 am).<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html">Gradle scripts</a>) for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
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

| Build tool          | Build&nbsp;file  | Parent&nbsp;file | Environment(s) |
|---------------------|------------------|------------------|----------------|
| [**`ant.bat`**][apache_ant_cli] | [`build.xml`](01_bean/build.xml) | &nbsp; | Any <sup><b>a)</b></sup> |
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](01_bean/build.bat) | [`cpath.bat`](cpath.bat) <sup><b>b)</b></sup> | MS Windows |
| [**`sh.exe`**][sh_cli] | [`build.sh`](01_bean/build.sh) |  | [Cygwin]/[MSYS2]/Unix |
| [**`gradle.bat`**][gradle_cli] | [`build.gradle`](01_bean/build.gradle) | [`common.gradle`](common.gradle) | Any |
| [**`mvn.cmd`**][maven_cli] | [`pom.xml`](01_bean/pom.xml) | [`pom.xml`](pom.xml)  | Any |
| [**`make.exe`**][gmake_cli] | [`Makefile`](01_bean/Makefile) | [`Makefile.inc`](./Makefile.inc)  | Any |
<div style="margin:0 15% 0 8px;font-size:90%;">
<sup><b>a)</b></sup></b> Here "Any" means "tested on MS Windows / Cygwin / MSYS2 / Unix".<br/>
<sup><b>b)</b></sup> This utility batch file manages <a href="https://maven.apache.org/">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>&nbsp;
</div>

Batch command [**`build.bat`**](01_bean/build.bat) with no argument (or with subcommand **`help`**) displays the help message.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
bean_01
&nbsp;
<b>&gt; <a href="01_bean/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug      show commands executed by this script
    -native     generated native executable
    -timer      print total execution time
    -verbose    print progress messages

  Subcommands:
    clean       delete generated files
    compile     generate class files
    help        print this help message
    lint        analyze Kotlin source files with KtLint
    run         execute the generated program
</pre>

> **:mag_right:** Adding ption **`-debug`**  also prints the executed commands:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="01_bean/build.bat">build</a> -debug clean run</b>
> [build] Properties : _PROJECT_NAME=01_bean _PROJECT_VERSION=0.1-SNAPSHOT
> [build] Options    : _TARGET=jvm _TIMER=0 _VERBOSE=0
> [build] Subcommands: _CLEAN=1 _COMPILE=1 _DETEKT=0 _DOC=0 _LINT=0 _RUN=1
> [build] Variables  : "JAVA_HOME=c:\opt\jdk-temurin-11.0.21_9"
> [build] Variables  : "KOTLIN_HOME=C:\opt\kotlinc-1.9.21"
> [buidl] Variables  : "KOTLIN_NATIVE_HOME=C:\opt\kotlin-native-windows-1.9.21"
> [build] Variables  : _LANGUAGE_VERSION=1.5 _MAIN_CLASS=_01_bean.BeanKt
> [build] rmdir /s /q "K:\how-to-kotlin\01_bean\target"
> [build] "C:\opt\kotlinc-1.9.10\bin\kotlinc.bat" "@K:\how-to-kotlin\01_bean\target\kotlinc_opts.txt" "@K:\how-to-kotlin\01_bean\target\kotlinc_sources.txt"
> [build] "C:\opt\kotlinc-1.9.10\bin\kotlin.bat" -cp "K:\how-to-kotlin\01_bean\target\classes" _01_bean.BeanKt
> fist=Jane, last=Doe
> [build] _EXITCODE=0
> </pre>

## <span id="bean">Bean</span>

This example is about [data classes][kotlin_data_classes] whose main purpose is to hold data.

Command [**`build.bat clean run`**](01_bean/build.bat) compiles source file [**`Bean.kt`**](01_bean/src/main/kotlin/Bean.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="01_bean/build.bat">build</a> clean run</b>
fist=Jane, last=Doe
</pre>

Command [**`gradle.bat -q clean run`**][gradle_cli] (build script [**`build.gradle`**](01_bean/build.gradle) and property file [**`gradle.properties`**](01_bean/gradle.properties)) performs the same operations:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run</b>
fist=Jane, last=Doe
</pre>

Command [**`mvn -q clean compile exec:java`**][maven_cli] (build script [**`pom.xml`**](01_bean/pom.xml) prints the same result:

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
Command **`build.bat clean run`** compiles source files [**`Expressions.kt`**](04_expressions/src/main/kotlin/Expressions.kt) and executes the generated Java class files.

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

Command [**`build.bat clean run`**](04_functional/build.bat) compiles source file [**`Lambdas.kt`**](04_functional/src/main/kotlin/Lambdas.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="04_functional/build.bat">build</a> clean run</b>
a = 1, b = null, c = true
k1 -> 1
k2 -> 2
k3 -> 3
Yay!
Luck!
</pre>

## <span id="threads">ThreadsVsCoroutines</span>

Command [**`build clean run`**](05_coroutines/build.bat) compiles source file [**`ThreadsVsCoroutines.kt`**](05_coroutines/src/main/kotlin/ThreadsVsCoroutines.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="../bin/timeit.bat">timeit</a> <a href="05_coroutines/build.bat">build</a> clean run</b>
0
1
..
99999
Execution time: 00:00:35
</pre>

## <span id="callbacks">CallbacksToCoroutines</span>

Command [**`build clean run`**](05_coroutines/build.bat) compiles source file [**`CallbackToCoroutines.kt`**](05_coroutines/src/main/kotlin/CallbackToCoroutines.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="05_coroutines/build.bat">build</a> clean run:CallbackToCoroutines</b>
hi 2
 -- Yours, 1
hi 1
 -- Yours, 2
hi a
 -- Yours, 1
hi b
 -- Yours, 1
hi c
 -- Yours, 1
</pre>

## <span id="lazy_sequence">LazySequence</span>

Command [**`build.bat clean run`**](06_lazy_seq/build.bat) compiles source file [**`LazySequence.kt`**](06_lazy_seq/src/main/kotlin/LazySequence.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="06_lazy_seq/build.bat">build</a> clean run</b>
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765]
</pre>

## <span id="conventions">Conventions</span>

This example is about [operator conventions][kotlin_conventions], an elegant way to overload operators in [Kotlin][kotlin].

Command [**`build.bat clean run`**](07_conventions/build.bat) compiles source file [**`Conventions.kt`**](07_conventions/src/main/kotlin/Conventions.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="07_conventions/build.bat">build</a> clean run</b>
date: Date(day=25, month=2, year=2018)
day/month/year: 25/2/2018
date belongs to Month(month=3, year=2018): false
date range: Date(day=1, month=1, year=2018)..Date(day=31, month=12, year=2018)
</pre>

## <span id="local_sealed_casts">LocalSealedCasts</span>

Command [**`build.bat clean run`**](08_DSLs/build.bat) compiles source file [**`LocalSealedCasts.kt`**](08_DSLs/src/main/kotlin/LocalSealedCasts.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="07_conventions/build.bat">build</a> clean run</b>
abcd
</pre>

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[cygwin]: https://cygwin.com/install.html
[gmake_cli]: https://www.gnu.org/software/make/manual/make.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[kotlin]: https://kotlinlang.org/
[kotlin_conventions]: https://kotlinlang.org/docs/reference/operator-overloading.html
[kotlin_data_classes]: https://kotlinlang.org/docs/reference/data-classes.html
[kotlin_extensions]: https://kotlinlang.org/docs/tutorials/kotlin-for-py/extension-functionsproperties.html
[kotlin_lambdas]: https://kotlinlang.org/docs/reference/lambdas.html
[kotlin_lazy_props]: https://www.kotlindevelopment.com/lazy-property/
[maven_cli]: https://maven.apache.org/ref/3.8.1/maven-embedder/cli.html
[msys2]: https://www.msys2.org/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
