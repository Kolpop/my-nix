{ pkgs, config, ... }:

{

  services.zapret = {
    enable = true;

    # Точная копия аргументов nfqws, соответствующих режиму ALT11
    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-split-pos=1"
      "--dpi-desync-ttl=0"
      "--dpi-desync-fooling=md5sig"
      "--dpi-desync-repeats=6"
      "--dpi-desync-any-protocol=1"
      "--dpi-desync-udp=fake"
      "--dpi-desync-udp-repeats=11"
    ];

    # Список доменов, для которых применяется этот режим (обязательно для Discord)
    whitelist = [
      "discord.com"
      "discord.gg"
      "discord.media"
      "discordapp.com"
      "discordapp.net"
      "discordstatus.com"
      "gateway.discord.gg"
      "://discordapp.com"
      "media.discordapp.net"
      "images.discordapp.net"

      # YouTube (если нужен, так как ALT11 часто используют для обоих сервисов)
      "youtube.com"
      "youtu.be"
      "ytimg.com"
      "ggpht.com"
      "googlevideo.com"
    ];
  };

}
