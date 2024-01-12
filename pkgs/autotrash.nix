{ python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "autotrash";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5h178yDqrtnkwx5xBoGmJEJ8MZGhI1FpmqjLOI/rO2A=";
  };

  format = "pyproject";

  propagatedBuildInputs = [ python3Packages.poetry-core ];

  doCheck = false;
}
