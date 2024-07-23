# Extra mounts

{ pkgs, ... }:

{
  imports = [ ];

  # Enable iscsi service
  # services.openiscsi = {
  #   enable = true;
  #   name = "target.nixos.ydvnick.cc";
  #   enableAutoLoginOut = true;
  # };

  # fileSystems."/mnt/nextcloud" = {
  #   device = "/dev/disk/by-uuid/43e207ef-a1c4-403c-8ddb-8489332e3b7d";
  #   fsType = "xfs";
  #   options = [ "_netdev" "nofail" ];
  # };
}
