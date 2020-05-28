---
title: 'Obandit.MakeDecayingEpsilonGreedy'
viewport: 'width=device-width, initial-scale=1'
---

`functor (P : DecayingEpsilonGreedyParam) ->   sig     type bandit = banditEstimates     val initialBandit : bandit     val step : bandit -> float -> int * bandit   end`{.code}
