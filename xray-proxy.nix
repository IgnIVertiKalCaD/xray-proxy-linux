systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s";

    services = {
      xray = {
        enable = true;
        description = "Xray Proxy";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          Environment = [
            "MARK_PROXY=200"
            "LOOPBACK_TABLE=proxy_loopback"
            "SUBNET_4=0.0.0.0/0"
            "SUBNET_6=::/0"
          ];

          ExecStartPre = [
            "${pkgs.coreutils}/bin/mkdir -p /etc/iproute2/rt_tables.d"
            "${pkgs.bash}/bin/sh -c 'echo $MARK_PROXY $LOOPBACK_TABLE > /etc/iproute2/rt_tables.d/proxy.conf'"
          ];

          ExecStart = "${pkgs.xray}/bin/xray run --config /etc/xray/config.json";

          ExecStartPost = [
            "${pkgs.iproute2}/bin/ip rule add fwmark $MARK_PROXY table $LOOPBACK_TABLE"
            "${pkgs.iproute2}/bin/ip route add local $SUBNET_4 dev lo table $LOOPBACK_TABLE"
          ];

          ExecStopPost = [
            "${pkgs.iproute2}/bin/ip rule del fwmark $MARK_PROXY table $LOOPBACK_TABLE"
            "${pkgs.iproute2}/bin/ip route del local $SUBNET_4 dev lo table $LOOPBACK_TABLE"
            "${pkgs.coreutils}/bin/rm -f /etc/iproute2/rt_tables.d/proxy.conf"
          ];

          Restart = "on-failure";
          RestartSec = 10;
        };
      };

    };
};
