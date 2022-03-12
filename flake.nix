{

  inputs = {
    naersk.url = "github:nmattia/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
  utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    naersk-lib = pkgs.callPackage naersk {};
  in rec {

    packages.swaycons = naersk-lib.buildPackage {
      pname = "swaycons";
      root = ./.;
    };

    defaultPackage = packages.swaycons;

    defaultApp = utils.lib.mkApp {
      drv = self.defaultPackage."${system}";
    };

    devShell = with pkgs; mkShell {
      buildInputs = [ cargo rustc rustfmt pre-commit rustPackages.clippy ];
      RUST_SRC_PATH = rustPlatform.rustLibSrc;
    };

  });
}

