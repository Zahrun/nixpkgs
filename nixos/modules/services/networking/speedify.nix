{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.speedify;
  speedify = import (builtins.fetchTarball {
    url = "https://github.com/zahrun/nixpkgs/archive/faf6f1cddbc6.tar.gz";
  }) {config = removeAttrs config.nixpkgs.config [ "packageOverrides" ];};
in
with lib;
{
  options.services.speedify = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables Speedify daemon.
      '';
    };

    package = lib.mkPackageOption speedify "speedify" { };

  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    systemd.services.speedify = {
      description = "Speedify Service";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network.target"
        "network-online.target"
      ];
      after = [
        "network-online.target"
        "NetworkManager.service"
        #"systemd-resolved.service"
      ];
      # See https://github.com/NixOS/nixpkgs/issues/262681
      #path = lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;
      path = [ pkgs.procps pkgs.nettools ];
      #startLimitBurst = 5;
      #startLimitIntervalSec = 20;
      serviceConfig = {
        ExecStart = "${cfg.package}/share/speedify/SpeedifyStartup.sh";
        ExecStop = "${cfg.package}/share/speedify/SpeedifyShutdown.sh";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStartSec = 30;
        TimeoutStopSec = 30;
        Type = "forking";
        #CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        #AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
      };
    };
  };

  meta.maintainers = with maintainers; [
    zahrun
  ];
}
