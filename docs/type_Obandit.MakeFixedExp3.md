---
title: 'Obandit.MakeFixedExp3'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : FixedExp3Param) ->   sig     type bandit = banditPolicy     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
