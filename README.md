# <span id="top">Playing with Kotlin on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/" rel="external"><img src="./docs/kotlin.png" width="100" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html" rel="external">Gradle scripts</a> or <a href="https://maven.apache.org/guides/introduction/introduction-to-the-pom.html">Maven scripts</a>) for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [Dart][dart_examples], [Deno][deno_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX Toolset][wix_examples] are other trending topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.40][git_downloads] ([*release notes*][git_relnotes])
- [Kotlin 1.8][kotlin_latest] ([*release notes*][kotlin_relnotes])
- [Kotlin/Native 1.8][kotlin_latest] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*release notes*][kotlin_native_relnotes])

Optionally one may also install the following software:

- [Apache Ant 1.10][apache_ant] (requires Java 8) ([*release notes*][apache_ant_relnotes])
- [Apache Maven 3.9][maven_latest] ([*release notes*][maven_relnotes])
- [detekt 1.23][detekt_latest] ([*release notes*][detekt_relnotes])
- [Gradle 8.1][gradle_latest] ([*release notes*][gradle_relnotes])
- [KtLint 0.49][ktlint_latest] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*release notes*][ktlint_relnotes])

For instance our development environment looks as follows (*June 2023*) <sup id="anchor_03">[3](#footnote_03)</sup>:

<pre style="font-size:80%;">
C:\opt\apache-ant-1.10.13\                   <i>( 39 MB)</i>
C:\opt\apache-maven-3.9.2\                   <i>(  9 MB)</i>
C:\opt\detekt-cli-1.23.0\                    <i>( 55 MB)</i>
C:\opt\Git-2.40.1\                           <i>(314 MB)</i>
C:\opt\gradle-8.1.1\                         <i>(129 MB)</i>
C:\opt\jdk-temurin-11.0.19_7\                <i>(256 MB)</i>
C:\opt\kotlinc-1.8.21\                       <i>( 80 MB)</i>
C:\opt\kotlin-native-windows-x86_64-1.8.21\  <i>(256 MB)</i>
C:\opt\ktlint-0.49.1\                        <i>( 53 MB)</i>
C:\opt\make-3.81\                            <i>(  2 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
<a href="bin/kotlin/build.bat">bin\kotlin\build.bat</a>
concurrency-in-kotlin\{<a href="concurrency-in-kotlin/README.md">README.md</a>}
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/HelloWorld/">HelloWorld</a>, <a href="examples/JavaToKotlin/">JavaToKoltin</a>, ..}
how-to-kotlin\{<a href="how-to-kotlin/README.md">README.md</a>, <a href="how-to-kotlin/01_bean/">01_bean</a>, <a href="how-to-kotlin/02_properties/">02_properties</a>, ..}
<a href="https://github.com/JetBrains/kotlin">kotlin\</a>   <i>(<a href=".gitmodules">Github submodule</a>)</i>
kotlin-cookbook\{<a href="kotlin-cookbook/README.md">README.md</a>, <a href="kotlin-cookbook/Example_03-10/">Example_03-10</a>, <a href="kotlin-cookbook/Example_03-13/">Example_03-13</a>, ..}
learn-kotlin\{<a href="learn-kotlin/README.md">README.md</a>, <a href="learn-kotlin/Unit_02/">Unit_02</a>, <a href="learn-kotlin/Unit_04/">Unit_04</a>, ..}
<a href="CONTRIBUTIONS.md">CONTRIBUTIONS.md</a>
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
- file [**`CONTRIBUTIONS.md`**](CONTRIBUTIONS.md) gathers reported issues and pull requests to the [Kotlin] project.
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`I:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> I: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\kotlin-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## Batch commands [**&#x25B4;**](#top)

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`gradle.bat`**][gradle_bat], [**`kotlinc.bat`**][kotlinc_bat] and [**`git.exe`**][git_exe] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
   Tool versions:
      ant 1.10.13, bazel 6.1.2, gradle 8.1.1, java 11.0.19, detekt-cli 1.22.0,
      kotlinc 1.8.21, kotlinc-native 1.8.21, ktlint 0.49.1, cfr 0.152,
      make 3.81, mvn 3.9.2, git 2.40.1.windows.1, diff 3.9, bash 4.4.23(1)-release
   Tool paths:
      C:\opt\apache-ant-1.10.13\bin\ant.bat
      C:\opt\bazel-6.1.0\bazel.exe
      C:\opt\gradle-8.1.1\bin\gradle.bat
      C:\opt\jdk-temurin-11.0.17_8\bin\java.exe
      C:\opt\detekt-cli-1.22.0\bin\detekt-cli.bat
      C:\opt\kotlinc-1.8.21\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-x86_64-1.8.21\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-x86_64-1.8.21\bin\kotlinc-native.bat
      C:\opt\ktlint-0.49.1\ktlint.bat
      C:\opt\cfr-0.152\bin\cfr.bat
      C:\opt\make-3.81\bin\make.exe
      C:\opt\apache-maven-3.9.2\bin\mvn.cmd
      C:\opt\Git-2.40.1\bin\git.exe
      C:\opt\Git-2.40.1\mingw64\bin\git.exe
      C:\opt\Git-2.40.1\usr\bin\diff.exe
   Environment variables:
      "ANT_HOME=C:\opt\apache-ant-1.10.13"
      "CFR_HOME=C:\opt\cfr-0.152"
      "DETEKT_HOME=C:\opt\detekt-cli-1.22.0"
      "DOKKA_HOME=C:\opt\dokka-1.4.32"
      "GIT_HOME=C:\opt\Git-2.40.1"
      "GRADLE_HOME=C:\opt\gradle-8.1.1"
      "JAVA_HOME=C:\opt\jdk-temurin-11.0.19_7"
      "KOTLIN_HOME=C:\opt\kotlinc-1.8.21"
      "KOTLIN_NATIVE_HOME=C:\opt\kotlinc-1.8.21"
      "KTLINT_HOME=C:\opt\ktlint-0.49.1"
      "MAKE_HOME=C:\opt\make-3.81"
      "MAVEN_HOME=C:\opt\apache-maven-3.9.2"
   </pre>

2. [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat) - This batch command generates the [Kotlin] binary distribution on a Windows machine.

<!-- ##################################################################### -->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Kotlin/Native*** [↩](#anchor_01)

<dl><dd>
Kotlin/Native is an LLVM backend for the Kotlin compiler, runtime implementation, and native code generation facility using the LLVM toolchain.
</dd>
<dd>
<table>
<tr><th>Kotlin/Native</th><th>LLVM</th></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew1820.html" rel="external">1.8.20</a></td><td>?</td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew18.html" rel="external">1.8.0</a></td><td>?</td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew1720.html" rel="external">1.7.20</a></td><td>?</td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew16.html#llvm-and-linker-updates">1.6.0</a></td><td>11.1.0</td></tr>
<tr><td><a hef="https://github.com/JetBrains/kotlin-native/blob/master/CHANGELOG.md#v1360-oct-2019" rel="external">1.3.60</a></td><td>8.0</td></tr>
</table>
</dd></dl>

<span id="footnote_02">[2]</span> ***KtLint on Windows*** [↩](#anchor_02)

<dl><dd>
No Windows distribution is available from the <a href="https://github.com/pinterest/ktlint/releases" rel="external">KtLint</a> repository.
</dd>
<dd>
Fortunately the <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> tool is packed into a shell script (i.e. embedded JAR file in binary form), so we simply extracted the JAR file to create a "universal" <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> distribution (in the same way as the <a href="https://com-lihaoyi.github.io/mill/mill/Installation.html#_windows" rel="external">Mill assembly</a> distribution):
<ul>
<li>we create an installation directory <b><code>c:\opt\ktlint-0.49.1\</code></b>.</li>
<li>we download the shell script from the Github repository <a href="https://github.com/pinterest/ktlint" rel="external"><code>pinterest/ktlint</code></a>.</i>
<li>we extract the JAR file from the bash script (and check it with command <b><code><a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jar.html" rel="external">jar</a> tf</code></b>).</li>
<li>we create batch file <b><code>ktlint.bat</code></b> from the binary concatenation of header file <a href="bin/ktlint_header.bin"><b><code>ktlint_header.bin</code></b></a> and the extracted JAR file.</li>
</ul>
</dd>
<dd>
Here are the performed operations:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mkdir" rel="external">mkdir</a> c:\opt\ktlint-0.49.1</b>
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a> c:\opt\ktlint-0.49.1</b>
&nbsp;
<b>&gt; <a href="https://ec.haxx.se/cmdline/cmdline-options">curl</a> -sL -o ktlint.sh https://github.com/pinterest/ktlint/releases/download/0.49.1/ktlint</b>
<b>&gt; <a href="https://man7.org/linux/man-pages/man1/tail.1.html">tail</a> -n+5 ktlint.sh > ktlint.jar</b>
<b>&gt; %JAVA_HOME%\bin\<a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jar.html">jar</a> tf ktlint.jar | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> ktlint/Main</b>
com/pinterest/ktlint/Main.class
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy">copy</a> /y /b i:\bin\ktlint_header.bin + /b ktlint.jar ktlint.bat</b>
</pre>
</dd>
<dd>
The installation directory now contains one single file, namely <b><code>ktlint.bat</code></b>:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir" rel="external">dir</a> /b c:\opt\ktlint-0.49.1</b>
ktlint.bat
&nbsp;
<b>&gt; c:\opt\ktlint-0.49.1\<a href="https://ktlint.github.io/#command-line" rel="external">ktlint.bat</a> --version</b>
0.49.1
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://ant.apache.org/bindownload.cgi">apache-ant-1.10.13-bin.zip</a>                         <i>(  9 MB)</i>
<a href="https://maven.apache.org/download.cgi">apache-maven-3.9.2-bin.zip</a>                         <i>(  9 MB)</i>
<a href="https://github.com/detekt/detekt/releases">detekt-cli-1.23.0.zip</a>                              <i>( 54 MB)</i>
<a href="https://gradle.org/releases/">gradle-8.1.1-bin.zip</a>                               <i>(115 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.8.21">kotlin-compiler-1.8.21.zip</a>                         <i>( 71 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.8.21">kotlin-native-windows-x86_64-1.8.21.zip</a>            <i>(174 MB)</i>
<a href="https://github.com/pinterest/ktlint/releases/">ktlint (0.49.1)</a>                                    <i>( 63 MB)</i>
<a href="https://sourceforge.net/projects/gnuwin32/files/make/3.81/">make-3.81-bin.zip</a>                                  <i>( 10 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot">OpenJDK8U-jdk_x64_windows_hotspot_8u372b07.zip</a>     <i>( 99 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.19_7.zip</a>   <i>( 99 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.40.1-64-bit.7z.exe</a>                   <i>( 43 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples
[akka_examples]: https://github.com/michelou/akka-examples
[apache_ant]: https://ant.apache.org/
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_relnotes]: https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.13.html
[cpp_examples]: https://github.com/michelou/cpp-examples
[dart_examples]: https://github.com/michelou/dart-examples
[deno_examples]: https://github.com/michelou/deno-examples
[detekt_latest]: https://github.com/detekt/detekt/releases
[detekt_relnotes]: https://github.com/detekt/detekt/releases/tag/v1.23.0-RC1
[flix_examples]: https://github.com/michelou/flix-examples
[git_downloads]: https://git-scm.com/download/win
[git_exe]: https://git-scm.com/docs/git
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.40.1.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_latest]: https://gradle.org/releases/
[gradle_relnotes]: https://docs.gradle.org/8.0/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples
[jetbrains_kotlin]: https://github.com/JetBrains/kotlin
[kafka_examples]: https://github.com/michelou/kafka-examples
[kotlin]: https://kotlinlang.org/
[kotlin_latest]: https://kotlinlang.org/docs/releases.html#release-details
[kotlin_native_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v1.8.21
[kotlin_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v1.8.21
[kotlinc_bat]: https://kotlinlang.org/docs/tutorials/command-line.html
[ktlint]: https://github.com/pinterest/ktlint
[ktlint_latest]: https://github.com/pinterest/ktlint/releases
[ktlint_relnotes]: https://github.com/pinterest/ktlint/releases/tag/0.49.1
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples
[maven_latest]: https://maven.apache.org/download.cgi
[maven_relnotes]: https://maven.apache.org/docs/3.9.2/release-notes.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[rust_examples]: https://github.com/michelou/rust-examples
[scala3_examples]: https://github.com/michelou/dotty-examples
[spark_examples]: https://github.com/michelou/spark-examples
[spring_examples]: https://github.com/michelou/spring-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
