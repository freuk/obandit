<div class="navbar">

[Previous](Obandit.MakeHorizonExp3.html "Obandit.MakeHorizonExp3")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.WrapRange01.html "Obandit.WrapRange01")

</div>

# Functor [Obandit.WrapRange](type_Obandit.WrapRange.html)

    module WrapRange: functor (R : RangeParam) -> functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

<div class="info module top">

<div class="info-desc">

The WrapRange functor wraps a bandit algorithm with the doubling trick.
This heuristic allows to use a bandit algorithm without knowing the
reward ranges. All rewards are linearly rescaled to a range (initially
given by a RangeParam). When a value is observed above the range, the
bandit algorithm is restarted and the range interval is doubled in that
direction.

</div>

</div>

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: left;"><strong>Parameters:</strong></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><code>R</code></td>
<td style="text-align: center;">:</td>
<td><code class="type">RangeParam</code></td>
</tr>
<tr class="even">
<td style="text-align: center;"><code>B</code></td>
<td style="text-align: center;">:</td>
<td><code class="type">Bandit</code></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

-----

    type bandit 

    val initialBandit : bandit Obandit.rangedBandit

    val step : bandit Obandit.rangedBandit ->
           float ->
           Obandit.rangedAction * bandit Obandit.rangedBandit
