---
title: 'Obandit.FixedExp3Param'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.EpsilonGreedyParam.html "Obandit.EpsilonGreedyParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.HorizonExp3Param.html "Obandit.HorizonExp3Param"){.post}
:::

Module type [Obandit.FixedExp3Param](type_Obandit.FixedExp3Param.html)
======================================================================

    module type FixedExp3Param = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeFixedExp3`{.code} .
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$ K \$ .
:::
:::

    val eta : float

::: {.info}
::: {.info-desc}
The fixed learning rate \$ \\eta \$.
:::
:::
