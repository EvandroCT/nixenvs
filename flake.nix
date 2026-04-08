{
  description = "Mission 1 environment using pure Nix Flakes and uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils"; # Utilitário para facilitar o suporte a múltiplas arquiteturas
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # system library dependencies (prior to uv)
        buildInputs = with pkgs; [
          stdenv.cc.cc
          libuv
          zlib
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          # system-level packages
          packages = with pkgs; [
            uv
          ] ++ buildInputs;

          # shell variables
          env = {
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
          };

          shellHook = ''
            # creates venv and sync packages using pyproject.toml
            uv sync
            source .venv/bin/activate
            echo "Ambiente Nix carregado. Venv ativada!"
          '';
        };
      }
    );
}
