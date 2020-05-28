---
title: 'Obandit.KBanditParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.AlphaUCBParam.html "Obandit.AlphaUCBParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.RateBanditParam.html "Obandit.RateBanditParam"){.post}
:::

Module type [Obandit.KBanditParam](type_Obandit.KBanditParam.html)
==================================================================

    module type KBanditParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeUCB1`{.code}.
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$ K \$ .
:::
:::
