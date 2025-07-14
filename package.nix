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
# , nix-gitignore
}:

stdenv.mkDerivation rec {
  pname = "ardronelib";
  version = "13-08-2025";

  src = fetchFromGitHub {
    owner = "SCOTT-HAMILTON";
    repo = pname;
    rev = "fecc30fe45a274158f6babbc69a5246930d735cb";
    sha256 = "sha256-9yqp2WcYXb0hBU64i0hb97Kzms4fbNjZ6o8WAl0saS8=";
  };
  # src = nix-gitignore.gitignoreSource [ ] ./.;

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
    homepage = "https://github.com/SCOTT-HAMILTON/ardronelib";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}

