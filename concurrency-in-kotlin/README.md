# <span id="top">Book &ndash; *Concurrency in Kotlin*</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="../docs/kotlin.png" width="120" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <code>concurrency-in-kotlin\</code> contains <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from the <a href="https://www.packtpub.com/application-development/learning-concurrency-kotlin">Learn Concurrency in Kotlin</a> book <sup id="anchor_01"><a href="#footnote_01">1</a></sup>.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

Code examples can be built/run with the following tools:

| Build tool                     | Configuration file               | Parent file         | Environment(s) |
|--------------------------------|------------------------------------|--------------------|----------------|
| [**`gradle.exe`**][gradle_cli] | [**`build.gradle`**](ch01/build.gradle) |  | Any <sup><b>a)</b></sup> |
| [**`mvn.cmd`**][maven_cli]     | [**`pom.xml`**](ch01/pom.xml)           | [**`pom.xml`**](./pom.xml) | Any |
| [**`build.bat`**](ch01/build.bat)   | *none*                             |  | Windows only |
<div style="margin:0 20% 0 8px;font-size:90%;">
<sup>a)</sup></b> Here "Any" means "tested on Windows / Cygwin / MSYS2 / Unix".<br/>&nbsp;
</div>

## <span id="coroutine_example">Coroutine Example</span>

The Gradle build configuration is defined by the two files <a href="ch01/build.gradle"><code>build.gradle</code></a> and 
<a href="ch01/gradle.properties"><code>gradle.properties</code></a>.

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

<span id="footnote_01">[1]</span> *Literature* [↩](#anchor_01)

<dl><dd>
<a href="https://www.packtpub.com/product/learning-concurrency-in-kotlin/9781788627160">Learn Concurrency in Kotlin</a> by Miguel Angel Castiblanco Torre, July 2018.<br/>
<span style="font-size:80%;">(Packt Publishing (ISBN: 978-1-7886-2716-0).</span>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/May 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
