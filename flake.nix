{
  description = "source for aurora physics open TTRPG";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        # TODO:make package
        packages.default = pkgs.hello;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; let mytex = texlive.combine {inherit (texlive) scheme-small hyperref import;} ;
          in
          [mytex texlab];
          shellHook = ''
            export PS1='\[\e[34m\]dev >\[\e[37m\] '
          '';
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
