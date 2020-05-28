---
title: 'Obandit.MakeFixedExp3'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeDecayingExp3.html "Obandit.MakeDecayingExp3"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.MakeHorizonExp3.html "Obandit.MakeHorizonExp3"){.post}
:::

Functor [Obandit.MakeFixedExp3](type_Obandit.MakeFixedExp3.html)
================================================================

    module MakeFixedExp3: functor (P : FixedExp3Param) -> Bandit  with type bandit = banditPolicy

::: {.info .module .top}
::: {.info-desc}
The Exp3 Bandit for adversarial regret minimization with a decaying
learning rate as per `[1]`{.code}.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   | ----                              |
|                                   |    `P`   :  `FixedExp3Param`{.typ |
|                                   | e}                                |
|                                   |   ----- --- --------------------- |
|                                   | ----                              |
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
