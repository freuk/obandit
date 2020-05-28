---
title: 'Obandit.MakeAlphaPhiUCB'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeAlphaUCB.html "Obandit.MakeAlphaUCB"){.post}
:::

Functor [Obandit.MakeAlphaPhiUCB](type_Obandit.MakeAlphaPhiUCB.html)
====================================================================

    module MakeAlphaPhiUCB: functor (P : AlphaPhiUCBParam) -> Bandit  with type bandit = banditEstimates

::: {.info .module .top}
::: {.info-desc}
The \$(\\alpha,\\psi)\$-UCB Bandit for stochastic regret minimization
described in `[1]`{.code}.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | ------                            |
|                                   |    `P`   :  `AlphaPhiUCBParam`{.t |
|                                   | ype}                              |
|                                   |   ----- --- --------------------- |
|                                   | ------                            |
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
