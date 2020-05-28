<div class="navbar">

[Previous](Obandit.RangeParam.html "Obandit.RangeParam")
 [Up](Obandit.html "Obandit")  

</div>

# Module type [Obandit.RangedBandit](type_Obandit.RangedBandit.html)

    module type RangedBandit = sig .. end

<div class="info modtype top">

<div class="info-desc">

The type of a bandit with reward scaling.

</div>

</div>

-----

    type bandit 

    val initialBandit : bandit Obandit.rangedBandit

    val step : bandit Obandit.rangedBandit ->
           float ->
           Obandit.rangedAction * bandit Obandit.rangedBandit
