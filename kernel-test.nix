let
  pkgs = import <nixpkgs> {};
  version = "6.6.40";
in
pkgs.fetchurl {
  url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
  sha256 = pkgs.lib.fakeSha256;
}
