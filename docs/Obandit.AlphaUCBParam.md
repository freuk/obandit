---
title: 'Obandit.AlphaUCBParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.AlphaPhiUCBParam.html "Obandit.AlphaPhiUCBParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.KBanditParam.html "Obandit.KBanditParam"){.post}
:::

Module type [Obandit.AlphaUCBParam](type_Obandit.AlphaUCBParam.html)
====================================================================

    module type AlphaUCBParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeAlphaUCB`{.code} by
giving \$\\alpha\$.
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$ K \$ .
:::
:::

    val alpha : float

::: {.info}
::: {.info-desc}
The \$ \\alpha \$ parameter.
:::
:::
