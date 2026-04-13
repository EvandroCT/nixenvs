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
  ];

  enterShell = ''
    echo "GDAL version: $(gdal --version)"
  '';
}
