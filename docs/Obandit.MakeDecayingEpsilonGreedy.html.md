<div class="navbar">

[Previous](Obandit.MakeParametrizableEpsilonGreedy.html "Obandit.MakeParametrizableEpsilonGreedy")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.MakeEpsilonGreedy.html "Obandit.MakeEpsilonGreedy")

</div>

# Functor [Obandit.MakeDecayingEpsilonGreedy](type_Obandit.MakeDecayingEpsilonGreedy.html)

    module MakeDecayingEpsilonGreedy: functor (P : DecayingEpsilonGreedyParam) -> Bandit  with type bandit = banditEstimates

<div class="info module top">

<div class="info-desc">

The Epsilon-Greedy Bandit with the decaying exploration rate from `[5]`.

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
<td><code class="type">DecayingEpsilonGreedyParam</code></td>
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
