`sig   module type Bandit =     sig       type bandit
      val initialBandit : Obandit.Bandit.bandit       val step :
        Obandit.Bandit.bandit -> float -> int * Obandit.Bandit.bandit
    end   type banditEstimates = {     t : int;     a : int;
    nVisits : int list;     u : float list;   }
  module type AlphaPhiUCBParam =
    sig val k : int val alpha : float val invLFPhi : float -> float end
  module MakeAlphaPhiUCB :     functor (P : AlphaPhiUCBParam) ->
      sig         type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit
      end
  module type AlphaUCBParam = sig val k : int val alpha : float end
  module MakeAlphaUCB :     functor (P : AlphaUCBParam) ->       sig
        type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module type KBanditParam = sig val k : int end   module MakeUCB1 :
    functor (P : KBanditParam) ->       sig
        type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit
      end
  module type RateBanditParam = sig val k : int val rate : int -> float end
  module MakeParametrizableEpsilonGreedy :
    functor (P : RateBanditParam) ->       sig
        type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module type DecayingEpsilonGreedyParam =
    sig val k : int val c : float val d : float end
  module MakeDecayingEpsilonGreedy :
    functor (P : DecayingEpsilonGreedyParam) ->       sig
        type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module type EpsilonGreedyParam = sig val k : int val epsilon : float end
  module MakeEpsilonGreedy :     functor (P : EpsilonGreedyParam) ->
      sig         type bandit = banditEstimates
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit
      end
  type banditPolicy = { t : int; a : int; w : float list; }
  module MakeExp3 :     functor (P : RateBanditParam) ->       sig
        type bandit = banditPolicy
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module MakeDecayingExp3 :     functor (P : KBanditParam) ->       sig
        type bandit = banditPolicy         val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module type FixedExp3Param = sig val k : int val eta : float end
  module MakeFixedExp3 :     functor (P : FixedExp3Param) ->       sig
        type bandit = banditPolicy         val initialBandit : bandit
        val step : bandit -> float -> int * bandit       end
  module type HorizonExp3Param = sig val k : int val n : int end
  module MakeHorizonExp3 :     functor (P : HorizonExp3Param) ->
      sig         type bandit = banditPolicy
        val initialBandit : bandit
        val step : bandit -> float -> int * bandit
      end
  module type RangeParam = sig val upper : float val lower : float end
  type rangedAction = Reset of int | Action of int
  type 'b rangedBandit = { bandit : 'b; u : float; l : float; }
  module type RangedBandit =     sig       type bandit
      val initialBandit : Obandit.RangedBandit.bandit Obandit.rangedBandit
      val step :
        Obandit.RangedBandit.bandit Obandit.rangedBandit ->
        float ->         Obandit.rangedAction *
        Obandit.RangedBandit.bandit Obandit.rangedBandit     end
  module WrapRange :     functor (R : RangeParam) (B : Bandit) ->
      sig         type bandit = B.bandit
        val initialBandit : bandit rangedBandit
        val step :
          bandit rangedBandit -> float -> rangedAction * bandit rangedBandit
      end   module WrapRange01 :     functor (B : Bandit) ->       sig
        type bandit = B.bandit
        val initialBandit : bandit rangedBandit
        val step :
          bandit rangedBandit -> float -> rangedAction * bandit rangedBandit
      end end`
