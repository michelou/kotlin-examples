# <span id="top">Kotlin on Microsoft Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="100" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>/<a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html" rel="external">Gradle scripts</a> for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

[GraalVM][graalvm_examples], [Haskell][haskell_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Scala 3][scala3_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.32][git_downloads] ([*release notes*][git_relnotes])
- [Kotlin 1.5][kotlin_latest] ([*release notes*][kotlin_relnotes])
- [Kotlin Native 1.5][kotlin_latest] <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> ([*release notes*][kotlin_native_relnotes])

Optionally one may also install the following software:

- [Apache Maven 3.8][maven_latest] ([*release notes*][maven_relnotes])
- [detekt 1.17][detekt_latest] ([*release notes*][detekt_relnotes])
- [Gradle 7.1][gradle_latest] ([*release notes*][gradle_relnotes])
- [KtLint 0.41][ktlint_latest] <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup> ([*release notes*][ktlint_relnotes])

For instance our development environment looks as follows (*July 2021*) <sup id="anchor_03"><a href="#footnote_03">[3]</a></sup>:

<pre style="font-size:80%;">
C:\opt\apache-maven-3.8.1\            <i>( 10 MB)</i>
C:\opt\detekt-cli-1.17.1\             <i>( 49 MB)</i>
C:\opt\Git-2.32.0\                    <i>(279 MB)</i>
C:\opt\gradle-7.1.1\                  <i>(121 MB)</i>
C:\opt\kotlinc-1.5.20\                <i>( 64 MB)</i>
C:\opt\kotlin-native-windows-1.5.20\  <i>(170 MB)</i>
C:\opt\ktlint-0.41.0\                 <i>( 42 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
<a href="bin/kotlin/build.bat">bin\kotlin\build.bat</a>
concurrency-in-kotlin\
docs\
examples\{<a href="examples/HelloWorld/">HelloWorld</a>, <a href="examples/JavaToKotlin/">JavaToKoltin</a>, ..}
how-to-kotlin\{<a href="how-to-kotlin/01_bean/">01_bean</a>, <a href="how-to-kotlin/02_properties/">02_properties</a>, ..}
<a href="https://github.com/JetBrains/kotlin">kotlin\</a>             <i>(<a href=".gitmodules">Github submodule</a>)</i>
kotlin-cookbook\{<a href="kotlin-cookbook/Example_03-10/">Example_03-10</a>, <a href="kotlin-cookbook/Example_03-13/">Example_03-13</a>, ..}
learn-kotlin\{<a href="learn-kotlin/Unit_02/">Unit_02</a>, <a href="learn-kotlin/Unit_04/">Unit_04</a>, ..}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) contains several batch files.
- file [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat) is the batch script for generating the [Kotlin] software distribution on a Windows machine.
- directory [**`concurrency-in-kotlin\`**](concurrency-in-kotlin/) contains [Kotlin] code examples (see [**`concurrency-in-kotlin\README.md`**](concurrency-in-kotlin/README.md))
- directory [**`docs\`**](docs/) contains [Kotlin] related papers/articles.
- directory [**`examples\`**](examples/) contains [Kotlin] code examples (see document [**`examples\README.md`**](examples/README.md)).
- directory [**`how-to-kotlin\`**](how-to-kotlin/) contains [Kotlin] code examples (see [**`how-to-kotlin\README.md`**](how-to-kotlin/README.md)).
- directory **`kotlin\`** contains a copy of the [JetBrains/kotlin][jetbrains_kotlin] repository as a [Github submodule](.gitmodules).
- directory [**`kotlin-cookbook\`**](kotlin-cookbook/) contains [Kotlin] code examples (see [**`kotlin-cookbook\README.md`**](kotlin-cookbook/README.md)).
- directory [**`learn-kotlin\`**](learn-kotlin/) contains [Kotlin] code examples (see [**`learn-kotlin\README.md`**](learn-kotlin/README.md)).
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`K:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> K: %USERPROFILE%\workspace\kotlin-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`gradle.bat`**][gradle_bat], [**`kotlinc.bat`**][kotlinc_bat] and [**`git.exe`**][git_exe] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
   Tool versions:
      bazel 4.1.0, gradle 7.1.1, java 1.8.0_292, detekt-cli 1.17.1,
      kotlinc 1.5.20, kotlinc-native 1.5.20, ktlint 0.41.0
      cfr 0.151, mvn 3.8.1, git 2.32.0.windows.1, diff 3.7, bash 4.4.23(1)-release
   Tool paths:
      C:\opt\apache-ant-1.10.10\bin\ant.bat
      C:\opt\bazel-4.1.0\bazel.exe
      C:\opt\gradle-7.1.1\bin\gradle.bat
      C:\opt\jdk-openjdk-1.8.0u292-b10\bin\java.exe
      C:\opt\detekt-cli-1.17.1\bin\detekt-cli.bat
      C:\opt\kotlinc-1.5.20\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-1.5.20\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-1.5.20\bin\kotlinc-native.bat
      C:\opt\ktlint-0.41.0\ktlint.bat
      C:\opt\cfr-0.151\bin\cfr.bat
      C:\opt\apache-maven-3.8.1\bin\mvn.cmd
      C:\opt\Git-2.32.0\bin\git.exe
      C:\opt\Git-2.32.0\mingw64\bin\git.exe
      C:\opt\Git-2.32.0\usr\bin\diff.exe
   Environment variables:
      "ANT_HOME=C:\opt\apache-ant-1.10.10"
      "CFR_HOME=C:\opt\cfr-0.151"
      "DETEKT_HOME=C:\opt\detekt-cli-1.17.1"
      "DOKKA_HOME=C:\opt\dokka-1.4.32"
      "GIT_HOME=C:\opt\Git-2.32.0"
      "GRADLE_HOME=C:\opt\gradle-7.1.1"
      "JAVA_HOME=c:\opt\jdk-openjdk-1.8.0u292-b10"
      "KOTLIN_HOME=C:\opt\kotlinc-1.5.20"
      "KOTLIN_NATIVE_HOME=C:\opt\kotlinc-1.5.20"
      "KTLINT_HOME=C:\opt\ktlint-0.41.0"
   </pre>

2. [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat) - This batch command generates the [Kotlin] binary distribution on a Windows machine.

<!-- ##################################################################### -->

## <span id="footnotes">Footnotes</span>

<span name="footnote_01">[1]</span> ***Kotlin Native*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Kotlin/Native is an LLVM backend (based on <a href="https://releases.llvm.org/8.0.0/docs/ReleaseNotes.html">LLVM 8.0</a> since version <a hef="https://github.com/JetBrains/kotlin-native/blob/master/CHANGELOG.md#v1360-oct-2019">1.3.60</a>) for the Kotlin compiler, runtime implementation, and native code generation facility using the LLVM toolchain.
</p>

<span name="footnote_02">[2]</span> ***KtLint on Windows*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
No Windows distribution is available from the <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> repository.
</p>
<p style="margin:0 0 1em 20px;">Fortunately the <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> tool is packed into a shell script (i.e. embedded JAR file in binary form), so we simply extracted the JAR file to create a "universal" <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> distribution (in the same way as the <a href="http://www.lihaoyi.com/mill/index.html#windows">Mill assembly</a> distribution):
</p>
<ul style="margin:0 0 1em 20px;">
<li>we create an installation directory <b><code>c:\opt\ktlint-0.41.0\</code></b>.</li>
<li>we download the shell script from the <a href="https://github.com/pinterest/ktlint" rel="external">Github repository</a>.</i>
<li>we extract the JAR file from the bash script (and check it with command <b><code>jar tf</code></b>).</li>
<li>we create batch file <b><code>ktlint.bat</code></b> from the binary concatenation of header file <a href="bin/ktlint_header.bin"><b><code>ktlint_header.bin</code></b></a> and the extracted JAR file.</li>
</ul>
<p style="margin:0 0 1em 20px;">
Here are the performed operations:
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mkdir">mkdir</a> c:\opt\ktlint-0.41.0</b>
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a> c:\opt\ktlint-0.41.0</b>
&nbsp;
<b>&gt; <a href="https://ec.haxx.se/cmdline/cmdline-options">curl</a> -sL -o ktlint.sh https://github.com/pinterest/ktlint/releases/download/0.41.0/ktlint</b>
<b>&gt; <a href="https://man7.org/linux/man-pages/man1/tail.1.html">tail</a> -n+5 ktlint.sh > ktlint.jar</b>
<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jar.html">jar</a> tf ktlint.jar | findstr ktlint/Main</b>
com/pinterest/ktlint/Main.class
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy">copy</a> /y /b k:\bin\ktlint_header.bin + /b ktlint.jar ktlint.bat</b>
</pre>
<p style="margin:0 0 1em 20px;">
The installation directory now contains one single file, namely <b><code>ktlint.bat</code></b>:
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b c:\opt\ktlint-0.41.0</b>
ktlint.bat
&nbsp;
<b>&gt; c:\opt\ktlint-0.41.0\<a href="https://ktlint.github.io/#command-line">ktlint.bat</a> --version</b>
0.41.0
</pre>

<span name="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://maven.apache.org/download.cgi">apache-maven-3.8.1-bin.zip</a>                 <i>(  9 Mb)</i>
<a href="https://github.com/detekt/detekt/releases">detekt-cli-1.17.1.zip</a>                      <i>( 44 MB)</i>
<a href="https://gradle.org/releases/">gradle-7.1.1-bin.zip</a>                       <i>(107 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.5.20">kotlin-compiler-1.5.20.zip</a>                 <i>( 60 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.5.20">kotlin-native-prebuilt-windows-1.5.20.zip</a>  <i>(125 MB)</i>
<a href="https://github.com/pinterest/ktlint/releases/">ktlint (0.41.0)</a>                            <i>( 47 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.32.0-64-bit.7z.exe</a>           <i>( 41 MB)</i>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[detekt_latest]: https://github.com/detekt/detekt/releases
[detekt_relnotes]: https://github.com/detekt/detekt/releases/tag/v1.17.1
[scala3_examples]: https://github.com/michelou/dotty-examples
[git_downloads]: https://git-scm.com/download/win
[git_exe]: https://git-scm.com/docs/git
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.32.0.txt
[github_markdown]: https://github.github.com/gfm/
[graalsqueak_examples]: https://github.com/michelou/graalsqueak-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_latest]: https://gradle.org/releases/
[gradle_relnotes]: https://docs.gradle.org/7.0/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples
[jetbrains_kotlin]: https://github.com/JetBrains/kotlin
[kotlin]: https://kotlinlang.org/
[kotlin_latest]: https://kotlinlang.org/docs/releases.html#release-details
[kotlin_native_relnotes]: https://github.com/JetBrains/kotlin-native/blob/master/CHANGELOG.md
[kotlin_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v1.5.20
[kotlinc_bat]: https://kotlinlang.org/docs/tutorials/command-line.html
[ktlint]: https://github.com/pinterest/ktlint
[ktlint_latest]: https://github.com/pinterest/ktlint/releases
[ktlint_relnotes]: https://github.com/pinterest/ktlint/releases/tag/0.41.0
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples
[maven_latest]: https://maven.apache.org/download.cgi
[maven_relnotes]: https://maven.apache.org/docs/3.8.1/release-notes.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
