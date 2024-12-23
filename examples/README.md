# <span id="top">Kotlin code examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/"><img src="../docs/kotlin.png" width="100" alt="Kotlin project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/" rel="external">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>, <a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html">Gradle scripts</a>) for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

In this document we present the following [Kotlin] code examples (unless):

- [HelloWorld](#hello-jvm)
- [JavaToKotlin](#java_kotlin) (JVM only)
- [KotlinToJava](#kotlin_java) (JVM only)
- [LanguageFeatures](#features)
- [QuickSort](#quicksort)
- [Reflection](#reflection) (JVM only)
- [SelectionSort](#selectionsort)

> **:mag_right:** There exist three Kotlin compilers and some code examples are only valid with one of them:
> - The [Kotlin/JVM][kotlin_jvm] compiler generates class/JAR files.
> - The [Kotlin/JS][kotlin_js] compiler generates JavaScript code.
> - The [Kotlin/Native][kotlin_native] compiler generates native codefor the supported targets <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.

<!--
**`kotlin-stdlib`** contains most of the functionality: Collections, Ranges, Math, Regex, File extensions, Locks, etc... Most of what you use daily is in kotlin-stdlib
-->

We provide several ways to build/run the [Kotlin] code examples:

| Build&nbsp;tool     | Build file(s)  | Parent file(s) | Environment(s) |
|---------------------|----------------|----------------|----------------|
| [**`ant.bat`**][apache_ant_cli] | [`build.xml`](HelloWorld/build.xml) | &nbsp; | Any <sup><b>a)</b></sup> |
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](HelloWorld/build.bat)<br/>`build.properties` | [`cpath.bat`](./cpath.bat) <sup><b>b)</b></sup> | Windows |
| [**`sh.exe`**][sh_cli] | [`build.sh`](HelloWorld/build.sh) |  | [Cygwin]/[MSYS2]/Unix |
| [**`gradle.exe`**][gradle_cli]    | [`build.gradle`](HelloWorld/build.gradle) <sup><b>c)</b></sup> | [`common.gradle`](./common.gradle)  | Any |
| [**`gradle.exe`**][gradle_cli]    | [`build.gradle.kts`](HelloWorld/build.gradle.kts) <sup><b>d)</b></sup> | &nbsp; | Any |
| [**`mvn.cmd`**][apache_maven_cli] | [`pom.xml`](HelloWorld/pom.xml) | [`pom.xml`](./pom.xml)  | Any |
| [**`make.exe`**][gmake_cli] | [`Makefile`](HelloWorld/Makefile) | [`Makefile.inc`](./Makefile.inc)  | Any |
<div style="margin:0 30% 0 8px;font-size:90%;">
<sup><b>a)</b></sup></b> Here "Any" means "tested on MS Windows / Cygwin / MSYS2 / Unix".<br/>
<sup><b>b)</b></sup> This utility batch file manages <a href="https://maven.apache.org/">Maven</a> dependencies and returns the associated Java class path (as environment variable).<br/>
<sup><b>c)</b></sup> Gradle build script written in <a href="https://docs.gradle.org/current/dsl/index.html">Groovy DSL</a><br/>
<sup><b>d)</b></sup> Gradle build script written in <a href="https://docs.gradle.org/current/userguide/kotlin_dsl.html">Kotlin DSL</a><br/>&nbsp;
</div>

> **:mag_right:** Command [**`build.bat help`**](HelloWorld/build.bat) displays the help message:
> <pre style="font-size:80%;">
> <b>&gt; <a href="HelloWorld/build.bat">build</a> help</b>
> Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
> &nbsp;
>  Options:
>    -debug      print commands executed by this script
>    -native     generated native executable
>    -timer      print total execution time
>    -verbose    print progress messages
> &nbsp;
>  Subcommands:
>    clean       delete generated files
>    compile     generate class files
>    detekt      analyze Kotlin source files with Detekt
>    doc         generate documentation
>    help        print this help message
>    lint        analyze Kotlin source files with KtLint
>    run         execute the generated program
>    test        execute unit tests
</pre>

## <span id="hello-jvm">`HelloWorld` Example</span> [**&#x25B4;**](#top)

Command [**`build.bat clean run`**](HelloWorld/build.bat) compiles source file [**`HelloWorld.kt`**](HelloWorld/src/main/kotlin/HelloWorld.kt) and executes the generated Java class file(s) <sup id="anchor_02">[2](#footnote_02)</sup>:

<pre style="font-size:80%;">
<b>&gt; <a href="HelloWorld/build.bat">build</a> clean run</b>
Hello World!
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f target\classes | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v "^[A-Z]"</b>
+---META-INF
|       main.kotlin_module
\---<b>org</b>
    \---<b>example</b>
        \---<b>main</b>
                HelloWorldKt.class
</pre>

> **:mag_right:** We observe the naming convention for generated class files: **`HelloWorldKt.class`** is generated for source file **`HelloWorld.kt`**.

Command [**`build.bat -native clean run`**](HelloWorld/build.bat) generates and executes the native executable for the default target <sup id="anchor_01"><a href="#footnote_01">1</a></sup>:

<pre style="font-size:80%;">
<b>&gt; <a href="HelloWorld/build.bat">build</a> -native clean run</b>
Hello World!
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v "^[A-Z]"</b>
    HelloWorld.exe
    kotlinc-native_opts.txt
    kotlinc-native_sources.txt
</pre>

> **:mag_right:** The [**`pelook`**][bytepointer_pelook] utility can help us getting more information about the native executable:
> <pre style="font-size:80%;">
> <b>&gt; <a href="http://bytepointer.com/tools/pelook_cmdline.htm">pelook.exe</a> -h target\HelloWorld.exe | <a href="https://man7.org/linux/man-pages/man1/head.1.html">head</a> -7</b>
> loaded "target\HelloWorld.exe" / 478599 (0x74D87) bytes
> signature/type:       PE64 EXE image for amd64
> image checksum:       0x0007FD9A (OK)
> machine:              0x8664 (amd64)
> subsystem:            3 (Windows Console)
> minimum os:           4.0 (Win95/NT4)
> linkver:              2.32
</pre>

## <span id="java_kotlin">`JavaToKotlin` Example (JVM only)</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./JavaToKotlin/build.bat">build.bat</a>
|   <a href="./JavaToKotlin/build.gradle">build.gradle</a>  <i>(parent: <a href="./common.gradle">common.gradle</a>)</i>
|   <a href="./JavaToKotlin/build.sh">build.sh</a>
|   <a href="./JavaToKotlin/build.xml">build.xml</a>     <i>(parent: <a href="./build.xml">build.xml</a>)</i>
|   <a href="./JavaToKotlin/gradle.properties">gradle.properties</a>
|   <a href="./JavaToKotlin/Makefile">Makefile</a>      <i>(parent: <a href="./Makefile.inc">Makefile.inc</a>)</i>
|   <a href="./JavaToKotlin/pom.xml">pom.xml</a>       <i>(parent: <a href="./pom.xml">pom.xml</a>)</i>
+---<b>config</b>
|   \---<b>checkstyle</b>
|           <a href="./JavaToKotlin/config/checkstyle/checkstyle.xml">checkstyle.xml</a>
|           <a href="./JavaToKotlin/config/checkstyle/suppressions.xml">suppressions.xml</a>
\---<b>src</b>
    +---<b>main</b>
    |   +---<b>java</b>
    |   |       <a href="./JavaToKotlin/src/main/java/IntBox.java">IntBox.java</a>
    |   |       <a href="./JavaToKotlin/src/main/java/User.java">User.java</a>
    |   \---<b>kotlin</b>
    |           <a href="./JavaToKotlin/src/main/kotlin/Main.kt">Main.kt</a>
    \---<b>test</b>
        \---<b>kotlin</b>
                <a href="./JavaToKotlin/src/test/kotlin/JavaToKotlinJUnitTest.kt">JavaToKotlinJUnitTest.kt</a>
</pre>

Either command [**`build.bat clean run`**](JavaToKotlin/build.bat) or command [**`gradle.bat -q clean run`**](JavaToKotlin/build.gradle) compiles the source files [**`IntBox.java`**](JavaToKotlin/src/main/java/IntBox.java), [**`User.java`**](JavaToKotlin/src/main/java/User.java) and [**`Main.kt`**](JavaToKotlin/src/main/kotlin/Main.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="JavaToKotlin/build.bat">build</a> clean run</b>
name=&lt;name&gt; active=true
name=Bob active=true
three=3
&nbsp;
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run</b>
name=&lt;name&gt; active=true
name=Bob active=true
three=3
</pre>

See Kotlin reference documentation: [Calling Java code from Kotlin][java_kotlin].

<!--=======================================================================-->

## <span id="kotlin_java">`KotlinToJava` Example (JVM only)</span>

Either command [**`build.bat clean run`**](KotlinToJava/build.bat) or command [**`gradle.bat -q clean run runJava`**](KotlinToJava/build.gradle) compiles the source files [**`JavaInteropt.java`**](KotlinToJava/src/main/java/JavaInteropt.java) and [**`JavaInterop.kt`**](KotlinToJava/src/main/kotlin/JavaInterop.kt) and produces the following output (Kotlin output first and then Java output):

<pre style="font-size:80%;">
<b>&gt; <a href="KotlinToJava/build.bat">build</a> clean run</b>
[kt] this is a message: a message
[kt] another message: a message
&nbsp;
[kt] call callback function
[java] Hello, hi!
[kt] call companion function
&nbsp;
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run runJava</b>
[kt] this is a message: a message
[kt] another message: a message
&nbsp;
[kt] call callback function
[java] Hello, hi!
[kt] call companion function
</pre>

See Kotlin reference documentation: [Calling Kotlin from Java][kotlin_java].

<!--=======================================================================-->

## <span id="features">`LanguageFeatures` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./LanguageFeatures/00download.txt">00download.txt</a>
|   <a href="./LanguageFeatures/build.bat">build.bat</a>
|   <a href="./LanguageFeatures/build.gradle">build.gradle</a>
|   <a href="./LanguageFeatures/build.sh">build.sh</a>
|   <a href="./LanguageFeatures/build.xml">build.xml</a>
|   <a href="./LanguageFeatures/gradle.properties">gradle.properties</a>
|   <a href="./LanguageFeatures/Makefile">Makefile</a>
|   pom.xml</a>
\---<b>src</b>
    +---<b>main</b>
    |   \---<b>kotlin</b>
    |           <a href="./LanguageFeatures/src/main/kotlin/LanguageFeatures.kt">LanguageFeatures.kt</a>
    \---<b>test</b>
        \---<b>kotlin</b>
                <a href="./LanguageFeatures/src/test/kotlin/LanguageFeaturesJUnitTest.kt">LanguageFeaturesJUnitTest.kt</a>
</pre>

Either command [**`build.bat clean run`**](LanguageFeatures/build.bat) or command [**`gradle.bat -q clean run`**](LanguageFeatures/build.gradle) compiles source file  [**`LanguageFeatures.kt`**](LanguageFeatures/src/main/kotlin/LanguageFeatures.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> -q clean run</b>
int a: 2
penDown
forward 100.0
turn 90.0
forward 100.0
turn 90.0
forward 100.0
turn 90.0
forward 100.0
turn 90.0
penUp
250
John we welcome you!
200
-10
4
null
</pre>

> **:mag_right:** The list of error messages associated with the `@Suppress` annotation can be found in source file [`DefaultErrorMessages.java`](https://github.com/JetBrains/kotlin/blob/master/compiler/frontend/src/org/jetbrains/kotlin/diagnostics/rendering/DefaultErrorMessages.java).

<!--=======================================================================-->

## <span id="quicksort">`QuickSort` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./QuickSort/00download.txt">00download.txt</a>
|   <a href="./QuickSort/build.bat">build.bat</a>
|   <a href="./QuickSort/build.gradle">build.gradle</a>
|   <a href="./QuickSort/build.sh">build.sh</a>
|   <a href="./QuickSort/build.xml">build.xml</a>
|   <a href="./QuickSort/gradle.properties">gradle.properties</a>
|   <a href="./QuickSort/Makefile">Makefile</a>
|   <a href="./QuickSort/pom.xml">pom.xml</a>
\---src
    +---main
    |   \---<b>kotlin</b>
    |           <a href="./QuickSort/src/main/kotlin/QuickSort.kt">QuickSort.kt</a>
    \---test
        \---kotlin
                <a href="./QuickSort/src/test/kotlin/QuickSortJUnitTest.kt">QuickSortJUnitTest.kt</a>
</pre>

Command [**`build.bat`**](./QuickSort/build.bat) builds and runs the Java main program `QuickSortKt.class` :

<pre style="font-size:80%;">
<b>&gt; <a href="./QuickSort/build.bat">build</a> clean run</b>
Original Array: 64, 34, 25, 12, 22, 11, 90
Sorted Array: 11, 12, 22, 25, 34, 64, 90
</pre>

Command [**`make TOOLSET=native clean run`**](./QuickSort/Makefile) builds and runs the native main program `QuickSort.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.gnu.org/software/make/manual/html_node/Running.html">make</a> TOOLSET=native clean run</b>
"/usr/bin/rm.exe" -rf "target"
## Check Maven dependencies on https://repo1.maven.org/maven2
[ -d "target/classes" ] || "/usr/bin/mkdir.exe" -p "target/classes"
"C:/opt/kotlinc-1.9.23/bin/kotlinc.bat" -language-version 1.7 -d target/classes src/main/kotlin/QuickSort.kt
"C:/opt/jdk-temurin-17.0.11_9/bin/jar.exe" cf target/QuickSort.jar -C target/classes .
"C:/opt/kotlinc-1.9.23/bin/kotlin.bat" -cp target/QuickSort.jar QuickSortKt
Original Array: 64, 34, 25, 12, 22, 11, 90
Sorted Array: 11, 12, 22, 25, 34, 64, 90
</pre>

<!--=======================================================================-->

## <span id="reflection">`Reflection` Example (JVM only)</span>

Command [**`build.bat -timer clean run`**](Reflection/build.bat) compiles source file [**`Reflection.kt`**](Reflection/src/main/kotlin/Reflection.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="Reflection/build.bat">build</a> -timer clean run</b>
Source code:
    data class Person(
        val name: String,
        var age: Int
    )

Methods:
    fun component1: class java.lang.String
    fun component2: int
    fun copy: class Person
    fun copy$default: class Person
    fun equals: boolean
    fun getAge: int
    fun getName: class java.lang.String
    fun hashCode: int
    fun setAge: void
    fun toString: class java.lang.String

Members:
    var age: kotlin.Int
    val name: kotlin.String
Elapsed time: 00:00:06
</pre>

Alternatively command [**`gradle.bat -q clean run`**][gradle_cli] (build script [**`build.gradle`**](Reflection/build.gradle) and property file [**`gradle.properties`**](Reflection/gradle.properties)) produces the same result:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> clean run</b>

&gt; Task :run
Source code:
    data class Person(
        val name: String,
        var age: Int
    )

Methods:
    fun component1: class java.lang.String
    fun component2: int
    fun copy: class Person
    fun copy$default: class Person
    fun equals: boolean
    fun getAge: int
    fun getName: class java.lang.String
    fun hashCode: int
    fun setAge: void
    fun toString: class java.lang.String

Members:
    var age: kotlin.Int
    val name: kotlin.String

BUILD SUCCESSFUL in 3s
3 actionable tasks: 3 executed
</pre>

> **:mag_right:** Execution time for command [**`build.bat`**](Reflection/build.bat) is always 6 seconds while with command [**`gradle.bat`**][gradle_cli] that time goes down from 15 seconds to 3 seconds once the [Gradle daemon][gradle_daemon] is running (see command **`gradle --status`**).

<!--=======================================================================-->

## <span id="selectionsort">`SelectionSort` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./SelectionSort/00download.txt">00download.txt</a>
|   <a href="./SelectionSort/build.bat">build.bat</a>
|   <a href="./SelectionSort/build.gradle">build.gradle</a>
|   <a href="./SelectionSort/build.sh">build.sh</a>
|   <a href="./SelectionSort/build.xml">build.xml</a>
|   <a href="./SelectionSort/gradle.properties">gradle.properties</a>
|   <a href="./SelectionSort/Makefile">Makefile</a>
|   <a href="./SelectionSort/pom.xml">pom.xml</a>
\---src
    +---main
    |   \---kotlin
    |           <a href="./SelectionSort/src/main/kotlin/QuickSort.kt">SelectionSort.kt</a>
    \---test
        \---kotlin
                <a href="./SelectionSort/src/test/kotlin/QuickSortJUnitTest.kt">SelectionSortJUnitTest.kt</a>
</pre>

Command [**`build.bat`**](./SelectionSort/build.bat) builds and runs the Java main program `SelectionSortKt.class` :

<pre style="font-size:80%;">
<b>&gt; <a href="./SelectionSort/build.bat">build</a> clean run</b>
Original Array: 64, 34, 25, 12, 22, 11, 90
Sorted Array: 11, 12, 22, 25, 34, 64, 90
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Available targets*** [↩](#anchor_01)

<dl><dd>
Command <b><code>kotlinc-native -list-targets</code></b> displays the list of available targets:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options">kotlinc-native</a> -version</b>
info: kotlinc-native 1.9.20 (JRE 11.0.21+9)
Kotlin/Native: 1.9.20
&nbsp;
<b>&gt; <a href="https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options">kotlinc-native</a> -list-targets</b>
linux_x64:                              linux
linux_arm32_hfp:                        raspberrypi
linux_arm64:
linux_mips32:
linux_mipsel32:
mingw_x86:
mingw_x64:                    (default) mingw
android_x86:
android_x64:
android_arm32:
android_arm64:
wasm32:
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Kotlin compiler option <code>-d</code>*** [↩](#anchor_02)

<dl><dd>
The <a href="https://kotlinlang.org/">Kotlin/JVM</a> compiler generates a single Java archive file if the <b><code>-d</code></b> option argument ends with <b><code>.jar</code></b> (in our case <b><code>target\HelloWorld.jar</code></b>).
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://kotlinlang.org/docs/reference/compiler-reference.html">kotlinc</a> -d target\HelloWorld.jar src\HelloWorld.kt</b>
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> HelloWorld.jar</b>
02.11.2019  16:45             1 164 HelloWorld.jar
&nbsp;
<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jar.html">jar</a> tf target\HelloWorld.jar</b>
META-INF/MANIFEST.MF
HelloWorldKt.class
META-INF/main.kotlin_module
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***Execution on JVM*** [↩](#anchor_03)

<dl><dd>
On the JVM platform a <a href="https://kotlinlang.org/">Kotlin</a> program can be executed in several ways depending on two parameters:
- We run command <b><code>kotlin.bat</code></b> or command <b><code>java.exe</code></b>.
- We generated either class files or a single JAR file for our <b><code>HelloWorld</code></b> program.
</dd>
<dd>
<table>
<tr><th>Command</th><th>Class/JAR file</th><th>Session example</th></tr>
<tr><td><code>kotlin.bat</code></td><td><code>HelloWorldKt</code></td><td style="font-size:90%;"><code><b>&gt; kotlin -cp target\classes HelloWorldKt</b></code><br/><code>Hello World!</code></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td style="font-size:90%;"><b><code>&gt; kotlin -J-Xbootclasspath/a:%CPATH% -jar target\HelloWorld.jar</b></code></br><code>Hello World!</code></td></tr>
<tr><td><code>java.exe</code></td><td><code>HelloWorldKt</code></td><td style="font-size:90%;"><code><b>&gt; java -cp %CPATH%;target\classes HelloWorldKt</b></code><br/><code>Hello World!</code></td></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td style="font-size:90%;"><code><b>&gt; java -Xbootclasspath/a:%CPATH% -jar target\HelloWorld.jar</b></code><br/><code>Hello World!</code></td></tr>
</table>
<span style="font-size:80%;"><sup>(1)</sup> <b><code>CPATH=c:\opt\kotlinc-1.4.32\lib\kotlin-stdlib.jar</code></b></span>
</dd>
<dd>
The command line is shorter if the <a href="https://kotlinlang.org/">Kotlin</a> runtime is included in archive file <b><code>HelloWorld.jar</code></b> (option <b><code>-include-runtime</code></b>):
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://kotlinlang.org/docs/reference/compiler-reference.html">kotlinc</a> -include-runtime -d target\HelloWorld.jar src\HelloWorld.kt</b>
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> HelloWorld.jar</b>
02.11.2019  16:40         1 309 824 HelloWorld.jar
&nbsp;
<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jar.html">jar</a> tf target\HelloWorld.jar</b>
META-INF/MANIFEST.MF
HelloWorldKt.class
META-INF/main.kotlin_module
kotlin/collections/ArraysUtilJVM.class
kotlin/jvm/internal/CallableReference$NoReceiver.class
kotlin/jvm/internal/CallableReference.class
[..]
kotlin/coroutines/EmptyCoroutineContext.class
kotlin/coroutines/intrinsics/CoroutineSingletons.class
&nbsp;
<b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html">java</a> -jar target\HelloWorld.jar</b>
Hello World!
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_maven_cli]: https://maven.apache.org/ref/3.8.1/maven-embedder/cli.html
[bytepointer_pelook]: http://bytepointer.com/tools/index.htm#pelook
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[cygwin]: https://cygwin.com/install.html
[gmake_cli]: https://www.gnu.org/software/make/manual/make.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_daemon]: https://docs.gradle.org/current/userguide/gradle_daemon.html
[groovy_dsl]: https://docs.gradle.org/current/dsl/index.html
[java_kotlin]: https://kotlinlang.org/docs/reference/java-interop.html#calling-java-code-from-kotlin
[kotlin]: https://kotlinlang.org/
[kotlin_dsl]: https://docs.gradle.org/current/userguide/kotlin_dsl.html
[kotlin_java]: https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#calling-kotlin-from-java
[kotlin_js]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjs-compiler-options
[kotlin_jvm]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjvm-compiler-options
[kotlin_native]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options
[maven]: https://maven.apache.org/what-is-maven.html
[msys2]: https://www.msys2.org/
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
