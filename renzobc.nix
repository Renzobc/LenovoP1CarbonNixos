{pkgs, ...}: {
  home-manager.users.renzobc = {
    home = {
      username = "renzobc";
      stateVersion = "24.05";
      homeDirectory = "/home/renzobc";
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
        core.editor = "vscode";
        color.ui = "auto";
        #credential.helper = "store --file ~/.git-credentials";
        format.signoff = true;
        commit.gpgsign = true;
        tag.gpgSign = true;
        gpg.format = "ssh";
        user.signingkey = "/home/renzobc/.ssh/id_ed25519.pub";
        # gpg.ssh.allowedSignersFile = "/home/renzobc/.ssh/allowed_signers";
        init.defaultBranch = "main";
        #protocol.keybase.allow = "always";
        pull.rebase = "true";
        push.default = "current";
        github.user = "Renzobc";
      };
    };
  };
}
