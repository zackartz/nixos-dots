{pkgs, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    NVD_BACKEND = "direct";
    # __GL_GSYNC_ALLOWED = "1";
    # __GL_VRR_ALLOWED = "1";
    XWAYLAND_NO_GLAMOR = "1";
    __GL_MaxFramesAllowed = "1";
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];
}
