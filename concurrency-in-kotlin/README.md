# <span id="top">Book &ndash; *Concurrency in Kotlin*</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="../docs/kotlin.png" width="120" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <code>concurrency-in-kotlin\</code> contains <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from the <a href="https://www.packtpub.com/application-development/learning-concurrency-kotlin">Learn Concurrency in Kotlin</a> book <sup id="anchor_01"><a href="#footnote_01">1</a></sup>.<br/>
  It also includes several build scripts for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

Code examples can be built/run with the following tools:

| Build tool | Build&nbsp;file | Parent&nbsp;file | Environment(s) |
|------------|-----------------|------------------|----------------|
| [**`gradle.bat`**][gradle_cli] | [`build.gradle`](ch01/build.gradle) |  | Any <sup><b>a)</b></sup> |
| [**`mvn.cmd`**][maven_cli]     | [`pom.xml`](ch01/pom.xml)           | [`pom.xml`](./pom.xml) | Any |
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](ch01/build.bat)   | |  | Windows only |
<div style="margin:0 20% 0 8px;font-size:80%;">
<sup>a)</sup></b> Here "Any" means "tested on Windows / Cygwin / MSYS2 / Unix".<br/>&nbsp;
</div>

## <span id="coroutine_example">Coroutine Example</span>

The code source consists of file [`Main.kt`](./ch01/src/main/kotlin/Main.kt).
This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="">tree</a> /f /a . | <a href="">findstr</a> /v /b [A-Z]</b>
|   <a href="./ch01/build.bat">build.bat</a>
|   <a href="./ch01/build.gradle">build.gradle</a>
|   <a href="./ch01/gradle.properties">gradle.properties</a>
|   <a href="./ch01/pom.xml">pom.xml</a>
\---src
    \---main
        \---kotlin
                <a href="./ch01/src/main/kotlin/Main.kt">Main.kt</a>
</pre>

Command [`gradle`]`clean run` generates and executes the Kotlin program `target\.

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

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
