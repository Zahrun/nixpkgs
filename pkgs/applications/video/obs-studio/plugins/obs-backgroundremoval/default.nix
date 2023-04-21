{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
, onnxruntime
, opencv
, cudaPackages
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "0.5.17";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = "db8791aa47c4c1e99e2d42b7057d73e51f6df0be";
    hash = "sha256-anTpHj/+E0O/p/mxE+j6d59TcLI20ixZKeqtavrnac4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio onnxruntime opencv cudaPackages.tensorrt ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ zahrun ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
