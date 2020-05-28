<div class="navbar">

[Previous](Obandit.AlphaPhiUCBParam.html "Obandit.AlphaPhiUCBParam")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.KBanditParam.html "Obandit.KBanditParam")

</div>

# Module type [Obandit.AlphaUCBParam](type_Obandit.AlphaUCBParam.html)

    module type AlphaUCBParam = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeAlphaUCB` by giving $\\alpha$.

</div>

</div>

-----

    val k : int

<div class="info">

<div class="info-desc">

The number of actions $ K $ .

</div>

</div>

    val alpha : float

<div class="info">

<div class="info-desc">

The $ \\alpha $ parameter.

</div>

</div>
