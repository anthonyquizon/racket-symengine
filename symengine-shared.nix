with import <nixpkgs> {};
# https://github.com/NixOS/nixpkgs/blob/91d5b3f07d27622ff620ff31fa5edce15a5822fa/pkgs/development/libraries/symengine/default.nix#L40

stdenv.mkDerivation rec {
  name = "symengine_shared";
  env = buildEnv { name = name; paths = buildInputs; };
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine";
    rev = "v${version}";
    sha256 = "1zgfhqv43qcfkfdyf1p82bcfv05n6iix6yw6qx1y5bnb7dv74irw";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp flint mpfr libmpc ];

  cmakeFlags = [
    "-DWITH_FLINT=ON"
    "-DINTEGER_CLASS=flint"
    "-DWITH_SYMENGINE_THREAD_SAFE=yes"
    "-DWITH_MPC=yes"
    "-DBUILD_SHARED_LIBS:BOOL=ON"
  ];
}
