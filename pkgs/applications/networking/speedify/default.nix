{ lib
, stdenv
, fetchurl
, gnutar
, steam-run
, makeDesktopItem
, copyDesktopItems
, makeWrapper
,
}:
stdenv.mkDerivation rec {
  pname = "speedify";
  version = "15.6.3-12489";

  src = fetchurl {
    url = "https://apt.connectify.me/pool/main/s/speedify/speedify_${version}_amd64.deb";
    hash = "056fd719d822527c7c653f31bed220ac191dde253a3b21ac9aced73cfb7aa74c";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ steam-run ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    #runHook preInstall
    pwd
    ls
    read
    ls *
    #cd ./anylogic
    #pwd
    #chmod -R a+wr plugins/com.anylogic.examples_*
    #cd ..
    #mkdir -p $out/opt
    #mv anylogic $out/opt
    #mkdir -p $out/share/icons
    #ln -s $out/opt/anylogic/icon.xpm $out/share/icons/anylogic-ple.xpm
    #mkdir -p $out/bin
    #makeWrapper "${steam-run}/bin/steam-run" "$out/bin/anylogic" --add-flags "$out/opt/anylogic/anylogic"
    #chmod +x $out/bin/anylogic
    #runHook postInstall
  '';

  meta = with lib;
    {
      homepage = "https://speedify.com/";
      description = "Use multiple internet connections in parallel";
      longDescription = "Combine multiple internet connections (Wi-Fi, 4G, 5G, Ethernet, Starlink, Satellite, and more) to improve the stability, speed, and security of your online experiences";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ zahrun ];
    };
}
