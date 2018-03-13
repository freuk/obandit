{
stdenv,
R,
rPackages,
obandit,
...}:
let
  rPackList= with rPackages; [
    knitr
  ];
in stdenv.mkDerivation {
  name="nrm-analysis-environment";
  src = ./.;
  buildInputs = [
    R
    obandit
  ]++rPackList;

  installPhase =''
    mkdir -p $out
    cp web.md $out
    #cp -r figure $out
  '';

  obanditversion=obandit.version;
}

