{
  pkgs,
  lib,
  ...
}:
let
  buildInputs = with pkgs; [
    stdenv.cc.cc
    libuv
    zlib
    expat
  ];
in
{
  env = {
    LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
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
    # The host shell inherits PROJ_DATA / GDAL_DATA / GDAL_DRIVER_PATH pointing
    # at /opt/conda — a stale PROJ 9.4 data dir (db v1.3) that rasterio's libproj
    # 9.7.1 rejects with "DATABASE.LAYOUT.VERSION.MINOR ... expected ≥ 6" warnings.
    # Unset them so each library (rasterio, pyproj) falls back to its own bundled
    # data dir compiled into the wheel — different PROJ versions, but each is
    # internally consistent. Don't try to share a single PROJ_DATA across both;
    # their bundled DBs are at different schema versions.
    unset PROJ_DATA PROJ_LIB GDAL_DATA GDAL_DRIVER_PATH
  '';
}
