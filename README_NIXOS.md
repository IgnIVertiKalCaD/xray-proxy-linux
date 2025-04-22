
# xray-proxy-linux

## VLESS + REALITY + Linux TPROXY

This repository contains configuration files and settings for **VLESS + REALITY + Linux TPROXY**.

---

## Useful links

https://gozargah.github.io/marzban/en/docs/introduction

---

## PreSetup for NixOS
```
networking.firewall.enable = false; 
```

firewall is disabled. Why?
You don't fucking need to install this on your home machine if you stand the fuck FOR nat (router, ...).


## Setup

To get started, open this repository in your favorite IDE and enter your values in the following variables:

### Required Variables

The variables are marked with comments in the configuration files:

- **JSON files**: Variables are marked using `//` comments.
- **nftables configuration**: Variables are marked using `#` comments.

#### Variables:

- **TPROXY Port (optional):**\
  `_DOKODEMO_TPROXY_PORT`

- **VLESS Server Address:**\
  `_VLESS_ADDRESS`

- **VLESS Port:**\
  `_VLESS_PORT`

- **VLESS User UUID:**\
  `_VLESS_USER_UUID`

- **REALITY Public Key:**\
  `_REALITY_PUBLIC_KEY`

- **REALITY Short ID:**\
  `_REALITY_SHORT_ID`

---

##  Prerequisites

For **NixOS**:

> /etc/nixos/configuration.nix

```nix
networking.firewall.enable = false; 

networking.iproute2.enable = true;

networking.nftables = {
    enable = true;
    flushRuleset = true;
    flattenRulesetFile = true;
    rulesetFile = "/etc/nftables.d/proxy.conf";
};
```

---

## Installing Xray Core (skip)

It doesn't have to be put in manually somehow.
Xray is prescribed in the service. Xray is used from your pkgs. It will not be in the system/user environment. It is only in the service that calls xray from the pkgs.xray package.
Get it?

---

## Install Configuration Files

### 1. Init
#### 1.1. Run script

```bash
sh init.sh
```

#### 1.2. Connect xray-proxy.nix config to configuration.nix
> /etc/nixos/configuration.nix
```nix
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./xray-proxy.nix
	  ...
    ];
}
```

### 2. Rebuild nixos

> for tests

```bash
nixos-rebuild test
```

> for prod

```bash
nixos-rebuild switch
```

---

### 3. Check the Service Status

```bash
systemctl status xray
```

---

## Contributing & Support

For any questions or improvements, feel free to open an issue or submit a pull request.
