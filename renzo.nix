{pkgs, ...}: let
  # fog-hyper = import ./fog-hyper/fog-hyper.nix {inherit pkgs;}; # Fog hyper cannot be used on nixos since it tries to update itself on the system
  # dronsole = import ./dronsole/dronsole.nix {inherit pkgs;};
in {
  home-manager.backupFileExtension = "bkp";
  home-manager.users.renzo = {
    home = {
      username = "renzo";
      stateVersion = "24.11";
      homeDirectory = "/home/renzo";
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        lk = "vim $(fzf --preview='bat --color=always {}')";
        # dronsole = "docker run --rm -it -p 3000:3000 -p 8888:8888 -p 4280:4280 -p 4222:4222 -v $(pwd):/workspace -v $HOME/.dronsole:/root/.dronsole --entrypoint /bin/dronsole ghcr.io/tiiuae/tii-dronsole:latest";
      };
      bashrcExtra = ''        if command -v fzf-share >/dev/null; then
                              source "$(fzf-share)/key-bindings.bash"
                              source "$(fzf-share)/completion.bash"
                            fi'';
    };

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "RenzoBruzzoneC";
      userEmail = "renzo.bruzzone@tii.ae";
      # delta.enable = true; # see diff in a new light
      # delta.options = {
      #   line-numbers = true;
      #   side-by-side = true;
      #   syntax-theme = "Dracula";
      # };
      ignores = ["*~" "*.swp"];
      extraConfig = {
        core.editor = "nano";
        color.ui = "auto";
        #credential.helper = "store --file ~/.git-credentials";
        format.signoff = true;
        # commit.gpgsign = true;
        # tag.gpgSign = true;
        # gpg.format = "ssh";
        user.signingkey = "/home/renzo/.ssh/id_lenovo.pub";
        # gpg.ssh.allowedSignersFile = "/home/renzo/.ssh/allowed_signers";
        init.defaultBranch = "main";
        #protocol.keybase.allow = "always";
        pull.rebase = "true";
        push.default = "current";
        github.user = "RenzoBruzzoneC";
      };
    };

    home.packages = [
      # fog-hyper
      # dronsole
    ];

    # home.file.".docker/config.json".text = ''{"credsStore": "secretservice"}''; # This makes the file read only!!!!!!!!!
    # home.file.".docker/config.json" = {
    #   text = builtins.toJSON {credsStore = "secretservice";};
    #   force = true; # Ensures the file is always overwritten
    # };
    # home.file.".docker/config.json".source = "/home/renzo/.docker/config.json";
  };
}
/*
 Check SSH Configuration File Permissions

The SSH configuration file (~/.ssh/config) and the keys (~/.ssh/id_ed25519 and ~/.ssh/id_ed25519.pub) must have the correct permissions:

    Private Key (id_ed25519): Should be readable only by you. You can set the correct permissions using:

    bash

chmod 600 ~/.ssh/id_ed25519

Public Key (id_ed25519.pub): Should be readable by anyone. You can set the correct permissions using:

bash

chmod 644 ~/.ssh/id_ed25519.pub

SSH Config File (config): Should be readable only by you. You can set the correct permissions using:

bash

chmod 600 ~/.ssh/config
*/

