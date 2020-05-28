---
title: 'Obandit.RangedBandit'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.RangeParam.html "Obandit.RangeParam"){.pre}
 [Up](Obandit.html "Obandit"){.up}  
:::

Module type [Obandit.RangedBandit](type_Obandit.RangedBandit.html)
==================================================================

    module type RangedBandit = sig .. end

::: {.info .modtype .top}
::: {.info-desc}
The type of a bandit with reward scaling.
:::
:::

------------------------------------------------------------------------

    type bandit 

    val initialBandit : bandit Obandit.rangedBandit

    val step : bandit Obandit.rangedBandit ->
           float ->
           Obandit.rangedAction * bandit Obandit.rangedBandit
