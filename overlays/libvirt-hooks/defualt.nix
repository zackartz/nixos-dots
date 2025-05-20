self: super: {
  nixosModules =
    super.nixosModules
    // {
      libvirtd = {
        config,
        lib,
        pkgs,
        ...
      } @ args: let
        originalModule = import super.nixosModules.libvirtd args;
      in
        lib.mkMerge [
          originalModule

          {
            config = lib.mkIf config.virtualisation.libvirtd.enable {
              virtualisation.libvirtd.hooks = lib.mkForce {};
            };
          }
        ];
    };
}
