{
  description = "AUTOMATIC1111/stable-diffusion-webui flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      inherit (nixpkgs.lib.strings) hasInfix;
      linuxSystems =
        builtins.filter (hasInfix "linux") flake-utils.lib.defaultSystems;
    in flake-utils.lib.eachSystem linuxSystems (system: {
      checks = import ./checks { inherit self system; };
      devShells = import ./devShells { inherit self system; };
      formatter = import ./formatter { inherit self system; };
      packages = import ./packages { inherit self system; };
    });
}
