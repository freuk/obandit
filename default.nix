with import <nixpkgs> {};
{
  topkgEnv = stdenv.mkDerivation {
    name = "baseOcaml";
    buildInputs =
    [ bzip2
    (texlive.combine {
    inherit (texlive) cases scheme-small;
    })
  ];
    TOPKG_DELEGATE=''./ocaml_delegate.ml'';
    shellHook = '' export PS1="topkg-prompt> " '';
  };
}
