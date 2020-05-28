`sig   type bandit
  val initialBandit : Obandit.RangedBandit.bandit Obandit.rangedBandit
  val step :     Obandit.RangedBandit.bandit Obandit.rangedBandit ->
    float ->
    Obandit.rangedAction * Obandit.RangedBandit.bandit Obandit.rangedBandit
end`
