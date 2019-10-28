with import <nixpkgs> {};
let 
  symengine_shared = import ./nix/symengine-shared.nix;
in 
  stdenv.mkDerivation rec {
    name = "racket-symengine";
    env = buildEnv { name = name; paths = buildInputs; };
    LIB_SYMENGINE="${symengine_shared}/lib/libsymengine";
    buildInputs = [ symengine_shared ];
  }

