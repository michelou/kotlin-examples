# <span id="top">How to Kotlin code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples from <a href="https://events.google.com/io2018/schedule/?section=may-10&sid=7387180b-b1dd-49c3-bddf-de3f87ae1990">Andrey Breslav's talk</a> (9:30 am) at <a href="https://events.google.com/io2018/schedule/?section=may-10">Google I/O 2018</a>.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
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

We actually provide two ways to build/run our [Kotlin] code examples:
- **`build.bat`**
- [**`gradle.bat`**][gradle_bat]

<pre style="font-size:80%;">
<b>&gt; build</b>
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

## <span id="bean">Bean</span>

Command [**`build clean run`**](01_bean/build.bat) compiles source file [**`Bean.kt`**](01_bean/src/main/kotlin/Bean.kt) and executes the generated Java class files:
<pre style="font-size:80%;">
<b>&gt; build clean run</b>
fist=Jane, last=Doe
</pre>

Command [**`gradle -q clean run`**][gradle_bat] (build script [**`build.gradle`**](01_bean/build.gradle) and property file [**`gradle.properties`**](01_bean/gradle.properties)) performs the same operations:

<pre style="font-size:80%;">
<b>&gt; gradle -q clean run</b>
fist=Jane, last=Doe
</pre>

## <span id="properties">Properties</span>

## <span id="functions">Functions</span>

## <span id="expressions">Expressions</span>

## <span id="lambdas">Lambdas</span>

## <span id="callbacks">CallbacksToCoroutines</span>

## <span id="threads">ThreadsVsCoroutines</span>

## <span id="lazy_sequence">LazySequence</span>

## <span id="conventions">Conventions</span>

## <span id="local_sealed_casts">LocalSealedCasts</span>

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[kotlin]: https://kotlinlang.org/