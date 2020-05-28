---
title: 'Obandit.MakeEpsilonGreedy'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : EpsilonGreedyParam) ->   sig     type bandit = banditEstimates     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
