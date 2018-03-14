{
stdenv,
writeText,
writeScriptBin,
rstudioWrapper,
pandoc,
texlive,
zymake,
R,
rPackages,
obandit,
...}:
let
  rPackList= with rPackages; [
    docopt
    knitr
    cowplot
    lubridate
    dplyr
    tidyr
    ggplot2
    xtable
    ggthemes
    data_table
  ];
  myrstudio = rstudioWrapper.override { packages = rPackList; };
  rstudo = writeScriptBin "rstudo" ''
    #"${stdenv.shell}
    export DO_RSTU=$1
    export R_SCRIPT=$2
    export R_ARGS=''${@:3}

    if [ "''${DO_RSTU}" == "1" ]; then
      if [ -n "$IN_NIX_SHELL" ]; then
        echo "Would you like to start rtudio instead of $R_SCRIPT [yes/no]:"
        read rstu
        if  [ $rstu == "yes" ]; then
          ${myrstudio}/bin/rstudio
        else
          $R_SCRIPT
        fi
      else
        $R_SCRIPT
      fi
    else
      $R_SCRIPT
    fi
  '' ;

in stdenv.mkDerivation {
  name="nrm-analysis-environment";
  src = ./.;
  buildInputs = [
    texlive.combined.scheme-small
    zymake
    rstudo
    R
    obandit
    myrstudio
    pandoc
  ]++rPackList;

  installPhase =''
    mkdir -p $out/md
    mkdir -p $out/html
    cp o/zymakefile/*.md $out/md
    cp o/zymakefile/*.html $out/html
    cp -r figure $out
    tar -cvzf source.tgz ${./.}/*
    cp source.tgz $out/
  '';

  obanditversion=obandit.version;
}

