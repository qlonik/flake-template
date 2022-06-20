final: prev:
{
  flake-template = import ./. { nixpkgs = final; };
}
