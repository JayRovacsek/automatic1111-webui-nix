{ self, pkgs, system }: {
  src = self;
  hooks = {
    nixfmt.enable = true;
    statix.enable = false;
    statix-write = {
      enable = true;
      name = "Statix Write";
      entry = "${pkgs.statix}/bin/statix fix";
      language = "system";
      pass_filenames = false;
    };
  };
}
