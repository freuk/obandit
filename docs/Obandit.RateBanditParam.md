---
title: 'Obandit.RateBanditParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.KBanditParam.html "Obandit.KBanditParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.DecayingEpsilonGreedyParam.html "Obandit.DecayingEpsilonGreedyParam"){.post}
:::

Module type [Obandit.RateBanditParam](type_Obandit.RateBanditParam.html)
========================================================================

    module type RateBanditParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate algorithms that need a parametrizable rate.
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$K\$ .
:::
:::

    val rate : int -> float

::: {.info}
::: {.info-desc}
The rate. Can be fixed or decaying.
:::
:::
