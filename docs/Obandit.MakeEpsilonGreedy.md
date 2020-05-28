---
title: 'Obandit.MakeEpsilonGreedy'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeDecayingEpsilonGreedy.html "Obandit.MakeDecayingEpsilonGreedy"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeExp3.html "Obandit.MakeExp3"){.post}
:::

Functor [Obandit.MakeEpsilonGreedy](type_Obandit.MakeEpsilonGreedy.html)
========================================================================

    module MakeEpsilonGreedy: functor (P : EpsilonGreedyParam) -> Bandit  with type bandit = banditEstimates

::: {.info .module .top}
::: {.info-desc}
The Epsilon-Greedy Bandit with a fixed exploration rate.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | --------                          |
|                                   |    `P`   :  `EpsilonGreedyParam`{ |
|                                   | .type}                            |
|                                   |   ----- --- --------------------- |
|                                   | --------                          |
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
