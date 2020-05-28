---
title: 'Obandit.EpsilonGreedyParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.DecayingEpsilonGreedyParam.html "Obandit.DecayingEpsilonGreedyParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.FixedExp3Param.html "Obandit.FixedExp3Param"){.post}
:::

Module type [Obandit.EpsilonGreedyParam](type_Obandit.EpsilonGreedyParam.html)
==============================================================================

    module type EpsilonGreedyParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeEpsilonGreedy`{.code} .
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$ K \$ .
:::
:::

    val epsilon : float

::: {.info}
::: {.info-desc}
The \$ \\epsilon \$ parameter.
:::
:::
