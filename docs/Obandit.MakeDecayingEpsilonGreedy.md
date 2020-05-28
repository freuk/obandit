---
title: 'Obandit.MakeDecayingEpsilonGreedy'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeParametrizableEpsilonGreedy.html "Obandit.MakeParametrizableEpsilonGreedy"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeEpsilonGreedy.html "Obandit.MakeEpsilonGreedy"){.post}
:::

Functor [Obandit.MakeDecayingEpsilonGreedy](type_Obandit.MakeDecayingEpsilonGreedy.html)
========================================================================================

    module MakeDecayingEpsilonGreedy: functor (P : DecayingEpsilonGreedyParam) -> Bandit  with type bandit = banditEstimates

::: {.info .module .top}
::: {.info-desc}
The Epsilon-Greedy Bandit with the decaying exploration rate from
`[5]`{.code}.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | ----------------                  |
|                                   |    `P`   :  `DecayingEpsilonGreed |
|                                   | yParam`{.type}                    |
|                                   |   ----- --- --------------------- |
|                                   | ----------------                  |
+-----------------------------------+-----------------------------------+

------------------------------------------------------------------------

    type bandit 

::: {.info}
::: {.info-desc}
The internal data structure of the bandit algorithm.
:::
:::

    val initialBandit : bandit

::: {.info}
::: {.info-desc}
The initial state of the bandit algorithm.
:::
:::

    val step : bandit -> float -> int * bandit

::: {.info}
::: {.info-desc}
`step r`{.code} advances the bandit game one step, where `r`{.code} is
the reward for the last action. The result of this call is the next
action, encoded as an integer in \$ \\{ 0, \\cdots , K-1 \\} \$, and the
new state of the bandit. The reward range depends on the bandit
algorithm in use and the first reward provided to the algorithm is
discarded.
:::
:::
