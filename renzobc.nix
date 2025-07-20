{pkgs, ...}: {
  home-manager.backupFileExtension = "bkp";
  home-manager.users.renzobc = {
    home = {
      username = "renzobc";
      stateVersion = "24.11";
      homeDirectory = "/home/renzobc";
    };

    programs.bash = {
      enable = true;
      shellAliases = {
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
      userName = "Renzobc";
      userEmail = "bruzzonecozzarelli@gmail.com";
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
        format.signoff = false;
        commit.gpgsign = false;
        tag.gpgSign = false;
        gpg.format = "ssh";
        user.signingkey = "/home/renzobc/.ssh/id_lenovo";
        # gpg.ssh.allowedSignersFile = "/home/renzobc/.ssh/allowed_signers";
        init.defaultBranch = "main";
        #protocol.keybase.allow = "always";
        pull.rebase = "true";
        push.default = "current";
        github.user = "Renzobc";
      };
    };

    home.packages = with pkgs; [
      (python3.withPackages (ps:
        with ps; [
          # (numpy.overridePythonAttrs (oldAttrs: { version = "1.23.5"; }))
          (matplotlib.overridePythonAttrs (oldAttrs: {version = "3.6.2";}))
          # (pillow.overridePythonAttrs (oldAttrs: { version = "9.2.0"; }))
          (scikit-learn.overridePythonAttrs (oldAttrs: {version = "1.1.3";}))
          # (pytorch.overridePythonAttrs (oldAttrs: { version = "2.4.0"; }))
          # (torchaudio.overridePythonAttrs (oldAttrs: { version = "2.4.0"; }))
          # (torchvision.overridePythonAttrs (oldAttrs: { version = "0.19.0"; }))
        ]))
    ];
  };
}
