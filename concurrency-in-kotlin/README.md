# <span id="top">*Concurrency in Kotlin* Book</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from the <a href="https://www.packtpub.com/application-development/learning-concurrency-kotlin">Learn Concurrency in Kotlin</a> book <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

Code examples can be built/run with the following tools:

| Build Tool |   Command    | Configuration file |
|------------|--------------|--------------------|
| Gradle     | `gradle.bat` | `build.gradle`     |
| Maven      | `mvn.cmd`    | `pom.xml`          |
| Batch      | `build.bat`  | *none*             |

## Coroutine Example

<pre style="font-size:80%;">
<b>&gt; gradle clean run</b>
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

## Concurrent Example

<pre style="font-size:80%;">
<b>&gt; gradle clean run</b>

> Task :run
Hello, Susan Calvin
Execution took 2040 ms

Hello, Susan Calvin
Execution took 1034 ms
</pre>

## Footnotes

<a name="footnote_01">[1]</a> ***Learn Concurrency in Kotlin** Book* [↩](#anchor_01)
    <div style="margin:-12px 0 0 20px;">
    by Miguel Angel Castiblanco Torres,<br/>
    Packt Publishing (ISBN: 9781788627160), July 2018.
    </div>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/May 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
