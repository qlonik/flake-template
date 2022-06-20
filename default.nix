{ system ? builtins.currentSystem
, inputs ? import ./flake.lock.nix { inherit system; }
, nixpkgs ? (import inputs.nixpkgs {
    inherit system;
    config = { };
    overlays = [ ];
  })
}:
let

  devshell = import inputs.devshell { inherit system inputs nixpkgs; };

in
{
  default = nixpkgs.hello;

  _internal.shell = devshell.mkShell {
    imports = [ (devshell.importTOML ./devshell.toml) ];
  };
}
