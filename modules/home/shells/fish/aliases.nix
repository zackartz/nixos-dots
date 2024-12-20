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
  du = getExe du-dust;
  ps = getExe procs;
  lb = "pw-loopback -C \"alsa_input.pci-0000_0d_00.4.analog-stereo\" -P \"Scarlett Solo (3rd Gen.) Headphones / Line 1-2\"";
  deploy = "nixos-rebuild switch --flake ~/nixos#pluto --target-host zoeys.computer --use-remote-sudo";
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
  wu = "vpn disconnect -w && awsvpnclient start --config ~/Downloads/cvpn-endpoint-085400ccc19bb4a17.ovpn";
  "v" = "nvim";
  ".." = "cd ..";
  "..." = "cd ../../";
  "...." = "cd ../../../";
  "....." = "cd ../../../../";
  "......" = "cd ../../../../../";
}
