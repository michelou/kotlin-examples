# <span id="top">Book &ndash; *Concurrency in Kotlin*</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from the <a href="https://www.packtpub.com/application-development/learning-concurrency-kotlin">Learn Concurrency in Kotlin</a> book <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

Code examples can be built/run with the following tools:

| Build tool                     | Configuration file(s)              | Parent file(s)     | Environment(s) |
|--------------------------------|------------------------------------|--------------------|----------------|
| [**`gradle.exe`**][gradle_cli] | [**`build.gradle`**](build.gradle) |  | Multiplatform <sup><b>a)</b></sup> |
| [**`mvn.cmd`**][maven_cli]     | [**`pom.xml`**](pom.xml)           |  | Multiplatform |
| [**`build.bat`**](build.bat)   | *none*                             |  | Windows only |
<div style="margin:0 30% 0 8px;font-size:90%;">
<sup>a)</sup></b> Multiplatform = Windows / Cygwin / MSYS2 / Unix.<br/>&nbsp;
</div>

## <span id="coroutine_example">Coroutine Example</span>

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> clean run</b>
1 threads active at the start
Started 1 in main
Started 2 in main
...
Started 9999 in main
Started 10000 in main
Finished 1 in main
Finished 2 in main
...
Finished 9999 in main
Finished 10000 in main
1 threads active at the end
Took 1450 ms
</pre>

## <span id="concurrent_example">Concurrent Example</span>

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> clean run</b>

> Task :run
Hello, Susan Calvin
Execution took 2040 ms

Hello, Susan Calvin
Execution took 1034 ms
</pre>

## <span id="footnotes">Footnotes</span>

<span name="footnote_01">[1]</span> ***Learn Concurrency in Kotlin** Book* [↩](#anchor_01)
    <div style="margin:-12px 0 0 20px;">
    by Miguel Angel Castiblanco Torres,<br/>
    Packt Publishing (ISBN: 9781788627160), July 2018.
    </div>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/May 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
