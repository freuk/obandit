---
title: 'Obandit.MakeDecayingExp3'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : KBanditParam) ->   sig     type bandit = banditPolicy     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
