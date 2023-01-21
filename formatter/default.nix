{ self, system }:
let pkgs = self.inputs.nixpkgs.legacyPackages.${system};
in pkgs.nixfmt
