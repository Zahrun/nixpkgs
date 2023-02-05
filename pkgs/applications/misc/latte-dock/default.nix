{ mkDerivation, lib, cmake, xorg, plasma-framework, plasma-wayland-protocols, fetchFromGitLab
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, qtwayland, kcrash, knewstuff, wayland, plasma-workspace, makeWrapper }:

mkDerivation rec {
  pname = "latte-dock";
  version = "unstable-2023-01-26";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "latte-dock";
    rev = "159496edc0609c953a813a41844bbb4f0ee22db4";
    sha256 = "sha256-WqAlnwD/Q7+OUf2MuJfsFkruYQnlYahRCm1p+1zu8eA=";
  };

  buildInputs = [ plasma-framework plasma-wayland-protocols qtwayland xorg.libpthreadstubs xorg.libXdmcp xorg.libSM wayland ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash knewstuff makeWrapper ];

  patches = [
    ./0001-Disable-autostart.patch
    #./0002-Detect-kde-version.patch
  ];

  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    cp $out/share/applications/org.kde.latte-dock.desktop $out/etc/xdg/autostart
    wrapProgram $out/bin/latte-dock --prefix PATH : ${lib.makeBinPath [ plasma-workspace ]}
  '';

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = "https://invent.kde.org/plasma/latte-dock";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.ysndr ];
  };


}
