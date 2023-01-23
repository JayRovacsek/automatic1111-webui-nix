{ self, system }:
let
  name = "stable-diffusion-webui";

  pkgs = import self.inputs.nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };

  xorg-requirements = with pkgs.xorg; [
    libXi
    libXmu
    libXext
    libX11
    libXv
    libXrandr
  ];

  buildInputs = with pkgs;
    [
      git # The program instantly crashes if git is not present, even if everything is already downloaded
      python310
      stdenv.cc.cc.lib
      stdenv.cc
      ncurses5
      binutils
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      util-linux
      m4
      gperf
      unzip
      cudatoolkit
      linuxPackages.nvidia_x11
      libGLU
      libGL
      freeglut
      zlib
      glib
    ] ++ xorg-requirements;
  shellHook = ''
    ${self.checks.${system}.pre-commit.shellHook}
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}"
    export CUDA_PATH=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS="-L${pkgs.linuxPackages.nvidia_x11}/lib"
  '';
in {
  "${name}" = pkgs.mkShell { inherit name shellHook buildInputs; };
  default = self.outputs.devShells.${system}.${name};
}
