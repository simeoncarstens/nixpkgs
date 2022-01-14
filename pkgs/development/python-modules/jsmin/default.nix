{ lib, buildPythonPackage, fetchPypi, fetchpatch }:

buildPythonPackage rec {
  pname = "jsmin";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88fc1bd6033a47c5911dbcada7d279c7a8b7ad0841909590f6a742c20c4d2e08";
  };

  patches = [
    # fix tests, committed to master, but no release yet
    (fetchpatch {
      url = "https://github.com/tikitu/jsmin/commit/ec5e3da27634a150faf5c0456bc84ec9c428120d.patch";
      sha256 = "sha256-TjAbxZ+zqwp2D8JremqIW6/f9NcXK1lqVoIG1hvmzco=";
    })
  ];

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = "https://github.com/tikitu/jsmin/";
    license = licenses.mit;
  };
}
