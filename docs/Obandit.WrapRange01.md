---
title: 'Obandit.WrapRange01'
viewport: 'width=device-width, initial-scale=1'
---

::: {.navbar}
[Previous](Obandit.WrapRange.html "Obandit.WrapRange"){.pre}
 [Up](Obandit.html "Obandit"){.up}  
:::

Functor [Obandit.WrapRange01](type_Obandit.WrapRange01.html)
============================================================

    module WrapRange01: functor (B : Bandit) -> RangedBandit  with type bandit = B.bandit

::: {.info .module .top}
::: {.info-desc}
The WrapRange01 functor is a convenience aliasing of WrapRange with an
initial \"standard\" range of \$ \\left\[ 0,1 \\right\] \$.
:::
:::

+:----------------------------------+-----------------------------------+
| **Parameters:**                   |   ----- --- -----------------     |
|                                   |    `B`   :  `Bandit`{.type}       |
|                                   |   ----- --- -----------------     |
+-----------------------------------+-----------------------------------+

------------------------------------------------------------------------

    type bandit 

    val initialBandit : bandit Obandit.rangedBandit

    val step : bandit Obandit.rangedBandit ->
           float ->
           Obandit.rangedAction * bandit Obandit.rangedBandit
