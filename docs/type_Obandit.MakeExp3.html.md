`functor (P : RateBanditParam) ->   sig     type bandit = banditPolicy
    val initialBandit : bandit
    val step : bandit -> float -> int * bandit   end`
