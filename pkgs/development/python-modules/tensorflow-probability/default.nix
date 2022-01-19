{ lib
, fetchFromGitHub
, fetchpatch
, bazel
, buildBazelPackage
, buildPythonPackage
, python
, setuptools
, wheel
, absl-py
, tensorflow
, six
, numpy
, dm-tree
, keras
, decorator
, cloudpickle
, gast
, hypothesis
, scipy
, pandas
, mpmath
, matplotlib
, mock
, pytest
}:

let
  version = "0.15.0";
  pname = "tensorflow_probability";

  # first build all binaries and generate setup.py using bazel
  bazel-wheel = buildBazelPackage {
    bazel = bazel;

    name = "${pname}-${version}-py2.py3-none-any.whl";
    src = builtins.fetchurl {
      url = "https://github.com/tensorflow/probability/archive/refs/tags/v0.15.0.tar.gz";
      sha256 = "04csxmj9nq93nc1j6wakjmmmgqibxl7ahdywsmp7bkb947ynkzhc";
    };
    nativeBuildInputs = [
      # needed to create the output wheel in installPhase
      python
      setuptools
      wheel
      absl-py
      tensorflow
    ];

    bazelTarget = ":pip_pkg";

    fetchAttrs = {
      sha256 = "0sgxdlw5x3dydy53l10vbrj8smh78b7r1wff8jxcgp4w69mk8zfm";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';

      installPhase = ''
        # work around timestamp issues
        # https://github.com/NixOS/nixpkgs/issues/270#issuecomment-467583872
        export SOURCE_DATE_EPOCH=315532800

        # First build, then move. Otherwise pip_pkg would create the dir $out
        # and then put the wheel in that directory. However we want $out to
        # point directly to the wheel file.
        ./bazel-bin/pip_pkg . --release
        mv *.whl "$out"
      '';
    };
  };
in buildPythonPackage {
  inherit version pname;
  format = "wheel";

  src = bazel-wheel;

  propagatedBuildInputs = [
    tensorflow
    six
    numpy
    decorator
    cloudpickle
    gast
    dm-tree
    keras
  ];

  # Listed here:
  # https://github.com/tensorflow/probability/blob/f3777158691787d3658b5e80883fe1a933d48989/testing/dependency_install_lib.sh#L83
  checkInputs = [
    hypothesis
    pytest
    scipy
    pandas
    mpmath
    matplotlib
    mock
  ];

  # TODO:
  # Run unit tests with pytest, but in checkPhase, only the Bazel-build wheel is available
  # But it seems not guaranteed that running the tests with pytest will even work, see
  # https://github.com/tensorflow/probability/blob/c2a10877feb2c4c06a4dc58281e69c37a11315b9/CONTRIBUTING.md?plain=1#L69
  # Ideally, tests would be run using Bazel. For now, lets's do a...

  # sanity check
  checkPhase = ''
    python -c 'import tensorflow_probability'
  '';

  meta = with lib; {
    description = "Library for probabilistic reasoning and statistical analysis";
    homepage = "https://www.tensorflow.org/probability/";
    license = licenses.asl20;
    maintainers = with maintainers; [];  # This package is maintainerless.
  };
}
