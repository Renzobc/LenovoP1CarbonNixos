{pkgs, ...}: let
  # fog-hyper = import ./fog-hyper/fog-hyper.nix {inherit pkgs;};
  # dronsole = import ./dronsole/dronsole.nix {inherit pkgs;};

in {
  home-manager.users.renzo = {
    home = {
      username = "renzo";
      stateVersion = "24.05";
      homeDirectory = "/home/renzo";
    };

    programs.git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Renzo Bruzzone";
      userEmail = "renzo.bruzzone@tii.ae";
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
        user.signingkey = "/home/renzo/.ssh/id_ed25519.pub";
        gpg.ssh.allowedSignersFile = "/home/renzo/.ssh/allowed_signers";
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
  };
}
