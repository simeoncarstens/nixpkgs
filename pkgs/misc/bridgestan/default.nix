{ fetchFromGitHub, fetchgit, fetchurl, lib, stdenv, stanc, gnumake }:
stdenv.mkDerivation {
  pname = "bridgestan";
  version = "1.0.0";
  # src = fetchFromGitHub {
  #   owner = "roualdes";
  #   repo = "bridgestan";
  #   rev = "v1.0.0";
  #   sha256 = "19yh58qyds751yzgrkqk66wd63bg11xnf2zacrqz0xr0nr507y7k";
  #   fetchSubmodules = true;
  # };
  src = fetchgit {
    url = "https://github.com/roualdes/bridgestan.git";
    rev = "v1.0.0";
    sha256 = "pAn0bs+u5aS61kZy6LAsUzB6OUz1WOKt7f4EVV3FIHY=";
    fetchSubmodules = true;
  };
  patchPhase = ''
    substituteInPlace Makefile --replace 'STANC ?= $(BS_ROOT)/bin/stanc$(EXE)' 'STANC ?= ${stanc}/bin/stanc'   
    head -n -10 Makefile > Makefile.tmp && mv Makefile.tmp Makefile
    '';
  installPhase = ''
    mkdir $out
    cp -r $src/* $out/
    ls -alh $out/
    cat <<EOT >> $out/bin/bridgestan_make
    #!/usr/bin/env bash
    ${gnumake}/bin/make $@
    EOT 
  '';
}
