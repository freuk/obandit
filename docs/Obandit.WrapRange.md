---
title: 'Obandit.WrapRange'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.MakeHorizonExp3.html "Obandit.MakeHorizonExp3"){.pre}
 [Up](Obandit.html "Obandit"){.up}
 [Next](Obandit.WrapRange01.html "Obandit.WrapRange01"){.post}
:::

Functor [Obandit.WrapRange](type_Obandit.WrapRange.html)
========================================================

    module WrapRange: functor (R : RangeParam) -> functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

::: {.info .module .top}
::: {.info-desc}
The WrapRange functor wraps a bandit algorithm with the doubling trick.
This heuristic allows to use a bandit algorithm without knowing the
reward ranges. All rewards are linearly rescaled to a range (initially
given by a RangeParam). When a value is observed above the range, the
bandit algorithm is restarted and the range interval is doubled in that
direction.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- --------------------- |
|                                   |    `R`   :  `RangeParam`{.type}   |
|                                   |    `B`   :  `Bandit`{.type}       |
|                                   |   ----- --- --------------------- |
+-----------------------------------+-----------------------------------+

------------------------------------------------------------------------

    type bandit 

    val initialBandit : bandit Obandit.rangedBandit

    val step : bandit Obandit.rangedBandit ->
           float ->
           Obandit.rangedAction * bandit Obandit.rangedBandit
