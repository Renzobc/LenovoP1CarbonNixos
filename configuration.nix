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

  networking.hostName = "p1carbon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable vpn
  networking.openconnect.interfaces = {
    tii_vpn = {
      gateway = "access.tii.ae";
      passwordFile = "/var/lib/secrets/openconnect-passwd";
      protocol = "gp";
      user = "renzo.bruzzone";
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

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
  hardware.pulseaudio.enable = false;
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
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  users.users.renzobc = {
    isNormalUser = true;
    hashedPassword = "$6$2TldBBBxBBgRL9CH$VldkwxIBPPk/aYCWGcB30v9g16WnoORcOxAcFE.RK4iE731QhPXoGi2GN7wx/1lAAHz49AyYQRIKCpXg7BTC.0";
    description = "Renzobc";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  # home-manager.users.renzo={
  #   home={
  #     username="renzo";
  #     stateVersion="24.05";
  #     homeDirectory="/home/renzo";
  #   };
  #   programs.git = {
  #   package = pkgs.gitAndTools.gitFull;
  #   enable = true;
  #   userName = "Renzo Bruzzone";
  #   userEmail = "renzo.bruzzone@tii.ae";
  #   # delta.enable = true; # see diff in a new light
  #   # delta.options = {
  #   #   line-numbers = true;
  #   #   side-by-side = true;
  #   #   syntax-theme = "Dracula";
  #   # };
  #   ignores = ["*~" "*.swp"];
  #   extraConfig = {
  #     core.editor = "vscode";
  #     color.ui = "auto";
  #     #credential.helper = "store --file ~/.git-credentials";
  #     format.signoff = true;
  #     commit.gpgsign = true;
  #     tag.gpgSign = true;
  #     gpg.format = "ssh";
  #     user.signingkey = "/home/renzo/.ssh/id_ed25519.pub";
  #     gpg.ssh.allowedSignersFile = "/home/renzo/.ssh/allowed_signers";
  #     init.defaultBranch = "main";
  #     #protocol.keybase.allow = "always";
  #     pull.rebase = "true";
  #     push.default = "current";
  #     github.user = "RenzoBruzzoneC";
  #   };
  # };
  # };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "renzo";

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
    git
    openconnect
    nvidia-docker
    containerd
    gnupg
    go
    tailscale
    python312
    openssl
    unzip
    softhsm
    pkg-config
    xorg.libX11
    docker-compose
    gnumake
    ejson
    cmake
    tio
    oras
    xorg.xhost
    qt5.qtbase
    dpkg
    curl
    sudo
    openssh
    kubectl
    kubernetes-helm
    minikube
    flux
    mkcert
    sops
    age
    k9s
    fluxcd
    openlens
    stern
    taskwarrior3
    jq
    usbutils
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
  #       ACTION=="remove",\
  #        ENV{ID_BUS}=="usb",\
  #        ENV{ID_MODEL_ID}=="0407",\
  #        ENV{ID_VENDOR_ID}=="1050",\
  #        ENV{ID_VENDOR}=="Yubico",\
  #        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  #   '';
  #########################################################

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  programs.hyprland.enable = true;

  # nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.sandbox=false;

  # services.docker.enable = true;
  # enable docker
  # virtualisation.docker.daemon.settings = {
  #           dns= [8.8.8.8];
  #         };

  # Runtime Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;

    # Configure Docker daemon.json settings
    daemon.settings = {
      # Set DNS to 8.8.8.8
      # DNS set solved the problem about the devcontainers failing to apt update
      "dns" = ["8.8.8.8"];
      # "bridge"= "host";

      # Other example settings
      # "insecure-registries" = [ "my-registry.local:5000" ];
      # "exec-opts" = [ "native.cgroupdriver=systemd" ];
      # "data-root" = "/var/lib/docker";
    };

    # extraOptions = ''
    #   --log-driver=journald
    #   --max-concurrent-downloads=3
    # '';
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.podman.enable = true;

  # garbage collect
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  security.pki.certificateFiles = [
    /var/lib/secrets/chain.crt
  ];
}
