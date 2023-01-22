{ self, system, stdenv, lib, gnugrep, poetry, dos2unix, gnused, coreutils
, findutils }:

let
  pname = "dependencies";
  version = "0.0.1";

  meta = with lib; {
    description =
      "Dependency Conversion of AUTOMATIC1111-stable-diffusion-webui";
    homepage = "https://github.com/AUTOMATIC1111/stable-diffusion-webui";
    license = licenses.agpl3Only;
  };

  src = self.packages.${system}.source;

in stdenv.mkDerivation {
  inherit pname version src meta;

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/dependencies
    pushd $out/dependencies

    DEPS=$(cat ${src}/source/requirements.txt | \
      ${dos2unix}/bin/dos2unix | \
      ${coreutils}/bin/tr '\n' ' ' | \
      ${findutils}/bin/xargs | \
      ${gnused}/bin/sed "s/ / --dependency /g" | \
      ${gnused}/bin/sed -e 's/^/--dependency /')

    ${poetry}/bin/poetry init --no-interaction --name stable-diffusion-webui --author AUTOMATIC1111 --python 3.10.9 $DEPS > pyproject.toml

    popd
  '';
}
