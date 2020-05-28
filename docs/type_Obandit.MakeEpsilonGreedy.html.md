`functor (P : EpsilonGreedyParam) ->   sig
    type bandit = banditEstimates     val initialBandit : bandit
    val step : bandit -> float -> int * bandit   end`
