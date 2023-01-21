{ stdenv, lib, fetchFromGitHub }:

let
  pname = "AUTOMATIC1111-stable-diffusion-webui";
  version = "0.0.1";

  meta = with lib; {
    description = "AUTOMATIC1111-stable-diffusion-webui Github Repository";
    homepage = "https://github.com/AUTOMATIC1111/stable-diffusion-webui";
    license = licenses.agpl3Only;
  };

  src = fetchFromGitHub {
    owner = "AUTOMATIC1111";
    repo = "stable-diffusion-webui";
    rev = "855b9e3d1c5a1bd8c2d815d38a38bc7c410be5a8";
    sha256 = "sha256-pdV/8KMR7DDPpzMqABP8jYxl1jNJ839I6uZGca0hDvU=";
  };
in stdenv.mkDerivation {
  inherit pname version src meta;

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out
    ln -s ${src} $out
  '';
}
