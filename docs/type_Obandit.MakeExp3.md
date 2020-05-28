---
title: 'Obandit.MakeExp3'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : RateBanditParam) ->   sig     type bandit = banditPolicy     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
