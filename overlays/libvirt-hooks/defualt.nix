self: super: {
  # We are overriding the libvirtd entry in nixosModules
  nixosModules =
    super.nixosModules
    // {
      libvirtd = {
        config,
        lib,
        pkgs,
        ...
      } @ args: let
        # Import and evaluate the original libvirtd module definition
        # super.nixosModules.libvirtd is typically the path to the original module file
        originalModule = import super.nixosModules.libvirtd args;
      in
        lib.mkMerge [
          # Include everything from the original module (its options, config assignments, etc.)
          originalModule

          # Add our overriding configuration
          {
            config = lib.mkIf config.virtualisation.libvirtd.enable {
              virtualisation.libvirtd.hooks = lib.mkForce {};
            };
          }
        ];
    };
}
