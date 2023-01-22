{
  description = "AUTOMATIC1111/stable-diffusion-webui flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

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
      inherit (nixpkgs.lib) recursiveUpdate;
      systems =
        builtins.filter (hasInfix "linux") flake-utils.lib.defaultSystems;

    in flake-utils.lib.eachSystem systems (system: {
      checks = import ./checks { inherit self system; };
      devShells = import ./devShells { inherit self system; };
      formatter = import ./formatter { inherit self system; };
      packages = import ./packages { inherit self system; };

      # TODO: figure and clean this up
      webui-dream = self.inputs.dream2nix.lib.makeFlakeOutputs {
        inherit systems;
        config.projectRoot = ./.;
        source = self.outputs.packages.${system}.webui.outPath;
        projects = {
          main = {
            name = "main";
            relPath = "source";
            subsystem = "python";
            translator = "poetry";
            translators = [ "poetry" ];
          };
        };
      };
    });
}
