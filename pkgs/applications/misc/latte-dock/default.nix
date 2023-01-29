{ mkDerivation, lib, cmake, xorg, plasma-framework, plasma-wayland-protocols, fetchFromGitLab
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, qtwayland, kcrash, knewstuff, wayland }:

mkDerivation rec {
  pname = "latte-dock";
  version = "unstable-2023-01-27";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "aroun";
    repo = "latte-dock";
    rev = "8635984b2e6f3dd7369a0fcbd23aa166866a024b";
    hash = "sha256-VINpYWPDVtZ6YlzuXHwl7zmfYMZEhJMzCaDAFs6t1Qk=";
  };

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
