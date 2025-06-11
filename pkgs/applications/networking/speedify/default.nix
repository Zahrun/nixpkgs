{ lib
, stdenv
, fetchurl
, procps
, nettools
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  pname = "speedify";
  version = "15.6.3-12489";

  src = fetchurl {
    url = "https://apt.connectify.me/pool/main/s/speedify/speedify_${version}_amd64.deb";
    hash = "sha256-BW/XGdgiUnx8ZT8xvtIgrBkd3iU6OyGsms7XPPt6p0w=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ procps nettools ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    #runHook preInstall
    if false; then
      set -x
      echo echo5
      pwd
      ls -l
      #ls *
      ls -l lib
      ls -l lib/systemd
      ls -l lib/systemd/system
      cat lib/systemd/system/speedify.service
      set +x
    fi

    #sed -i "s;/usr/share;$out/share;g" lib/systemd/system/speedify.service
    #sed -i "s;/usr/share;$out/share;g" lib/systemd/system/speedify-sharing.service
    #substituteInPlace "lib/systemd/system/speedify.service" \
    #	--replace-fail '/usr/' "$out/usr/"
    #substituteInPlace "lib/systemd/system/speedify-sharing.service" \
    #	--replace-fail '/usr/' "$out/usr/"

    substituteInPlace "usr/share/speedify/SpeedifyStartup.sh" \
    	--replace-fail '/usr/share/' "$out/share/"
    substituteInPlace "usr/share/speedify/SpeedifyShutdown.sh" \
    	--replace-fail '/usr/share/' "$out/share/"
    substituteInPlace "usr/share/speedify/GenerateLogs.sh" \
    	--replace-fail '/usr/share/' "$out/share/"
#     substituteInPlace "usr/share/speedify/SpeedifyStartup.sh" \
#       --replace-fail './speedify -d' "steam-run ./speedify -d"
    substituteInPlace "usr/share/speedify/SpeedifyStartup.sh" \
      --replace-fail 'logs' "/var/log/speedify"
    cat usr/share/speedify/SpeedifyStartup.sh

    mkdir -p $out/share/
    mv usr/share $out/
    mkdir -p $out/etc/
    mv lib/systemd $out/etc/
    ls $out/*
    cat $out/lib/systemd/system/*
    mkdir -p $out/bin
    ln -s $out/share/speedify/speedify_cli $out/bin/speedify_cli

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
