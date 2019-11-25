# <span id="top">Kotlin code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:25%;"><a href="https://kotlinlang.org/"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Kotlin-logo.svg/120px-Kotlin-logo.svg.png" width="100" alt="Kotlin"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples coming from various websites and books.<br/>
  It also includes several batch scripts for experimenting with <a href="https://kotlinlang.org/">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

In this document we present the following [Kotlin] code examples:

- [HelloWorld](#hello-jvm) (JVM)
- [HelloWorld](#hello-native) (Native)
- [Reflection](#reflection)

There are three Kotlin compilers:
- The [Kotlin/JVM][kotlin_jvm] compiler generates class/JAR files.
- The [Kotlin/JS][kotlin_js] compiler generates JavaScript code.
- The [Kotlin/Native][kotlin_native] compiler generates native codefor the supported targets <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup>.

## <span id="hello-jvm">HelloWorld (JVM)</span>

Let's take as a first example the [**`HelloWorld`**](HelloWorld/) program.

<pre style="font-size:80%;">
<b>&gt; cd HelloWorld</b>
<b>&gt; type src\HelloWorld.kt</b>
<b>fun</b> main(args: Array&lt;String&gt;) {
    println(<span style="color:#990000;">"Hello World!"</span>)
}
</pre>

The [Kotlin/JVM](https://kotlinlang.org/) compiler generates Java class files if the **`-d`** option argument *does not* end with **`.jar`** (in our case **`target\classes`**).

<pre style="font-size:80%;">
<b>&gt; mkdir target\classes\</b>
<b>&gt; kotlinc -d target\classes src\HelloWorld.kt</b>
<b>&gt; tree /a /f target\classes | findstr /v "^[A-Z]"</b>
|   HelloWorldKt.class
|
\---META-INF
         main.kotlin_module
</pre>

> **:mag_right:** We observe the naming convention for generated class files: **`HelloWorldKt.class`** is generated for source file **`HelloWorld.kt`**.

The [Kotlin/JVM](https://kotlinlang.org/) compiler generates a single Java archive file if the **`-d`** option argument ends with **`.jar`** (in our case **`target\HelloWorld.jar`**).

<pre style="font-size:80%;">
<b>&gt; kotlinc -d target\HelloWorld.jar src\HelloWorld.kt</b>
<b>&gt; dir target | findstr HelloWorld.jar</b>
02.11.2019  16:45             1 164 HelloWorld.jar
<b>&gt; jar tf target\HelloWorld.jar</b>
META-INF/MANIFEST.MF
HelloWorldKt.class
META-INF/main.kotlin_module
</pre>

> **:mag_right:** Specifying option **`-include-runtime`** will add the [Kotlin](https://kotlinlang.org/) runtime to the generated JAR file:
> <pre style="font-size:80%;">
> <b>&gt; kotlinc -include-runtime -d target\HelloWorld.jar src\HelloWorld.kt</b>
> <b>&gt; dir target | findstr HelloWorld.jar</b>
> 02.11.2019  16:40         1 309 824 HelloWorld.jar
> <b>&gt; jar tf target\HelloWorld.jar</b>
> META-INF/MANIFEST.MF
> HelloWorldKt.class
> META-INF/main.kotlin_module
> kotlin/collections/ArraysUtilJVM.class
> kotlin/jvm/internal/CallableReference$NoReceiver.class
> kotlin/jvm/internal/CallableReference.class
> [..]
> kotlin/coroutines/EmptyCoroutineContext.class
> kotlin/coroutines/intrinsics/CoroutineSingletons.class
> </pre>


On the JVM platform a [Kotlin](https://kotlinlang.org/) program can be executed in several ways depending on two factors:
- We run command **`kotlin.bat`** or command **`java.exe`**.
- We generated either class files or a single JAR file for our **`HelloWorld`** program.

<table>
<tr><th>Command</th><th>Class/JAR file</th><th>Session example</th></tr>
<tr><td><code>kotlin.bat</code></td><td><code>HelloWorldKt</code></td><td><code><b>&gt; kotlin -cp target\classes HelloWorldKt</b></br>Hello World!</code></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td><code><b>&gt; set BCPATH=c:\opt\kotlinc-1.3.50\lib\kotlin-stdlib.jar</br>&gt; kotlin -J-Xbootclasspath/a:%BCPATH% -jar target\HelloWorld.jar</b></br>Hello World!</code></td></tr>
<tr><td><code>java.exe</code></td><td><code>HelloWorldKt</code></td><td><code><b>&gt; set CPATH=c:\opt\kotlinc-1.3.50\lib\kotlin-stdlib.jar;target\classes<br/>&gt; java -cp %CPATH% HelloWorldKt</b></br>Hello World!</code></td></tr>
<tr><td>&nbsp;</td><td><code>HelloWorld.jar</code></td><td><code><b>&gt; set BCPATH=c:\opt\kotlinc-1.3.50\lib\kotlin-stdlib.jar</br>&gt; java -Xbootclasspath/a:%BCPATH% -jar target\HelloWorld.jar</code></b></br>Hello World!</code></td></tr>
</table>

> **:mag_right:** We can write a shorter command line if the [Kotlin](https://kotlinlang.org/) runtime is included in archive file **`HelloWorld.jar`** (option **`-include-runtime`**): 
> <pre style="font-size:80%;">
> <b>&gt; java -jar target\HelloWorld.jar</b>
> Hello World!
> </pre>

## <span id="hello-native">HelloWorld (Native)</span>

Command **`kotlinc-native -o <exe_file> <kt_files>`** generates the native executable for the default target <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> (default target on Windows: **`mingw_x64`**).

<pre style="font-size:80%;"> 
<b>&gt; mkdir target\</b>
<b>&gt; kotlinc-native -o target\HelloWorld.exe src\main\kotlin\HelloWorld.kt</b>
&nbsp;
<b>&gt; tree /a /f target | findstr /v "^[A-Z]"</b>
|   HelloWorld.exe
|   HelloWorld.jar
|   ktlint-report.xml
|
\---classes
    |   HelloWorldKt.class
    |
    \---META-INF
            main.kotlin_module
</pre>

## <span id="reflection">Reflection</span>


## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Command <b><code>kotlinc-native -list-targets</code></b> displays the list of available targets:
</p>
<pre style="font-size:80%;">
<b>&gt; kotlinc-native -list-targets</b>
mingw_x64:                    (default) mingw
mingw_x86:
linux_x64:                              linux
linux_arm32_hfp:                        raspberrypi
linux_arm64:
android_arm32:
wasm32:
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[kotlin]: https://kotlinlang.org/
[kotlin_js]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjs-compiler-options
[kotlin_jvm]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinjvm-compiler-options
[kotlin_native]: https://kotlinlang.org/docs/reference/compiler-reference.html#kotlinnative-compiler-options
