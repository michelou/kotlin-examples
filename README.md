# <span id="top">Kotlin on Microsoft Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Kotlin-logo.svg/120px-Kotlin-logo.svg.png" width="100" alt="Kotlin"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.24][git_downloads] ([*release notes*][git_relnotes])
- [Kotlin 1.3][kotlin_latest] ([*release notes*][kotlin_relnotes])
- [Kotlin Native 1.3][kotlin_latest] <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> ([*release notes*][kotlin_native_relnotes])

Optionally one may also install the following software:

- [Gradle 5.6][gradle_latest] ([*release notes*][gradle_relnotes])
- [KtLint 0.3][ktlint_latest] <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup> ([*release notes*][ktlint_relnotes])

For instance our development environment looks as follows (*November 2019*) <sup id="anchor_03"><a href="#footnote_03">[3]</a></sup>:

<pre style="font-size:80%;">
C:\opt\Git-2.24.0\                     <i>(271 MB)</i>
C:\opt\gradle-6.0.1                    <i>(103 MB)</i>
C:\opt\kotlinc-1.3.60\                 <i>( 56 MB)</i>
C:\opt\kotlin-native-windows-1.3.60\   <i>(378 MB)</i>
C:\opt\ktlint-0.35.0\                  <i>( 42 MB)</i>
</pre>
<!--
C:\opt\<a href="https://github.com/pinterest/ktlint/releases/">ktlint-0.35\</a>
-->

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
bin\kotlin\build.bat
docs\
examples\README.md
<a href="https://github.com/JetBrains/kotlin">kotlin\</a>             <i>(Github submodule)</i>
BUILD.md
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) contains several batch files.
- file [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat) is the batch script for generating the [Kotlin] software distribution on a Windows machine.
- directory [**`docs\`**](docs/) contains [Kotlin] related papers/articles.
- directory [**`examples\`**](examples/) contains [Kotlin] code examples (see [**`examples\README.md`**](examples/README.md)).
- directory **`kotlin\`** contains a copy of the [JetBrains/kotlin][jetbrains_kotlin] repository as a [Github submodule](.gitmodules).
- file [**`BUILD.md`**](BUILD.md) is the Markdown document presenting the generation of the [Kotlin] software.
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive **`O:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst O: %USERPROFILE%\workspace\kotlin-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`gradle.bat`**][gradle_bat], [**`kotlinc.bat`**][kotlinc_bat] and [**`git.exe`**][git_exe] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; setenv -verbose</b>
   Tool versions:
      gradle 6.0.1, java 1.8.0_232,
      kotlinc 1.3.60, kotlinc-native 1.3.60, ktlint 0.35.0
      git 2.24.0.windows.1, diff 3.7
   Tool paths:
      C:\opt\gradle-6.0.1\bin\gradle.bat
      C:\opt\jdk-1.8.0_232-b09\bin\java.exe
      C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
      C:\opt\kotlinc-1.3.60\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-1.3.60\bin\kotlinc.bat
      C:\opt\kotlin-native-windows-1.3.60\bin\kotlinc-native.bat
      C:\opt\ktlint-0.35.0\ktlint.bat
      C:\opt\Git-2.24.0\bin\git.exe
      C:\opt\Git-2.24.0\mingw64\bin\git.exe
      C:\opt\Git-2.24.0\usr\bin\diff.exe
   </pre>

2. [**`bin\kotlinc.bat`**](bin/kotlinc.bat) - This batch command provides several improvements over the batch command of the same name found in the [Kotlin] binary distribution.

3. [**`bin\ktlint.bat`**](bin/ktlint.bat) - This batch command makes it possible to use the [KtLint] library on a Windows machine.

4. [**`bin\kotlin\build.bat`**](bin/kotlin/build.bat) - This batch command generates the [Kotlin] binary distribution on a Windows machine.

## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Kotlin Native*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Kotlin/Native is an LLVM backend (based on <a href="https://releases.llvm.org/8.0.0/docs/ReleaseNotes.html">LLVM 8.0</a> since version <a hef="https://github.com/JetBrains/kotlin-native/blob/master/CHANGELOG.md#v1360-oct-2019">1.3.60</a>) for the Kotlin compiler, runtime implementation, and native code generation facility using the LLVM toolchain.
</p>

<a name="footnote_02">[2]</a> ***KtLint on Windows*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
No Windows distribution is available from the <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> repository.
</p>
<p style="margin:0 0 1em 20px;">Fortunately the <a href="https://github.com/pinterest/ktlint/releases">KtLint</a> tool is packed into a shell script (i.e. embedded JAR file in binary form), so we can create a Windows installation of <a href="https://github.com/pinterest/ktlint/releases">KtLint</a>. In our case we proceeded as follows:
</p>
<ul style="margin:0 0 1em 20px;">
<li>create an installation directory <b><code>c:\opt\ktlint-0.35.0\</code></b>.</li>
<li>download the shell script from the <a href="https://github.com/pinterest/ktlint">Github repository</a>.</i>
<li>extract the JAR file from the bash script (and check it with command <b><code>jar tf</code></b>).</li>
<li>add the batch file <a href="bin/ktlint.bat"><b><code>ktlint.bat</code></b></a> we  created to our installation directory.</li>
</ul>
<p style="margin:0 0 1em 20px;">
Here are the operations we performed on the command prompt:
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; mkdir c:\opt\ktlint-0.35.0</b>
<b>&gt; cd c:\opt\ktlint-0.35.0</b>
&nbsp;
<b>&gt; curl -sL -o ktlint.sh https://github.com/pinterest/ktlint/releases/download/0.35.0/ktlint</b>
<b>&gt; tail -n+5 ktlint.sh > ktlint.jar</b>
<b>&gt; jar tf ktlint.jar | findstr ktlint/Main</b>
com/pinterest/ktlint/Main.class
<b>&gt; copy &lt;kotlin-examples-dir&gt;\bin\ktlint.bat .</b>
</pre>
<p style="margin:0 0 1em 20px;">
The installation directory should have the following layout:
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; dir /b c:\opt\ktlint-0.35.0</b>
ktlint
ktlint.bat
ktlint.jar
</pre>

<a name="footnote_03">[3]</a> ***Downloads*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://gradle.org/releases/">gradle-6.0.1-bin.zip</a>                 <i>( 90 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.3.60">kotlin-compiler-1.3.60.zip</a>           <i>( 50 MB)</i>
<a href="https://github.com/JetBrains/kotlin/releases/tag/v1.3.60">kotlin-native-windows-1.3.60.zip</a>     <i>(125 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.24.0-64-bit.7z.exe</a>     <i>( 41 MB)</i>
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[git_downloads]: https://git-scm.com/download/win
[git_exe]: https://git-scm.com/docs/git
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.24.0.txt
[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_latest]: https://gradle.org/releases/
[gradle_relnotes]: https://docs.gradle.org/6.0.1/release-notes.html
[jetbrains_kotlin]: https://github.com/JetBrains/kotlin
[kotlin]: https://kotlinlang.org/
[kotlin_latest]: https://github.com/JetBrains/kotlin/releases/tag/v1.3.60
[kotlin_native_relnotes]: https://github.com/JetBrains/kotlin-native/blob/master/CHANGELOG.md#v1360-oct-2019
[kotlin_relnotes]: https://github.com/JetBrains/kotlin/releases/tag/v1.3.60
[kotlinc_bat]: https://kotlinlang.org/docs/tutorials/command-line.html
[klint]: https://github.com/pinterest/ktlint
[ktlint_latest]: https://github.com/pinterest/ktlint/releases
[ktlint_relnotes]: https://github.com/pinterest/ktlint/releases/tag/0.35.0
[linux_opt]: http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
