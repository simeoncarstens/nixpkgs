{ buildPythonPackage
, lib
, fetchPypi
, psutil
, py-cpuinfo
, pydantic
, pyyaml
, qcelemental
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.21.0";

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZsPKvbaZ7BBZuOmzq12ism/HyWYcLlQHgZaTzmIsMq4=";
  };

  doCheck = true;

  meta = with lib; {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
