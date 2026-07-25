{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        imageSize = "210G";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };               
            };
            swap = {
              priority = 2;
              name = "swap";
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            nixos = {
              priority = 3;
              name = "nixos";
              size = "200G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            }; 
          };
        };
      };
    };
  };
}
