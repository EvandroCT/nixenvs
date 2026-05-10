{
  pkgs,
  lib,
  ...
}:
let
  # Runtime libs the pre-built torch wheel expects. The NVIDIA driver's
  # libcuda.so is NOT in nixpkgs — it must come from the host system, exposed
  # below in enterShell via a private symlink dir (NOT via env.LD_LIBRARY_PATH,
  # which would leak host libc into Nix derivation builds and break the
  # sandbox on hosts with older glibc than the nixpkgs channel).
  buildInputs = with pkgs; [
    stdenv.cc.cc  # libstdc++, libgcc_s, libgomp
    libuv
    zlib
    expat
  ];
in
{
  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
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

    # Block /opt/conda's PROJ/GDAL data dirs from leaking into the venv:
    # rasterio bundles its own (newer) PROJ db, and the host conda one has
    # a stale schema (DATABASE.LAYOUT.VERSION.MINOR=3 vs required >=6).
    unset PROJ_DATA PROJ_LIB GDAL_DATA GDAL_DRIVER_PATH

    # Expose only NVIDIA-related libs (libcuda.so*, libnvidia-*.so*) from the
    # host into a private symlink dir, then append that dir to LD_LIBRARY_PATH.
    # Never add generic system lib dirs (e.g. /usr/lib/x86_64-linux-gnu) — they
    # contain the host's libc/libstdc++ which would shadow Nix's versions and
    # break Nix-built binaries on hosts with older glibc.
    NVDIR="$DEVENV_ROOT/.devenv/nvidia-libs"
    mkdir -p "$NVDIR"
    find "$NVDIR" -mindepth 1 -delete 2>/dev/null || true
    for d in /run/opengl-driver/lib /usr/lib/x86_64-linux-gnu /usr/lib64 /usr/lib/wsl/lib; do
      [ -d "$d" ] || continue
      for pat in 'libcuda.so*' 'libnvidia-*.so*' 'libcudadebugger.so*'; do
        for f in "$d"/$pat; do
          [ -e "$f" ] && ln -sf "$f" "$NVDIR/$(basename "$f")"
        done
      done
    done
    if [ -n "$(ls -A "$NVDIR" 2>/dev/null)" ]; then
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NVDIR"
    fi

    if command -v nvidia-smi >/dev/null 2>&1; then
      echo "[mission4] GPU(s) visible to this shell:"
      nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
    fi
  '';
}
