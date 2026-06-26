# <span id="top">Kotlin language changes</span> <span style="font-size:90%;">[↩](README.md#top)</span>

## <span id="2.2">2.2</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-71793][kt_71793]</span> | Core | Source | Starting with **Kotlin 2.2**, the compiler no longer supports `-language-version=1.6` or `-language-version=1.7`.  |
| [KTLC-5][ktlc-5] | Core | Source | The `reified` modifier is no longer allowed on type parameters in type aliases. |
| [KTLC-21][ktlc-21] | Kotlin | Behavioral | Inline value classes are no longer treated as implementors of `java.lang.Number` or `java.lang.Comparable` in `is` and `as` checks |

Reference: [Compatibility guide for Kotlin 2.2](https://kotlinlang.org/docs/compatibility-guide-22.html).

## <span id="2.1">2.1</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-60521][kt_60521]</span> | Core | Source | **Kotlin 2.1** introduces language version 2.1 and removes support for language versions 1.4 and 1.5. Language versions 1.6 and 1.7 are deprecated. |

Reference: [Compatibility guide for Kotlin 2.1](https://kotlinlang.org/docs/compatibility-guide-21.html).

## <span id="2.0">2.0</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-57750][kt_57750]</span> | Core | Source  | **Kotlin 2.0** reports an error when resolving a class name that is present in several packages imported with a star import. |

Reference: [Compatibility guide for Kotlin 2.0](https://kotlinlang.org/docs/compatibility-guide-20.html).

## <span id="1.9">1.9</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|
| <span style="white-space: nowrap;">[KT-61111][kt_61111]</span> | Core | Source | **Kotlin 1.9** introduces language version 1.9 and removes support for language version 1.3. |

Reference: [Compatibility guide for Kotlin 1.9](https://kotlinlang.org/docs/compatibility-guide-19.html).

## <span id="1.8">1.8</span>

| Issue | Component | Incompatibility | Summary |
|:------|:----------|:----------------|:--------|

Reference: [Compatibility guide for Kotlin 1.8](https://kotlinlang.org/docs/compatibility-guide-18.html).

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

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2026* [**&#9650;**](#top)
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
[kt_57750]: https://youtrack.jetbrains.com/issue/KT-57750
[kt_61111]: https://youtrack.jetbrains.com/issue/KT-61111
[kt_60521]: https://youtrack.jetbrains.com/issue/KT-60521
[kt_71793]: https://youtrack.jetbrains.com/issue/KT-71793 "Drop support in -language-version for 1.6 and 1.7"
[ktlc-5]: https://youtrack.jetbrains.com/issue/KTLC-5 "Forbid reified type parameters in type aliases"
[ktlc-21]: https://youtrack.jetbrains.com/issue/KTLC-21 "Correct type checks on inline value classes for Number and Comparable"
