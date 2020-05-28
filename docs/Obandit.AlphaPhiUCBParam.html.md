<div class="navbar">

[Previous](Obandit.Bandit.html "Obandit.Bandit")
 [Up](Obandit.html "Obandit")
 [Next](Obandit.AlphaUCBParam.html "Obandit.AlphaUCBParam")

</div>

# Module type [Obandit.AlphaPhiUCBParam](type_Obandit.AlphaPhiUCBParam.html)

    module type AlphaPhiUCBParam = sig .. end

<div class="info modtype top">

<div class="info-desc">

Use to instanciate a `Bandit` from `MakeAlphaPhiUCB` by giving $\\alpha$
and $\\phi$.

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

    val invLFPhi : float -> float

<div class="info">

<div class="info-desc">

The inverse of the Legendre-Fenchel transform of $ \\psi $.

</div>

</div>
