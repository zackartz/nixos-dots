{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with pkgs; {
  ytmp3 = ''
    ${getExe yt-dlp} -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"'';
  cat = "${getExe bat} --style=plain";
  vpn = "mullvad";
  uuid = "cat /proc/sys/kernel/random/uuid";
  grep = getExe ripgrep;
  fzf = getExe skim;
  untar = "tar -xvf";
  untargz = "tar -xzf";
  MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  du = getExe du-dust;
  ps = getExe procs;
  deploy = "nixos-rebuild switch --flake ~/nixos#pluto --target-host zack@zackmyers.io --use-remote-sudo";
  m = "mkdir -p";
  fcd = "cd $(find -type d | fzf)";
  l = "ls -lF --time-style=long-iso --icons";
  sc = "sudo systemctl";
  scu = "systemctl --user ";
  la = "${getExe eza} -lah --tree";
  ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
  tree = "${getExe eza} --tree --icons --tree";
  kys = "shutdown now";
  gpl = "curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
  agpl = "curl https://www.gnu.org/licenses/agpl-3.0.txt -o LICENSE";
  tsm = "transmission-remote";
  g = "git";
  n = "nix";
  r = "rebuild";
  vm = "nixos-rebuild build-vm --flake ~/nixos#earth";
  mnt = "udisksctl mount -b";
  umnt = "udisksctl unmount -b";
  burn = "pkill -9";
  diff = "diff --color=auto";
  ws = "sudo systemctl status openvpn-work.service";
  wu = "vpn disconnect -w && sudo systemctl start openvpn-work.service";
  wd = "sudo systemctl stop openvpn-work.service && vpn connect -w";
  "v" = "nvim";
  ".." = "cd ..";
  "..." = "cd ../../";
  "...." = "cd ../../../";
  "....." = "cd ../../../../";
  "......" = "cd ../../../../../";
}
