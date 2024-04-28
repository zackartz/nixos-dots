# zack's nixos dotfiles

![image](https://github.com/zackartz/nixos-dots/assets/34588810/0f4c85c2-f9e8-4de3-89c1-0a95c0ab681f)

my customized versions of other's dotfiles

major credits to [sioodmy](https://github.com/sioodmy/dotfiles) and [luckasRanarison](https://github.com/luckasRanarison/nvimrc).

could not have done this without their work :)

## How to Install

### Prerequisetes

Grab the latest NixOS ISO from NixOS [nixos.org](https://nixos.org). After that, make a new shell with git available:

```bash
nix shell nixpkgs#git
```

Now, configure your disk as seen [here](https://nixos.wiki/wiki/NixOS_Installation_Guide#Partitioning).

> [!NOTE]
> Just follow the partitioning and mounting steps, the other steps to install will be listed below.

### 1. Cloning the repository

With git installed, clone the repository with

```bash
git clone https://github.com/zackartz/nixos-dots.git && cd nixos-dots
```

### 2. Configuring the System

Generate your `hardware-configuration.nix` file.

```bash
sudo nixos-generate-config --root /mnt
```

You will now have two files in `/mnt/etc/nixos`. We will need `hardware-configuration.nix` and part of `configuration.nix`.

```bash
[nixos@live:~/nixos-dots]$ ls /mnt/etc/nixos/
configuration.nix  hardware-configuration.nix
```

Go ahead and make a new folder for your pc inside of the `hosts` directory.

```bash
cd hosts && mkdir vm # change "vm" to your preferred hostname -- it MUST match the hostname you plan on using for scripts to work properly.
```

> [!TIP]
> You can use the "m" alias to create directories once you have booted into the installed system!

Now, copy the files over from `/mnt/etc/nixos/`.

```bash
cd vm && cp /mnt/etc/nixos/* . # remember to change "vm" to your hostname
mv configuration.nix config.old.nix # we will be writing our own configuration.nix
```

Now, make a new file: `configuration.nix`.

```bash
touch configuration.nix
```

Open up `configuration.nix` in your favorite editor and paste the following:

```nix
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "vm"; # Define your hostname.

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "zack";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zack" = {
        imports = [../../modules/home-manager/default.nix];
        _module.args.theme = import ../../core/theme.nix;

        home.username = "zack";
        home.homeDirectory = "/home/zack";
      };
    };
  };
}
```

Change the instances of `zack` to your desired username, and customize as you see fit!

We will need to copy some things over from `configuration.nix`, namely boot related options. I am doing this in a VM, so I see these boot related options. Find the `boot.loader` option, and copy it over from your old file into this new one.

```nix
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # the device to change
```

> [!WARNING]
> DO NOT COPY THIS CODE, THIS IS JUST AN EXAMPLE OF WHAT TO LOOK FOR

Make sure the device targets the correct drive for your EFI to be installed on.

Finally, add the following to `flake.nix` (somewhere around line 100).

```nix
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/vm/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
```

### 3. Installing the system

Now that you have the config ready to go, run the following command.

```bash
rm -rf .git # remove the github repository
sudo nixos-install --flake ~/nixos-dots#vm # again, remember to change vm to be your hostname
```

### 4. Post-Install configuration.

Set a password for your user:

```bash
sudo passwd zack # replace with your username
```

Copy the flake to your home folder

```bash
cp -r ~/nixos-dots /mnt/home/zack/nixos # replace "zack" with your username
```

Reboot the system and you're done! Enjoy the system!

> [!TIP]
> Check `./modules/shell/zsh/aliases.nix` for useful aliases, like "r" to rebuild your system!
