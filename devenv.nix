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
  ];
in
{
  env = {
    LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  };

  packages = with pkgs; [
    gdal
    python3Packages.gdal
  ];

  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  enterShell = ''
    . .devenv/state/venv/bin/activate

    # Block /opt/conda's PROJ/GDAL data dirs from leaking in: the host conda
    # proj.db has DATABASE.LAYOUT.VERSION.MINOR = 3 but GDAL/PROJ here expect
    # >= 6, which kills every EPSG:4326 lookup during clipping.
    unset PROJ_DATA PROJ_LIB GDAL_DATA GDAL_DRIVER_PATH
  '';
}
