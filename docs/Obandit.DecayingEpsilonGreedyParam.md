---
title: 'Obandit.DecayingEpsilonGreedyParam'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.RateBanditParam.html "Obandit.RateBanditParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.EpsilonGreedyParam.html "Obandit.EpsilonGreedyParam"){.post}
:::

Module type [Obandit.DecayingEpsilonGreedyParam](type_Obandit.DecayingEpsilonGreedyParam.html)
==============================================================================================

    module type DecayingEpsilonGreedyParam = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
Use to instanciate a `Bandit`{.code} from
`MakeDecayingEpsilonGreedy`{.code} .
:::
:::

------------------------------------------------------------------------

    val k : int

::: {.info}
::: {.info-desc}
The number of actions \$ K \$ .
:::
:::

    val c : float

::: {.info}
::: {.info-desc}
The \$ c\$ hyperparameter.
:::
:::

    val d : float

::: {.info}
::: {.info-desc}
The \$ d\$ hyperparameter, a tight lower bound on \$
\\max\_{i=1,\\cdots,K} \\Delta\_i \$.
:::
:::
