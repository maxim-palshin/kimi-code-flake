{
  description = "Kimi Code (CLI + Desktop) — Moonshot AI's AI coding agent, packaged for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          kimi-code = pkgs.callPackage ./pkgs/kimi-code.nix { };
          default = self.packages.${system}.kimi-code;
        }
        // lib.optionalAttrs (system == "x86_64-linux") {
          kimi-code-desktop = pkgs.callPackage ./pkgs/kimi-code-desktop.nix { };
        }
      );

      overlays.default = final: _: {
        kimi-code = final.callPackage ./pkgs/kimi-code.nix { };
        kimi-code-desktop = final.callPackage ./pkgs/kimi-code-desktop.nix { };
      };
    };
}
