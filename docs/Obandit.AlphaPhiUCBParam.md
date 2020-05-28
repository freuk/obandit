---
title: 'Obandit.AlphaPhiUCBParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.Bandit.html "Obandit.Bandit"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.AlphaUCBParam.html "Obandit.AlphaUCBParam"){.post}
:::

Module type [Obandit.AlphaPhiUCBParam](type_Obandit.AlphaPhiUCBParam.html)
==========================================================================

    module type AlphaPhiUCBParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from `MakeAlphaPhiUCB`{.code} by
giving \$\\alpha\$ and \$\\phi\$.
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

    val invLFPhi : float -> float

::: {.info}
::: {.info-desc}
The inverse of the Legendre-Fenchel transform of \$ \\psi \$.
:::
:::
