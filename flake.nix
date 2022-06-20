{
  description = "A basic flake with a shell";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;

    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };

    devshell = {
      url = github:numtide/devshell;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let

          this-package = import self {
            inherit system;
            nixpkgs = nixpkgs.legacyPackages.${system};
          };

        in
        {
          packages.default = this-package.default;
          app.default = this-package.default;
          devShells.default = this-package._internal.shell;
          legacyPackages = this-package;
        }
      )
    // {
      overlays.default = import ./overlay.nix;
      templates.default = {
        description = "Default template";
        path = ./template;
      };
    };
}
