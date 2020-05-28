---
title: 'Obandit.MakeUCB1'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeAlphaUCB.html "Obandit.MakeAlphaUCB"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeParametrizableEpsilonGreedy.html "Obandit.MakeParametrizableEpsilonGreedy"){.post}
:::

Functor [Obandit.MakeUCB1](type_Obandit.MakeUCB1.html)
======================================================

    module MakeUCB1: functor (P : KBanditParam) -> Bandit  with type bandit = banditEstimates

::: {.info .module .top}
::: {.info-desc}
The UCB1 Bandit for stochastic regret minimization .
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | --                                |
|                                   |    `P`   :  `KBanditParam`{.type} |
|                                   |   ----- --- --------------------- |
|                                   | --                                |
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
