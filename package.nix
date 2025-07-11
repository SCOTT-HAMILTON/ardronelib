{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL
, gtk2
, libxml2
, udev
, wirelesstools
, ffmpeg
, nix-gitignore
}:

stdenv.mkDerivation rec {
  pname = "ardronelib";
  version = "13-08-2025";

  # src = fetchFromGitHub {
  #   owner = "p-ranav";
  #   repo = "argparse";
  #   rev = "v${version}";
  #   sha256 = "sha256-0fgMy7Q9BiQ/C1tmhuNpQgad8yzaLYxh5f6Ps38f2mk=";
  # };
  src = nix-gitignore.gitignoreSource [ ] ./.;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL gtk2 libxml2 udev wirelesstools ffmpeg ];

  makeFlags = [ "INSTALL_PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib

    # Copy headers
    find ARDroneLib -type f -name '*.h' | while read file; do
      dest="$out/include/$(dirname "$file")"
      mkdir -p "$dest"
      cp "$file" "$dest/"
    done

    # Copy libraries
    find "$out" -name "*.a" -exec mv {} "$out/lib" \;
  '';

  meta = with lib; {
    description = "Patched version of ARDroneLib 2.0.1 used in ardrone_autonomy project";
    license = licenses.mit;
    homepage = "https://github.com/SCOTT-HAMILTON/ardronelib";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}

