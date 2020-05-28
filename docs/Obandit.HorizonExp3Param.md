---
title: 'Obandit.HorizonExp3Param'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.FixedExp3Param.html "Obandit.FixedExp3Param"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.RangeParam.html "Obandit.RangeParam"){.post}
:::

Module type [Obandit.HorizonExp3Param](type_Obandit.HorizonExp3Param.html)
==========================================================================

    module type HorizonExp3Param = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeHorizonExp3`{.code} .
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$K\$ .
:::
:::

    val n : int

::: {.info}
::: {.info-desc}
The \$ n \$ parameter, the horizon to optimize for.
:::
:::
