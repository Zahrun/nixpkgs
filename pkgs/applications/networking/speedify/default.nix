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
    hash = "sha256-BW/XGdgiUnx8ZT8xvtIgrBkd3iU6OyGsms7XPPt6p0w=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ steam-run ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    #runHook preInstall
    #pwd
    #ls
    #ls *
    mkdir -p $out/share/
    mv usr/share/speedify $out/share/
    mkdir -p $out/share/dbus-1/services
    sed -i "s;/usr/share;$out/share;g" "lib/systemd/system/speedify.service
    sed -i "s;/usr/share;$out/share;g" "lib/systemd/system/speedify-sharing.service
    mv lib/systemd/system/* $out/share/dbus-1/services/
    ls $out/share/dbus-1/services/
    echo echo5
    #substituteInPlace "$out/share/dbus-1/services/speedify.service \
    	--replace '/usr/share' "$out/share"
    #substituteInPlace "$out/share/dbus-1/services/speedify-sharing.service \
    	--replace '/usr/share' '$out/share'
    ls $out/*
    cat $out/share/dbus-1/services/*
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
