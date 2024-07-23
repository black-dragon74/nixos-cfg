{ pkgs, ... }:

{
  imports = [
    (fetchTarball
      "https://github.com/nix-community/nixos-vscode-server/tarball/master")

    ./mounts.nix
  ];

  # Set hostname
  networking.hostName = "morningstar";

  # Install extra packages
  environment.systemPackages = with pkgs; [
    vim
    bat
    zip
    unzip
    git
    htop
    inetutils
    tree
    wget
    openiscsi
    tmux
    dig
    nixfmt-classic
    restic
  ];

  # Enable fish as shell for all users
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Enable services
  services.avahi.enable = true;
  services.tailscale.enable = true;
  services.vscode-server.enable = true; # Fix for vscode-server

  # Enable docker with ipv6
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        "ipv6" = true;
        "fixed-cidr-v6" = "2974:abc:1::/64";
        "ip6tables" = true;
        "experimental" = true;
        "dns" = [ "1.1.1.1" "1.0.0.1" ];
      };
    };
  };

  # Extra config for user nick
  users.groups.nick.gid = 1000;
  users.users.nick = {
    isNormalUser = true;
    uid = 1000;
    group = "nick";
    extraGroups = [ "docker" "wheel" ];
  };

  # Add wrapper for restic
  # This allows members of wheel group to run restic as root
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "root";
    group = "wheel";
    permissions = "u=rwx,g=wx,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # Manually set /etc/resolv.conf contents
  environment.etc = {
    "resolv.conf".text = ''
      nameserver 1.1.1.1
      nameserver 2606:4700:4700::1111
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = { AllowUsers = [ "root" "nick" ]; };
  };
}
