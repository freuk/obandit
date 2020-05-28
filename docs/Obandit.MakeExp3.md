---
title: 'Obandit.MakeExp3'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeEpsilonGreedy.html "Obandit.MakeEpsilonGreedy"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeDecayingExp3.html "Obandit.MakeDecayingExp3"){.post}
:::

Functor [Obandit.MakeExp3](type_Obandit.MakeExp3.html)
======================================================

    module MakeExp3: functor (P : RateBanditParam) -> Bandit  with type bandit = banditPolicy

::: {.info .module .top}
::: {.info-desc}
The Exp3 Bandit for adversarial regret minimization with a
parametrizable learning rate.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | -----                             |
|                                   |    `P`   :  `RateBanditParam`{.ty |
|                                   | pe}                               |
|                                   |   ----- --- --------------------- |
|                                   | -----                             |
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
