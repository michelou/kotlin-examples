# <span id="top">Playing with Kotlin on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/" rel="external"><img src="./docs/kotlin.png" width="100" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html" rel="external">Gradle scripts</a>, <a href="https://maven.apache.org/guides/introduction/introduction-to-the-pom.html">Maven scripts</a>) for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.</td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are continuously monitoring.

> **&#9755;** Read the document ["Kotlin Language Specification"](https://kotlinlang.org/spec/introduction.html) to know more about of the design decisions behind the <a href="https://kotlinlang.org/" rel="external">Kotlin</a> programming language.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.46][git_downloads] ([*release notes*][git_relnotes])
- [Kotlin 2.0][kotlin_latest] ([*release notes*][kotlin_relnotes])
- [Kotlin/Native 2.0][kotlin_latest] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*release notes*][kotlin_native_relnotes])

Optionally one may also install the following software:

- [Apache Ant 1.10][apache_ant] (requires Java 8) ([*release notes*][apache_ant_relnotes])
- [Apache Maven 3.9][maven_latest] ([requires Java 8+][apache_maven_history]) ([*release notes*][maven_relnotes])
- [ConEmu 2023][conemu_downloads] ([*release notes*][conemu_relnotes])
- [detekt 1.23][detekt_latest] ([*release notes*][detekt_relnotes])
- [Gradle 8.10][gradle_latest] ([*release notes*][gradle_relnotes])
- [KtLint 1.3][ktlint_latest] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*release notes*][ktlint_relnotes])
- [Temurin OpenJDK 11 LTS][temurin_opendjk11] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][temurin_opendjk11_relnotes], [*bug fixes*][temurin_opendjk11_bugfixes])
- [Temurin OpenJDK 17 LTS][temurin_opendjk17] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][temurin_opendjk17_relnotes], [*bug fixes*][temurin_opendjk17_bugfixes])
- [Visual Studio Code 1.93][vscode_downloads] ([*release notes*][vscode_relnotes])

For instance our development environment looks as follows (*October 2024*) <sup id="anchor_03">[3](#footnote_03)</sup>:

<pre style="font-size:80%;">
C:\opt\apache-ant\               <i>( 44 MB)</i>
C:\opt\apache-maven\             <i>(  9 MB)</i>
C:\opt\ConEmu\                   <i>( 26 MB)</i>
C:\opt\detekt-cli\               <i>( 67 MB)</i>
C:\opt\Git\                      <i>(389 MB)</i>
C:\opt\gradle\                   <i>(144 MB)</i>
C:\opt\jdk-temurin-17.0.12_7\    <i>(301 MB)</i>
C:\opt\kotlinc\                  <i>( 90 MB)</i>
C:\opt\kotlin-native\            <i>(242 MB)</i>
C:\opt\ktlint\                   <i>( 77 MB)</i>
C:\opt\make-3.81\                <i>(  2 MB)</i>
C:\opt\VSCode\                   <i>(370 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

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
<a href="LANGUAGE.md">LANGUAGE.md</a>
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
- file [**`LANGUAGE.md`**](LANGUAGE.md) resumes [Kotlin] language changes.
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive &ndash; e.g. drive **`I:`** &ndash; in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> I: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\kotlin-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## Batch commands [**&#x25B4;**](#top)

### [**`setenv.bat`**](setenv.bat)

We execute command [**`setenv.bat`**](setenv.bat) once to setup our development environment; it makes external tools such as [**`git.exe`**][git_exe], [**`gradle.bat`**][gradle_bat] and [**`sh.exe`**][sh_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   ant 1.10.15, gradle 8.10.2, java 17.0.10, detekt-cli 1.23.7,
   kotlinc 2.0.21-RC, kotlinc-native 2.0.21-RC, ktlint 1.3.1, cfr 0.152,
   make 3.81, mvn 3.9.9, git 2.46.2, diff 3.10, bash 4.4.26(1)
Tool paths:
   C:\opt\apache-ant\bin\ant.bat
   C:\opt\gradle\bin\gradle.bat
   C:\opt\jdk-temurin-17.0.12_7\bin\java.exe
   C:\opt\detekt-cli\bin\detekt-cli.bat
   C:\opt\kotlinc\bin\kotlinc.bat
   C:\opt\kotlin-native\bin\kotlinc-native.bat
   C:\opt\ktlint\ktlint.bat
   C:\opt\cfr-0.152\bin\cfr.bat
   C:\opt\make-3.81\bin\make.exe
   C:\opt\apache-maven\bin\mvn.cmd
   C:\opt\Git\bin\git.exe
   C:\opt\Git\mingw64\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
Environment variables:
   "ANT_HOME=C:\opt\apache-ant"
   "CFR_HOME=C:\opt\cfr-0.152"
   "DETEKT_HOME=C:\opt\detekt-cli"
   "GIT_HOME=C:\opt\Git"
   "GRADLE_HOME=C:\opt\gradle"
   "JAVA_HOME=C:\opt\jdk-temurin-17.0.12_7"
   "KOTLIN_HOME=C:\opt\kotlinc"
   "KOTLIN_NATIVE_HOME=C:\opt\kotlin-native"
   "KTLINT_HOME=C:\opt\ktlint"
   "MAKE_HOME=C:\opt\make-3.81"
   "MAVEN_HOME=C:\opt\apache-maven"
</pre>

### [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat)

This batch command generates the [Kotlin] binary distribution on a Windows machine.

<!-- ##################################################################### -->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Kotlin/Native*** [↩](#anchor_01)

<dl><dd>
<a href="https://kotlinlang.org/docs/native-overview.html" rel="external">Kotlin/Native</a> is an LLVM backend for the Kotlin compiler, runtime implementation, and native code generation facility using the LLVM toolchain.
</dd>
<dd>
<table>
<tr><th>Kotlin/Native</th><th>LLVM</th></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew20.html" rel="external">2.0.0</a> - <a href="https://kotlinlang.org/docs/whatsnew2020.html">2.0.21-RC</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v2.0.0/kotlin-native/konan/konan.properties">11.1.0</a> (<a href="https://youtrack.jetbrains.com/issue/KT-49279/Kotlin-Native-update-LLVM-from-11.1.0-to-16.0.0-or-newer">16.0.0 WIP</a>)</td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew1910.html" rel="external">1.9.10</a> - <a href="https://github.com/JetBrains/kotlin/releases/tag/v1.9.23" rel="external">1.9.23</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.20/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew19.html" rel="external">1.9.0</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.10/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew1820.html" rel="external">1.8.20</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.10/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew18.html" rel="external">1.8.0</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.10/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew1720.html" rel="external">1.7.20</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.10/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
<tr><td><a href="https://kotlinlang.org/docs/whatsnew16.html#llvm-and-linker-updates">1.6.0</a></td><td><a href="https://github.com/JetBrains/kotlin/blob/v1.9.10/kotlin-native/konan/konan.properties#L76">11.1.0</a></td></tr>
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
<li>we create an installation directory <b><code>c:\opt\ktlint\bin</code></b>.</li>
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
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/mkdir" rel="external">mkdir</a> c:\opt\ktlint\bin</b>
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a> c:\opt\ktlint\bin</b>
&nbsp;
<b>&gt; <a href="https://ec.haxx.se/cmdline/cmdline-options">curl</a> -sL -o ktlint.sh <a href="https://github.com/pinterest/ktlint/releases/tag/1.3.1">https://github.com/pinterest/ktlint/releases/download/1.3.1/ktlint</a></b>
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
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir" rel="external">dir</a> /b c:\opt\ktlint\bin</b>
ktlint.bat
&nbsp;
<b>&gt; c:\opt\ktlint\bin\<a href="https://ktlint.github.io/#command-line" rel="external">ktlint.bat</a> --version</b>
1.3.1
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***Downloads*** [↩](#anchor_03)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://ant.apache.org/bindownload.cgi">apache-ant-1.10.15-bin.zip</a>                        <i>(  9 MB)</i>
<a href="https://maven.apache.org/download.cgi">apache-maven-3.9.9-bin.zip</a>                        <i>(  9 MB)</i>
<a href="https://github.com/Maximus5/ConEmu/releases/tag/v23.07.24" rel="external">ConEmuPack.230724.7z</a>                              <i>(  5 MB)</i>
<a href="https://github.com/detekt/detekt/releases">detekt-cli-1.23.7.zip</a>                             <i>( 54 MB)</i>
<a href="https://gradle.org/releases/">gradle-8.10.2-bin.zip</a>                             <i>(115 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v2.0.21-RC">kotlin-compiler-2.0.21-RC.zip</a>                     <i>( 80 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v2.0.21-RC">kotlin-native-windows-x86_64-2.0.21-RC.zip</a>        <i>(169 MB)</i>
<a href="https://github.com/pinterest/ktlint/releases/">ktlint (1.3.1)</a>                                    <i>( 63 MB)</i>
<a href="https://sourceforge.net/projects/gnuwin32/files/make/3.81/">make-3.81-bin.zip</a>                                 <i>( 10 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_17.0.12_7.zip</a>  <i>( 99 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.46.2-64-bit.7z.exe</a>                  <i>( 43 MB)</i>
<a href="https://code.visualstudio.com/Download#" rel="external">VSCode-win32-x64-1.92.1.zip</a>                       <i>(131 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[apache_ant]: https://ant.apache.org/
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_relnotes]: https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.15.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[detekt_latest]: https://github.com/detekt/detekt/releases
[detekt_relnotes]: https://github.com/detekt/detekt/releases/tag/v1.23.7
[flix_examples]: https://github.com/michelou/flix-examples#top
[git_downloads]: https://git-scm.com/download/win
[git_exe]: https://git-scm.com/docs/git
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.46.2.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_latest]: https://gradle.org/releases/
[gradle_relnotes]: https://docs.gradle.org/8.10.2/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[jetbrains_kotlin]: https://github.com/JetBrains/kotlin
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin]: https://kotlinlang.org/
[kotlin_latest]: https://kotlinlang.org/docs/releases.html#release-details
[kotlin_native_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v2.0.21-RC
[kotlin_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v2.0.21-RC
[kotlinc_bat]: https://kotlinlang.org/docs/tutorials/command-line.html
[ktlint]: https://github.com/pinterest/ktlint
[ktlint_latest]: https://github.com/pinterest/ktlint/releases
[ktlint_relnotes]: https://github.com/pinterest/ktlint/releases/tag/1.3.1
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[maven_latest]: https://maven.apache.org/download.cgi
[maven_relnotes]: https://maven.apache.org/docs/3.9.9/release-notes.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[rust_examples]: https://github.com/michelou/rust-examples#top
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
<!--
11.0.3  -> http://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-April/000951.html
11.0.11 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-April/005860.html
11.0.12 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-July/006954.html
11.0.13 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-October/009368.html
11.0.14 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-January/011643.html
11.0.16 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-July/016017.html
11.0.17 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-October/018119.html
11.0.18 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-January/020111.html
11.0.19 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-April/021900.html
11.0.20 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-July/024064.html
11.0.21 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026351.html
11.0.22 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029215.html
-->
[temurin_opendjk11_bugfixes]: https://www.oracle.com/java/technologies/javase/11-0-17-bugfixes.html
[temurin_opendjk11_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-October/018119.html
[temurin_opendjk11]: https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot
<!--
17.0.7  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-April/021899.html
17.0.8  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-July/024063.html
17.0.9  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026352.html
17.0.10 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029089.html
17.0.11 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-April/032197.html
-->
[temurin_opendjk17]: https://adoptium.net/releases.html?variant=openjdk17&jvmVariant=hotspot
[temurin_opendjk17_bugfixes]: https://www.oracle.com/java/technologies/javase/17-0-2-bugfixes.html
[temurin_opendjk17_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026352.html
<!--
21_35   -> https://adoptium.net/fr/temurin/release-notes/?version=jdk-21+35
21.0.1  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026351.html
21.0.2  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-January/029090.html
21.0.3  -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2024-April/032196.html
-->
[temurin_openjdk21]: https://adoptium.net/releases.html?variant=openjdk21&jvmVariant=hotspot
[temurin_openjdk21_bugfixes]: https://www.oracle.com/java/technologies/javase/17-0-2-bugfixes.html
[temurin_openjdk21_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2023-October/026351.html
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
