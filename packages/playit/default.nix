{
  lib,
  stdenv,
  inputs,
}:
stdenv.mkDerivation {
  pname = "playit";
  version = "0.17.1";
  src = inputs.playit;
  meta = {
    description = "playit.gg is a global proxy that allows anyone to host a server without port forwarding. We use tunneling. Only the server needs to run the program, not every player!";
    homepage = "https://playit.gg";
  };
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/playit
    chmod +x $out/bin/playit
  '';
}
