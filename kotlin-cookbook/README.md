# <span id="top">*Kotlin Cookbook* code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://kotlinlang.org/"><img src="https://kotlinlang.org/assets/images/open-graph/kotlin_250x250.png" width="120" alt="Kotlin logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://kotlinlang.org/">Kotlin</a> code examples from <a href="http://shop.oreilly.com/product/0636920224327.do">Ken Kousen's book</a> "<i>Koltin Cookbook</i>" (O'Reilly, 2019).<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>/<a href="https://docs.gradle.org/current/userguide/writing_build_scripts.html">Gradle scripts</a> for experimenting with <a href="https://kotlinlang.org/" rel="external">Kotlin</a> on a Windows machine.
  </td>
  </tr>
</table>

## <span id="ex_03-10">Example 03-10 ― `Customer` class</span>

Lazy loading can be implemented the hard way (with a private nullable property) or using a built-in **`lazy`** delegate function.

Command [**`build clean run`**](./Example_03-10/build.bat) compiles the source files [**`Customer.kt`**](./Example_03-10/src/main/kotlin/Customer.kt) and executes the generated Java class files :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
K:\kotlin-cookbook\Example_03-10
&nbsp;
<b>&gt; <a href="./Example_03-10/build.bat">build</a> clean run</b>
Customer name: Fred
</pre>

Command [**`build -verbose test`**](./Example_03-10/build.bat) compiles the source file [**`CustomerKtTest.kt`**](./Example_03-10/src/test/kotlin/CustomerKtTest.kt) and executes the implemented unit tests :

<pre style="font-size:80%;">
<b>&gt; <a href="./Example_03-10/build.bat">build</a> -verbose test</b>
No compilation needed ('src\main\kotlin\*.kt')
Compile 1 Kotlin test source files (JVM) to directory "target\test-classes"
Execute test CustomerKtTestKt
.
+-- JUnit Jupiter [OK]
| '-- CustomerKtTest [OK]
|   '-- load messages() [OK]
'-- JUnit Vintage [OK]

Test run finished after 85 ms
[         3 containers found      ]
[         0 containers skipped    ]
[         3 containers started    ]
[         0 containers aborted    ]
[         3 containers successful ]
[         0 containers failed     ]
[         1 tests found           ]
[         0 tests skipped         ]
[         1 tests started         ]
[         0 tests aborted         ]
[         1 tests successful      ]
[         0 tests failed          ]
</pre>

## <span id="ex_03-13">Example 03-13 ― Overriding operator on `Point`</span>

Command [**`build clean run`**](./Example_03-13/build.bat) compiles the source files [**`PointMain.kt`**](./Example_03-13/src/main/kotlin/PointMain.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
K:\kotlin-cookbook\Example_03-13
&nbsp;
<b>&gt; <a href="./Example_03-13/build.bat">build</a> clean run</b>
Point(x=-10, y=-20)
</pre>

Command [**`build -verbose test`**](./Example_03-13/build.bat) compiles the source file [**`PointMainKtTest.kt`**](./Example_03-13/src/test/kotlin/PointMainKtTest.kt) and executes the implemented unit tests.

<pre style="font-size:80%;">
<b>&gt; <a href="./Example_03-13/build.bat">build</a> -verbose test</b>
No compilation needed ('src\main\kotlin\*.kt')
Compile 1 Kotlin test source files (JVM) to directory "target\test-classes"
Execute test MainKtTest
.
+-- JUnit Jupiter [OK]
| '-- MainKtTest [OK]
|   '-- point with negative axes$main() [OK]
'-- JUnit Vintage [OK]

Test run finished after 70 ms
[         3 containers found      ]
[         0 containers skipped    ]
[         3 containers started    ]
[         0 containers aborted    ]
[         3 containers successful ]
[         0 containers failed     ]
[         1 tests found           ]
[         0 tests skipped         ]
[         1 tests started         ]
[         0 tests aborted         ]
[         1 tests successful      ]
[         0 tests failed          ]
</pre>

## <span id="ex_03-14">Example 03-14 ― Extension functions on `Complex`</span>

Command [**`build clean run`**](./Example_03-14/build.bat) compiles the source files [**`ComplexOverloadOperators.kt`**](./Example_03-14/src/main/kotlin/ComplexOverloadOperators.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
K:\kotlin-cookbook\Example_03-14
&nbsp;
<b>&gt; <a href="./Example_03-14/build.bat">build</a> clean run</b>
x   = (1.0, 3.0)
y   = (2.0, 5.0)
x+y = (3.0, 8.0)
x*y = (-13.0, 11.0)
</pre>

Command [**`build -verbose test`**](./Example_03-14/build.bat) compiles the source file [**`ComplexOverloadOperatorsKtTest.kt`**](./Example_03-14/src/test/kotlin/ComplexOverloadOperatorsKtTest.kt) and executes the implemented unit tests.

<pre style="font-size:80%;">
<b>&gt; <a href="./Example_03-14/build.bat">build</a> -verbose test</b>
No compilation needed ('src\main\kotlin\*.kt')
Compile 1 Kotlin test source files (JVM) to directory "target\test-classes"
Execute test ComplexOverloadOperatorsKtTest
.
+-- JUnit Jupiter [OK]
| '-- ComplexOverloadOperatorsKtTest [OK]
|   +-- Euler's formula$main() [OK]
|   +-- plus$main() [OK]
|   +-- negate$main() [OK]
|   '-- minus$main() [OK]
'-- JUnit Vintage [OK]

Test run finished after 99 ms
[         3 containers found      ]
[         0 containers skipped    ]
[         3 containers started    ]
[         0 containers aborted    ]
[         3 containers successful ]
[         0 containers failed     ]
[         4 tests found           ]
[         0 tests skipped         ]
[         4 tests started         ]
[         0 tests aborted         ]
[         4 tests successful      ]
[         0 tests failed          ]
</pre>

## <span id="ex_04-01">Example 04-01 ― Summing integers by using `fold`</span>

Command [**`build clean run`**](./Example_04-01/build.bat) compiles the source files [**`FoldMain.kt`**](./Example_04-01/src/main/kotlin/FoldMain.kt) and executes the generated Java class files:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
K:\kotlin-cookbook\Example_04-01
&nbsp;
<b>&gt; <a href="./Example_04-01/build.bat">build</a> clean run</b>
<b>&gt; build clean run</b>
nums = [1, 3, 5, 7]
sum(*nums) = 16

acc = 0, n = 1
acc = 1, n = 3
acc = 4, n = 5
acc = 9, n = 7
sumWithTrace(*nums) = 16

factorialFold(20) = 2432902008176640000

fibonacciFold(20) = 6765
</pre>

Command [**`build -verbose test`**](./Example_04-01/build.bat) compiles the source file [**`FoldMainKtTest.kt`**](./Example_04-01/src/test/kotlin/FoldMainKtTest.kt) and executes the implemented unit tests.

<pre style="font-size:80%;">
<b>&gt; <a href="./Example_04-01/build.bat">build</a> -verbose test</b>
No compilation needed ('src\main\kotlin\*.kt')
Compile 1 Kotlin test source files (JVM) to directory "target\test-classes"
Execute test FoldMainKtTest
.
+-- JUnit Jupiter [OK]
| '-- FoldMainKtTest [OK]
|   '-- sum using fold$main() [OK]
'-- JUnit Vintage [OK]

Test run finished after 100 ms
[         3 containers found      ]
[         0 containers skipped    ]
[         3 containers started    ]
[         0 containers aborted    ]
[         3 containers successful ]
[         0 containers failed     ]
[         1 tests found           ]
[         0 tests skipped         ]
[         1 tests started         ]
[         0 tests aborted         ]
[         1 tests successful      ]
[         0 tests failed          ] build -verbose test</b>

</pre>

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[kotlin]: https://kotlinlang.org/
[kotlin_conventions]: https://kotlinlang.org/docs/reference/operator-overloading.html
[kotlin_data_classes]: https://kotlinlang.org/docs/reference/data-classes.html
[kotlin_extensions]: https://kotlinlang.org/docs/tutorials/kotlin-for-py/extension-functionsproperties.html
[kotlin_lambdas]: https://kotlinlang.org/docs/reference/lambdas.html
[kotlin_lazy_props]: https://www.kotlindevelopment.com/lazy-property/
[mvn_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
