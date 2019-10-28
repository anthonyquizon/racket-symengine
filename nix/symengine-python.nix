with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "python-symengine";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [ 
    python37 
    python37Packages.symengine 
    python37Packages.sympy
  ];
}

