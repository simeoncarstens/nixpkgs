{ fetchgit, gnumake, lib, buildPythonPackage, bridgestan, numpy, setuptools }:
buildPythonPackage rec {
  pname = "bridgestan";
  version = "1.0.0";
  src = fetchgit {
    url = "https://github.com/roualdes/bridgestan.git";
    rev = "v1.0.0";
    sha256 = "pAn0bs+u5aS61kZy6LAsUzB6OUz1WOKt7f4EVV3FIHY=";
    sparseCheckout = [ "python" ];
  };
  sourceRoot = "${src}/python";
  format = "pyproject";
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ bridgestan numpy ];
  shellHook = ''
    export BRIDGESTAN=${bridgestan}
  '';
}
