---
title: 'Obandit.MakeAlphaUCB'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : AlphaUCBParam) ->   sig     type bandit = banditEstimates     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
