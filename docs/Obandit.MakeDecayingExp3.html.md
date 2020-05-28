<div class="navbar">

[Previous](Obandit.MakeExp3.html "Obandit.MakeExp3")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.MakeFixedExp3.html "Obandit.MakeFixedExp3")

</div>

# Functor [Obandit.MakeDecayingExp3](type_Obandit.MakeDecayingExp3.html)

    module MakeDecayingExp3: functor (P : KBanditParam) -> Bandit  with type bandit = banditPolicy

<div class="info module top">

<div class="info-desc">

The Exp3 Bandit for adversarial regret minimization with a decaying
learning rate as per `[1]`.

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
<td style="text-align: center;"><code>P</code></td>
<td style="text-align: center;">:</td>
<td><code class="type">KBanditParam</code></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

-----

    type bandit 

<div class="info">

<div class="info-desc">

The internal data structure of the bandit algorithm.

</div>

</div>

    val initialBandit : bandit

<div class="info">

<div class="info-desc">

The initial state of the bandit algorithm.

</div>

</div>

    val step : bandit -> float -> int * bandit

<div class="info">

<div class="info-desc">

`step r` advances the bandit game one step, where `r` is the reward for
the last action. The result of this call is the next action, encoded as
an integer in $ \\{ 0, \\cdots , K-1 \\} $, and the new state of the
bandit. The reward range depends on the bandit algorithm in use and the
first reward provided to the algorithm is discarded.

</div>

</div>
