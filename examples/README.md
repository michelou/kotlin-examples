# <span id="top">Kotlin code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Kotlin-logo.svg/120px-Kotlin-logo.svg.png" width="100" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>/<a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html">Gradle scripts</a> for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

In this document we present the following [Kotlin] code examples:

- [HelloWorld](#hello-jvm) (JVM/native)
- [JavaToKotlin](#java_kotlin) (JVM only)
- [KotlinToJava](#kotlin_java) (JVM only)
- [LanguageFeatures](#features) (JVM/native)
- [Reflection](#reflection) (JVM only)

> **:mag_right:** There exist three Kotlin compilers and some code examples are only valid with one of them:
> - The [Kotlin/JVM][kotlin_jvm] compiler generates class/JAR files.
> - The [Kotlin/JS][kotlin_js] compiler generates JavaScript code.
> - The [Kotlin/Native][kotlin_native] compiler generates native codefor the supported targets <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.

<!--
**`kotlin-stdlib`** contains most of the functionality: Collections, Ranges, Math, Regex, File extensions, Locks, etc... Most of what you use daily is in kotlin-stdlib
-->

We provide 4 different ways to build/run the code examples:
- **`build.bat`** is the old-fashioned batch file.
- **`build.gradle`** is the Gradle build script written in [Groovy DSL][groovy_dsl].
- **`build.gradle.kts`** is the Gradle build script written in [Kotlin DSL][kotlin_dsl].
- **`pom.xml`** is the Maven build script written in XML.

> **:mag_right:** Command [**`build help`**](HelloWorld/build.bat) displays the help message:
> <pre style="font-size:80%;">
> <b>&gt; build help</b>
> Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
> &nbsp;
>  Options:
>    -debug      show commands executed by this script
>    -native     generated native executable
>    -timer      display total elapsed time
>    -verbose    display progress messages
> &nbsp;
>  Subcommands:
>    clean       delete generated files
>    compile     generate class files
>    help        display this help message
>    lint        analyze Kotlin source files with KtLint
>    run         execute the generated program
</pre>

## <span id="hello-jvm">HelloWorld (JVM/native)</span>

Command [**`build clean run`**](HelloWorld/build.bat) compiles source file [**`HelloWorld.kt`**](HelloWorld/src/main/kotlin/HelloWorld.kt) and executes the generated Java class file(s) <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup>:

<pre style="font-size:80%;">
<b>&gt; <a href="HelloWorld/build.bat">build</a> clean run</b>
Hello World!
&nbsp;
<b>&gt; tree /a /f target\classes | findstr /v "^[A-Z]"</b>
+---META-INF
|       main.kotlin_module
|
\---org
    \---example
        \---main
                HelloWorldKt.class
</pre>

> **:mag_right:** We observe the naming convention for generated class files: **`HelloWorldKt.class`** is generated for source file **`HelloWorld.kt`**.

Command [**`build -native clean run`**](HelloWorld/build.bat) generates and executes the native executable for the default target <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>:

<pre style="font-size:80%;">
<b>&gt; build -native clean run</b>
Hello World!
&nbsp;
<b>&gt; tree /a /f target | findstr /v "^[A-Z]"</b>
    HelloWorld.exe
    ktlint-report.xml
</pre>

> **:mag_right:** The [**`pelook`**][bytepointer_pelook] utility can help us getting more information about the native executable:
> <pre style="font-size:80%;">
> <b>&gt; pelook.exe -h target\HelloWorld.exe | head -7</b>
> loaded "target\HelloWorld.exe" / 478599 (0x74D87) bytes
> signature/type:       PE64 EXE image for amd64
> image checksum:       0x0007FD9A (OK)
> machine:              0x8664 (amd64)
> subsystem:            3 (Windows Console)
> minimum os:           4.0 (Win95/NT4)
> linkver:              2.32
</pre>

## <span id="java_kotlin">JavaToKotlin (JVM only)</span>

Either command [**`build clean run`**](JavaToKotlin/build.bat) or command [**`gradle -q clean run`**](JavaToKotlin/build.gradle) compiles the source files [**`IntBox.java`**](JavaToKotlin/src/main/java/IntBox.java), [**`User.java`**](JavaToKotlin/src/main/java/User.java) and [**`Main.kt`**](JavaToKotlin/src/main/kotlin/Main.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; build clean run</b>
name=&lt;name&gt; active=true
name=Bob active=true
three=3
&nbsp;
<b>&gt; gradle -q clean run</b>
name=&lt;name&gt; active=true
name=Bob active=true
three=3
</pre>

See Kotlin reference documentation: [Calling Java code from Kotlin][java_kotlin].

## <span id="kotlin_java">KotlinToJava (JVM only)</span>

Either command [**`build clean run`**](KotlinToJava/build.bat) or command [**`gradle -q clean run runJava`**](KotlinToJava/build.gradle) compiles the source files [**`JavaInteropt.java`**](KotlinToJava/src/main/java/JavaInteropt.java) and [**`JavaInterop.kt`**](KotlinToJava/src/main/kotlin/JavaInterop.kt) and produces the following output (Kotlin output first and then Java output):

<pre style="font-size:80%;">
<b>&gt; build clean run</b>
[kt] this is a message: a message
[kt] another message: a message
&nbsp;
[kt] call callback function
[java] Hello, hi!
[kt] call companion function
&nbsp;
<b>&gt; gradle -q clean run runJava</b>
[kt] this is a message: a message
[kt] another message: a message
&nbsp;
[kt] call callback function
[java] Hello, hi!
[kt] call companion function
</pre>

See Kotlin reference documentation: [Calling Kotlin from Java][kotlin_java].

## <span id="features">LanguageFeatures (JVM/native)</span>

Either command [**`build clean run`**](LanguageFeatures/build.bat) or command [**`gradle -q clean run`**](LanguageFeatures/build.gradle) compiles source file  [**`LanguageFeatures.kt`**](LanguageFeatures/src/main/kotlin/LanguageFeatures.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; gradle -q clean run</b>
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

## <span id="reflection">Reflection (JVM only)</span>

Command [**`build -timer clean run`**](Reflection/build.bat) compiles source file [**`Reflection.kt`**](Reflection/src/main/kotlin/Reflection.kt) and produces the following output:

<pre style="font-size:80%;">
<b>&gt; build -timer clean run</b>
Source code:
    data class Person(
        val name: String,
        var age: Int
    )

Methods:
    fun equals: boolean
    fun toString: class java.lang.String
    fun hashCode: int
    fun getName: class java.lang.String
    fun copy: class Person
    fun component1: class java.lang.String
    fun component2: int
    fun getAge: int
    fun copy$default: class Person
    fun setAge: void

Members:
    var age: kotlin.Int
    val name: kotlin.String
Elapsed time: 00:00:06
</pre>

Alternatively command [**`gradle -q clean run`**][gradle_bat] (build script [**`build.gradle`**](Reflection/build.gradle) and property file [**`gradle.properties`**](Reflection/gradle.properties)) produces the same result:

<pre style="font-size:80%;">
<b>&gt; gradle clean run</b>

&gt; Task :run
Source code:
    data class Person(
        val name: String,
        var age: Int
    )

Methods:
    fun equals: boolean
    fun toString: class java.lang.String
    fun hashCode: int
    fun getName: class java.lang.String
    fun copy: class Person
    fun component2: int
    fun copy$default: class Person
    fun getAge: int
    fun setAge: void
    fun component1: class java.lang.String

Members:
    var age: kotlin.Int
    val name: kotlin.String

BUILD SUCCESSFUL in 3s
3 actionable tasks: 3 executed
</pre>

> **:mag_right:** Execution time for command [**`build.bat`**](Reflection/build.bat) is always 6 seconds while with command [**`gradle.bat`**][gradle_bat] that time goes down from 15 seconds to 3 seconds once the [Gradle daemon][gradle_daemon] is running (see command **`gradle --status`**).

## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Command <b><code>kotlinc-native -list-targets</code></b> displays the list of available targets:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; kotlinc-native -version</b>
info: kotlinc-native 1.3.72-release-424 (JRE 1.8.0_252-b09)
Kotlin/Native: 1.3.72
&nbsp;
<b>&gt; kotlinc-native -list-targets</b>
mingw_x64:                    (default) mingw
mingw_x86:
linux_x64:                              linux
linux_arm32_hfp:                        raspberrypi
linux_arm64:
android_x86:
android_x64:
android_arm32:
android_arm64:
wasm32:
</pre>

<a name="footnote_02">[2]</a> ***Kotlin compiler option <code>-d</code>*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
The <a href="https://kotlinlang.org/">Kotlin/JVM</a> compiler generates a single Java archive file if the <b><code>-d</code></b> option argument ends with <b><code>.jar</code></b> (in our case <b><code>target\HelloWorld.jar</code></b>).
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; kotlinc -d target\HelloWorld.jar src\HelloWorld.kt</b>
<b>&gt; dir target | findstr HelloWorld.jar</b>
02.11.2019  16:45             1 164 HelloWorld.jar
<b>&gt; jar tf target\HelloWorld.jar</b>
META-INF/MANIFEST.MF
HelloWorldKt.class
META-INF/main.kotlin_module
</pre>

<a name="footnote_03">[3]</a> ***Execution on JVM*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
On the JVM platform a <a href="https://kotlinlang.org/">Kotlin</a> program can be executed in several ways depending on two parameters:
- We run command <b><code>kotlin.bat</code></b> or command <b><code>java.exe</code></b>.
- We generated either class files or a single JAR file for our <b><code>HelloWorld</code></b> program.
</p>
<table style="margin:0 0 1em 20px;">
<tr><th>Command</th><th>Class/JAR file</th><th>Session example</th></tr>
<tr><td><code>kotlin.bat</code></td><td><code>HelloWorldKt</code></td><td><code><b>&gt; kotlin -cp target\classes HelloWorldKt</b><br/>Hello World!</code></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td><b><code>&gt; kotlin -J-Xbootclasspath/a:%CPATH% -jar target\HelloWorld.jar</b></br>Hello World!</code></td></tr>
<tr><td><code>java.exe</code></td><td><code>HelloWorldKt</code></td><td><code><b>&gt; java -cp %CPATH%;target\classes HelloWorldKt</b><br/>Hello World!</code></td></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td><code><b>&gt; java -Xbootclasspath/a:%CPATH% -jar target\HelloWorld.jar</b><br/>Hello World!</code></td></tr>
</table>
<span style="margin:0 0 1em 20px;font-size:80%;"><sup>(1)</sup> <b><code>CPATH=c:\opt\kotlinc-1.3.72\lib\kotlin-stdlib.jar</code></b></span>

<p style="margin:0 0 1em 20px;">
The command line is shorter if the <a href="https://kotlinlang.org/">Kotlin</a> runtime is included in archive file <b><code>HelloWorld.jar</code></b> (option <b><code>-include-runtime</code></b>):
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; kotlinc -include-runtime -d target\HelloWorld.jar src\HelloWorld.kt</b>
<b>&gt; dir target | findstr HelloWorld.jar</b>
02.11.2019  16:40         1 309 824 HelloWorld.jar
&nbsp;
<b>&gt; jar tf target\HelloWorld.jar</b>
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
<b>&gt; java -jar target\HelloWorld.jar</b>
Hello World!
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[bytepointer_pelook]: http://bytepointer.com/tools/index.htm#pelook
[gradle_bat]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_daemon]: https://docs.gradle.org/current/userguide/gradle_daemon.html
[groovy_dsl]: https://docs.gradle.org/current/dsl/index.html
[java_kotlin]: https://kotlinlang.org/docs/reference/java-interop.html#calling-java-code-from-kotlin
[kotlin]: https://kotlinlang.org/
[kotlin_dsl]: https://docs.gradle.org/current/userguide/kotlin_dsl.html
[kotlin_java]: https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html#calling-kotlin-from-java
[kotlin_js]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjs-compiler-options
[kotlin_jvm]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjvm-compiler-options
[kotlin_native]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options
