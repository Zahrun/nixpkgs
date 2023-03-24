{ mkDerivation, lib, cmake, xorg, plasma-framework, plasma-wayland-protocols, fetchFromGitLab
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, qtwayland, kcrash, knewstuff, wayland }:

mkDerivation rec {
  pname = "latte-dock";
  version = "unstable-2023-03-24";

  src = /home/aroun/UnixSync/dev/latte-dock/.;
  #src = fetchFromGitLab {
  #  domain = "invent.kde.org";
  #  owner = "aroun";
  #  repo = "latte-dock";
  #  rev = "a0e10d4550e153545517408deee6acb60dbb20b0";
  #  hash = "sha256-qg75Qy4AYS1lnL292EVohbIYcyub1LCPIBC5Y2d9oDg=";
  #};

  buildInputs = [ plasma-framework plasma-wayland-protocols qtwayland xorg.libpthreadstubs xorg.libXdmcp xorg.libSM wayland ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash knewstuff ];

  patches = [
    ./0001-Disable-autostart.patch
  ];

  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    cp $out/share/applications/org.kde.latte-dock.desktop $out/etc/xdg/autostart
  '';

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = "https://invent.kde.org/plasma/latte-dock";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.ysndr ];
  };


}
