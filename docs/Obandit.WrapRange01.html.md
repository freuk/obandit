<div class="navbar">

[Previous](Obandit.WrapRange.html "Obandit.WrapRange")
 [Up](Obandit.html "Obandit")  

</div>

# Functor [Obandit.WrapRange01](type_Obandit.WrapRange01.html)

    module WrapRange01: functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

<div class="info module top">

<div class="info-desc">

The WrapRange01 functor is a convenience aliasing of WrapRange with an
initial "standard" range of $ \\left\[ 0,1 \\right\] $.

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
