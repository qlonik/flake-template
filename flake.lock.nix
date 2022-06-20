# Using https://github.com/edolstra/flake-compat/blob/master/default.nix
# only return flake inputs. In this mode, flake becomes similar to niv.

{ system, src ? ./. }:
let

  lockFilePath = src + "/flake.lock";
  lockFile = builtins.fromJSON (builtins.readFile lockFilePath);

  flake-compat-meta = lockFile.nodes.flake-compat.locked;
  flake-compat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${flake-compat-meta.rev}.tar.gz";
    sha256 = flake-compat-meta.narHash;
  };

  flake = import flake-compat { inherit system src; };
  result = flake.defaultNix.inputs;

in
result
