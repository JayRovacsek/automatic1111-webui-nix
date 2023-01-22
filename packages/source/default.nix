{ stdenv, lib, fetchFromGitHub }:

let
  pname = "source";
  version = "0.0.1";

  meta = with lib; {
    description = "AUTOMATIC1111-stable-diffusion-webui";
    homepage = "https://github.com/AUTOMATIC1111/stable-diffusion-webui";
    license = licenses.agpl3Only;
  };

  src = fetchFromGitHub {
    owner = "AUTOMATIC1111";
    repo = "stable-diffusion-webui";
    rev = "855b9e3d1c5a1bd8c2d815d38a38bc7c410be5a8";
    sha256 = "sha256-pdV/8KMR7DDPpzMqABP8jYxl1jNJ839I6uZGca0hDvU=";
  };

  sourceRemoval = lib.lists.last (lib.strings.splitString "/" src.outPath);

in stdenv.mkDerivation {
  inherit pname version src meta;

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/source
    find ${src} -maxdepth 1 -exec ln -s {} $out/source \;
    rm $out/source/${sourceRemoval}
    pushd $out/source

    popd
  '';
}
