{
  description = "nixzx: a simple wrapper to get zx scripts running in nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
  in {
    overlays.default = final: prev: {
      writeZxApplication = import ./nixzx.nix final;
    };

    overlays.nixzx = self.overlays.default;

    checks.${system} = let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
      };
      checkExit0 = name:
        pkgs.runCommand "check-exit-0-${name}"
        {
          buildInputs = [(import ./examples/${name} pkgs)];
        }
        ''
          ${name}

          touch $out
        '';
    in {
      # simple = checkExit0 "simple";
      multifile = checkExit0 "multifile";
    };

    devShells = let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
      };
    in {
      ${system}.default = pkgs.mkShell {
        inputsFrom = [];

        packages = [
          pkgs.nodejs_24
        ];
      };
    };
  };
}
