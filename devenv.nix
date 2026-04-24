{
  pkgs,
  lib,
  ...
}:
let
  # Runtime libs the pre-built torch wheel expects. The NVIDIA driver's
  # libcuda.so is NOT in nixpkgs — it must come from the host system, added
  # below via driverPaths.
  buildInputs = with pkgs; [
    stdenv.cc.cc  # libstdc++, libgcc_s, libgomp
    libuv
    zlib
    expat
  ];

  # Standard host locations for the NVIDIA driver's libcuda.so / libnvidia-*.
  # Harmless if absent on a given host — the loader just keeps searching.
  driverPaths = [
    "/run/opengl-driver/lib"     # NixOS
    "/usr/lib/x86_64-linux-gnu"  # Debian / Ubuntu
    "/usr/lib64"                 # RHEL / Fedora
    "/usr/lib/wsl/lib"           # WSL2
  ];
in
{
  env = {
    LD_LIBRARY_PATH = lib.concatStringsSep ":" (
      [ (lib.makeLibraryPath buildInputs) ] ++ driverPaths
    );
  };

  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  enterShell = ''
    . .devenv/state/venv/bin/activate
    if command -v nvidia-smi >/dev/null 2>&1; then
      echo "[mission4] GPU(s) visible to this shell:"
      nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
    fi
  '';
}
