# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./home.nix
  ];

  # Build machines for ghaf
  # nix is an option for the NixOS
  nix = {
    buildMachines = [
      {
        hostName = "hetzarm.vedenemo.dev";
        system = "aarch64-linux";
        maxJobs = 80;
        sshUser = "renzo";
        supportedFeatures = ["kvm" "benchmark" "big-parallel" "nixos-test"];
        mandatoryFeatures = [];
        sshKey = "/home/renzo/.ssh/id_hetzarm";
      }
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.extraEntries."ubuntu.conf" = ''
    title Ubuntu 22.04
    efi   /EFI/ubuntu/shimx64.efi
  '';

  boot.loader.systemd-boot.extraEntries."NixManual.conf" = ''
  title   NixOs (Manual)
  version Generation 198 NixOS Vicuna 24.11.20240716.ad0b5ee (Linux 6.6.40), built on 2025-07-19
  linux /EFI/nixos/d233rrhli90jq935l0jbqy3hwpj5ar51-linux-6.6.40-bzImage.efi
  initrd /EFI/nixos/icbcwx1mbj3zpl75ly9srkgfrramzfzs-initrd-linux-6.6.40-initrd.efi
  options init=/nix/store/i6dw98188ji6ak89pckb6dbm1pvigrl0-nixos-system-p1carbon-24.11.20240716.ad0b5ee/init modprobe.blacklist=nouveau nouveau.modeset=0 root=fstab loglevel=4 machine-id 53026cf0978a445fb77e83294f9cdde4
'';

  networking.hostName = "p1carbon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # # Configure NetworkManager-wait-online service
  # systemd.services."NetworkManager-wait-online" = {
  #   enable = true;
  #   serviceConfig = {
  #     ExecStart = [
  #       ""  # Clear the default ExecStart
  #       "${pkgs.networkmanager}/bin/nm-online -s -q --timeout=30"  # Set a shorter timeout (30 seconds)
  #     ];
  #     TimeoutStartSec = 35;  # Slightly longer than the nm-online timeout
  #   };
  # };

  # Enable vpn
  networking.openconnect.interfaces = {
    tii_vpn = {
      gateway = "access.tii.ae";
      passwordFile = "/var/lib/secrets/openconnect-passwd";
      protocol = "gp";
      user = "renzo.bruzzone";
      autoStart = false;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

  # Optional: Export locale to all shell sessions (good for bitbake)
  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "en_US.UTF-8";
  #   LC_IDENTIFICATION = "en_US.UTF-8";
  #   LC_MEASUREMENT = "en_US.UTF-8";
  #   LC_MONETARY = "en_US.UTF-8";
  #   LC_NAME = "en_US.UTF-8";
  #   LC_NUMERIC = "en_US.UTF-8";
  #   LC_PAPER = "en_US.UTF-8";
  #   LC_TELEPHONE = "en_US.UTF-8";
  #   LC_TIME = "en_US.UTF-8";
  # };

  # Add this to explicitly generate the required locales
  # i18n.supportedLocales = [
  #   "en_US.UTF-8/UTF-8"
  #   "en_US/ISO-8859-1"
  # ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  services.xserver.desktopManager.gnome.enable = true;

  # # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  # services.pulseaudio.enable = false;
  
  # Include both modesetting (Intel) and nvidia drivers for hybrid setup
  # PRIME offload ensures Intel is used for display, NVIDIA for containers/compute
  services.xserver.videoDrivers = ["modesetting" "nvidia"];
  
  # Force Intel as primary display device for X11 even when NVIDIA is loaded
  services.xserver.config = ''
    Section "Device"
        Identifier "Intel Graphics"
        Driver "modesetting"
        BusID "PCI:0:2:0"
    EndSection
    
    Section "Screen"
        Identifier "Intel Screen"
        Device "Intel Graphics"
    EndSection
    
    Section "ServerLayout"
        Identifier "Layout"
        Screen "Intel Screen"
    EndSection
  '';

  hardware.pulseaudio.enable = false;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;  # Enable 32-bit graphics support for NVIDIA
  hardware.opengl.enable = true;


  # NVIDIA configuration for computation and containers (PRIME offload)
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false;
      # Reverse prime - Intel for display, NVIDIA for offload only
      reverseSync.enable = false;
      intelBusId = "PCI:0:2:0";     # Intel iGPU from lspci
      nvidiaBusId = "PCI:1:0:0";    # NVIDIA GPU from lspci
    };
  };

  # Ensure NVIDIA is available for containers by setting proper environment
  environment.variables = {
    # NVIDIA container runtime variables
    NVIDIA_VISIBLE_DEVICES = "all";
    NVIDIA_DRIVER_CAPABILITIES = "all";
  };

  # DNS configuration
  environment.etc."resolv.conf".text = ''
    # search tii.local
    nameserver 10.161.10.11
    nameserver 8.8.8.8
    nameserver 8.8.4.4
    # options edns0
  '';

  # Ensure NVIDIA kernel modules are built and available
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.renzo = {
    isNormalUser = true;
    description = "Renzo";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout" "fuse" "video"];
    packages = with pkgs; [
      firefox
      python3Packages.pyserial
      #  thunderbird
    ];
  };

  users.users.renzobc = {
    isNormalUser = true;
    # hashedPassword = "$6$2TldBBBxBBgRL9CH$VldkwxIBPPk/aYCWGcB30v9g16WnoORcOxAcFE.RK4iE731QhPXoGi2GN7wx/1lAAHz49AyYQRIKCpXg7BTC.0";
    description = "Renzobc";
    extraGroups = ["networkmanager" "wheel" "docker" "fuse" "video" "dialout"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };


  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "renzo";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vscode
    terminator
    docker
    nmap
    git
    openconnect
    gnupg # For cryptographic keys
    docker-credential-helpers # Docker & docker-credential-pass
    pass # To use with docker-credential-pass
    containerd
    go
    rpcsvc-proto
    tailscale
    file
    python312
    bashInteractive
    python3Packages.pip
    python3Packages.kconfiglib
    python3Packages.pyserial
    python3Packages.numpy
    python3Packages.pexpect
    python3Packages.GitPython
    # python3Packages.jinja2
    python3Packages.pylint
    python3Packages.subunit
    # python3Packages.pallets-sphinx-themes
    direnv
    gcc
    cmake
    openssl
    unzip
    softhsm
    pkg-config
    xorg.libX11
    docker-compose
    gnumake
    glibcLocales
    ejson
    tio
    oras
    xorg.xhost
    qt5.qtbase
    croc
    dpkg
    natscli
    mpv
    curl
    sudo
    sshuttle
    openssh
    ruff
    fontconfig
    noto-fonts
    flux
    mkcert
    sops
    age
    texlivePackages.zztex
    texlive.combined.scheme-full
    fluxcd
    pv
    vlc
    jq
    usbutils
    diffstat
    whois
    lsof
    qgroundcontrol
    go
    ffmpeg_7-full
    tcpdump
    spotify
    lshw
    pciutils
    google-chrome
    traceroute
    busybox
    fzf
    bat
    gawk
    sqlite
    sqlitebrowser
    pre-commit
    gst_all_1.gstreamer
    fuse3
    fuse
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    obsidian
    gh
    binutils
    gdb
    chrpath
    socat
    cpio
    xz
    debianutils
    mesa
    mesa.dev
    SDL
    xterm
    zstd
    lz4
    nvidia-container-toolkit
    nvidia-vaapi-driver
    nvtopPackages.full
    config.boot.kernelPackages.nvidia_x11  # This provides nvidia-smi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Disable ModemManager
  systemd.services.ModemManager.enable = false;


  # Enable tailscale
  services.tailscale.enable = true;

  programs = {
    gnupg = {
      agent = {
        enable = true;
        # defaultCacheTtl = 1800;
        # enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-qt;
      };
    };
  };

  #########################################################
  # Locking the screen when the yibikey is unplugged
  # services.udev.extraRules = ''
  #       ACTION=="bind",\
  #        ENV{ID_BUS}=="usb",\
  #        ENV{ID_VENDOR}=="03e7",
  #        ENV{ID_MODEL_ID}=="0407",\
  #        ENV{ID_VENDOR_ID}=="1050",\
  #        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  #   '';
  #########################################################

  # give access to the saluki pi on ttyACM0
  services.udev.extraRules = ''
    KERNEL=="ttyACM0", MODE:="666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="666"
    KERNEL=="nvidia*", OWNER="root", GROUP="video", MODE="0660"
  '';

  networking.firewall.enable = false; # Ensure firewall is enabled
  networking.nat.enable = true; # Enable NAT
  # networking.enableIPv4Forwarding = true;  # Enable IPv4 forwarding

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1; # Enable IPv4 forwarding
    "net.ipv6.conf.all.forwarding" = 1; # Optional: Enable IPv6 forwarding
  };

  # In NixOS, you can add NAT rules declaratively in your configuration.nix. Assuming:

  #     WiFi Interface = wlp0s20f3 enp85s0(Internet source)
  #     USB Ethernet Interface = enp86s0u2c2 (Network to share Internet to)
  # iptables -t nat -A POSTROUTING -o wlp0s20f3 -j MASQUERADE
    # Disable waiting for network during boot
  systemd.services."NetworkManager-wait-online".enable = false;

  # networking.interfaces.enp86s0u1c2 = {
  #   useDHCP = false; # Disable DHCP for this interface
  #   ipv4.addresses = [
  #     {
  #       address = "192.168.128.25"; # Your desired IP address
  #       prefixLength = 24; # Your subnet mask (e.g., /24)
  #     }
  #   ];
  # };
  #   defaultGateway = "192.168.1.1";  # Your default gateway (router's IP)
  #   nameservers = ["8.8.8.8"];      # Your DNS servers (e.g., Google DNS)
  # };
  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i enp86s0u2c2 -o wlp0s20f3 -j ACCEPT
    iptables -A FORWARD -i wlp0s20f3 -o enp86s0u2c2 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -t nat -A POSTROUTING -o enp85s0 -j MASQUERADE
    iptables -A FORWARD -i enp86s0u2c2 -o enp85s0 -j ACCEPT
    iptables -A FORWARD -i enp85s0 -o enp86s0u2c2 -m state --state RELATED,ESTABLISHED -j ACCEPT
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  programs.hyprland.enable = true;

  # nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # nix.settings.sandbox = false;

  # services.logind.lidSwitchExternalPower = "ignore";

  # Enable nvidia
  # Enable 32-bit support
  # hardware.enableRedistributableFirmware = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.pulseaudio.support32Bit = true;  # Optional, for 32-bit audio apps
  # services.xserver.videoDrivers = [ "nvidia" "intel"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   # package = config.boot.kernelPackages.nvidiaPackages.production;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   # cudaSupport = true;
  #   # nvidiaContainerToolkit.enable = true;
  # };

  # hardware.nvidia.prime = {
  # 	# Make sure to use the correct Bus ID values for your system!
  # 	intelBusId = "PCI:00:02:0";
  # 	nvidiaBusId = "PCI:01:00:0";
  #               # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  # };

  # Runtime Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    package = pkgs.docker;

    enableNvidia = true;

    # Configure Docker daemon.json settings
    daemon.settings = {
      # Set DNS to 8.8.8.8
      # DNS set solved the problem about the devcontainers failing to apt update
      dns = ["8.8.8.8" "8.8.4.4" "10.161.10.11"];
      # "bridge"= "host";

      # Other example settings
      # "insecure-registries" = [ "my-registry.local:5000" ];
      # "exec-opts" = [ "native.cgroupdriver=systemd" ];
      # "data-root" = "/var/lib/docker";
    };
  };

  # Enable NVIDIA container support using the new CDI method
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  hardware.nvidia-container-toolkit.enable = true;


  # networking.firewall.enable  = false;
  # networking.firewall.allowedTCPPortRanges = [
  #   {
  #     from = 3000;
  #     to = 9000;
  #   }
  #   {
  #     from = 39320;
  #     to = 39420;
  #   }
  # ];

  # networking.firewall.allowedUDPPortRanges = [
  #   {
  #     from = 3000;
  #     to = 9000;
  #   }
  # {
  #   from = 8000;
  #   to = 8010;
  # }
  # ];
  # networking.firewall.allowedTCPPorts = [22 80 443];
  virtualisation.oci-containers.backend = "docker";
  virtualisation.podman.enable = true;

  # services.docker = {
  #   enable = true;
  #   extraOptions = [
  #     "--add-runtime=nvidia=/run/current-system/sw/bin/nvidia-container-runtime"
  #     "--default-runtime=nvidia"
  #   ];
  # };

  # garbage collect
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # security.pki.certificateFiles = [
  #   /var/lib/secrets/chain.crt
  # ];


  


}
