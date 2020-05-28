`functor (R : RangeParam) (B : Bandit) ->   sig
    type bandit = B.bandit
    val initialBandit : bandit rangedBandit     val step :
      bandit rangedBandit -> float -> rangedAction * bandit rangedBandit
  end`
