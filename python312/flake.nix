	{
	  inputs = {
      # Moderately annoying that we have to do this as Python 3.12 is broken on main
      nixpkgs.url = "github:NixOS/nixpkgs";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlay = (self: super: {
            python = super.python312;
            poetry = super.poetry;
            pip = super.python3Packages.pip;
            cookiecutter = super.python3Packages.cookiecutter;
          });
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              python312
              poetry
              pyenv

              # python312Packages.pip is horribly broken so we have to do this.
              # Gross.
              python3Packages.pip
              python3Packages.cookiecutter
            ];
          };
        }
      );
}