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
  lb = "pw-loopback -C \"alsa_input.pci-0000_0d_00.4.analog-stereo\" -P \"Scarlett Solo (3rd Gen.) Headphones / Line 1-2\"";
  deploy = "nixos-rebuild switch --flake ~/nixos#pluto --target-host zoeys.computer --use-remote-sudo";
  m = "mkdir";
  l = "exa -lF --time-style=long-iso --icons";
  sc = "sudo systemctl";
  scu = "systemctl --user ";
  la = "${getExe eza} -lah --tree";
  tree = "${getExe eza} --tree --icons --tree";
  kys = "shutdown now";
  lv = "nvim -c \"normal '\''0\"";
  gpl = "curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
  agpl = "curl https://www.gnu.org/licenses/agpl-3.0.txt -o LICENSE";
  tsm = "transmission-remote";
  g = "git";
  n = "nix";
  r = "rebuild";
  vm = "nixos-rebuild build-vm --flake ~/nixos#earth";
  burn = "pkill -9";
  diff = "diff --color=auto";
  "v" = "nvim";
  ".." = "cd ..";
  "..." = "cd ../../";
  "...." = "cd ../../../";
  "....." = "cd ../../../../";
  "......" = "cd ../../../../../";
}
