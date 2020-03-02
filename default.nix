{ frepkgs ? import <frepkgs> { } }:
let
  obandit =
    frepkgs.obanditPkgs.obandit.overrideAttrs (oldAttrs: rec { src = ./.; });
  validation = (frepkgs.obanditPkgs.validation.overrideAttrs
    (oldAttrs: rec { src = ./validation; })).override { inherit obandit; };
in {
  inherit obandit validation;
  inherit (frepkgs.obanditPkgs) web;
}
