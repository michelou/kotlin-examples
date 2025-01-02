# <span id="top">Kotlin language changes</span> <span style="font-size:90%;">[↩](README.md#top)</span>
  

## <span id="1.7">1.7</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-46860][kt_46860]</span> | Core | Source | The type of safe call result is always nullable, even when the receiver of the safe call is non-nullable. |
| <span style="white-space: nowrap;">[KT-41124][kt_41124]</span> | Core | Source | Prohibit access to uninitialized enum entries from the enum static initializer block when these entries are qualified with the enum name. |
| ... *(wip)* | | | |

Reference: [Compatibility guide for Kotlin 1.7](https://kotlinlang.org/docs/compatibility-guide-17.html).

## <span id="1.6">1.6</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-47709][kt_47709]</span> | Core | Source | Warn about the `when` statement with a  non-exhaustive enum, sealed, or Boolean subject |
| ... *(wip)* | | | |

Reference: [Compatibility guide for Kotlin 1.6](https://kotlinlang.org/docs/compatibility-guide-16.html).

## <span id="1.5">1.5</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-27825][kt_27825]</span> | Core | Source | Outlaw non-abstract classes containing abstract members invisible from that classes. |
| <span style="white-space: nowrap;">[KT-31227][kt_31227]</span> | Core | Source | Outlaw using array based on non-reified type parameters as reified type arguments on JVM. |
| <span style="white-space: nowrap;">[KT-31567][kt_31567]</span> | Core | Source | Outlaw references to the underscore symbol (_) that is used to omit parameter name of an exception in the catch block. |
| <span style="white-space: nowrap;">[KT-33917][kt_33917]</span> | Core | Source | Outlaw exposing anonymous types from private inline functions. |
| <span style="white-space: nowrap;">[KT-35224][kt_35224]</span> | Core | Source | Outlaw passing non-spread arrays after arguments with SAM-conversion. |
| <span style="white-space: nowrap;">[KT-35226][kt_35226]</span> | Core | Source | Outlaw usage of spread operator (*) on signature-polymorphic calls. |
| <span style="white-space: nowrap;">[KT-35870][kt_35870]</span> | Core | Source | Outlaw secondary enum class constructors which do not delegate to the primary constructor. |
| ... *(wip)* | | | |

Reference: [Compatibility guide for Kotlin 1.5](https://kotlinlang.org/docs/compatibility-guide-15.html).

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

[kt_27825]: https://youtrack.jetbrains.com/issue/KT-27825
[kt_31227]: https://youtrack.jetbrains.com/issue/KT-31227
[kt_31567]: https://youtrack.jetbrains.com/issue/KT-31567
[kt_33917]: https://youtrack.jetbrains.com/issue/KT-33917
[kt_35224]: https://youtrack.jetbrains.com/issue/KT-35224
[kt_35226]: https://youtrack.jetbrains.com/issue/KT-35226
[kt_35870]: https://youtrack.jetbrains.com/issue/KT-35870
[kt_41124]: https://youtrack.jetbrains.com/issue/KT-41124
[kt_46860]: https://youtrack.jetbrains.com/issue/KT-46860
[kt_47709]: https://youtrack.jetbrains.com/issue/KT-47709
