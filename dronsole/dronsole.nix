{pkgs, ...}:
pkgs.buildGoModule rec {
  name = "dronesole";
  pname = "dronesole";
  # version = "1.0.0";

  # services.ssh-agent = {
  #   enable = true;
  #   addKeys = [ "/home/renzo/.ssh/id_lenovo" ];
  # };

  src = builtins.fetchGit {
    rev = "145d380bc189b42f981eb89c9c76bb21f7150640";
    url = "git@github.com:tiiuae/dronsole.git";
    ref = "main";
  };

  vendorHash = pkgs.lib.fakeHash; # If you have a vendor directory, provide the hash here

  subPackages = ["main.go"];
  # Ensure Go is available for go mod vendor
  nativeBuildInputs = [pkgs.go pkgs.git pkgs.openssh];

  shellHook = ''
    eval $(ssh-agent -s)
    ssh-add /home/renzo/.ssh/id_lenovo
    git config --global url."git@github.com:".insteadOf "https://github.com/"
  '';

  # GO111MODULE = "on";
  # GIT_SSH_COMMAND = "ssh -i /home/renzo/.ssh/id_ed25519.pub";  # Use your actual SSH key path

  # Sync the vendor directory before the build
  preBuild = ''
    # export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
    export GOPROXY=https://proxy.golang.org,direct
    export GOSUMDB=off
    export GIT_SSH_COMMAND="ssh -i /home/renzo/.ssh/id_lenovo.pub -o IdentitiesOnly=yes"
    export GOPRIVATE="github.com/tiiuae/*"
    # export GOFLAGS="-mod=vendor"
    go mod tidy
    go mod vendor
  '';

  # Custom build script
  # buildPhase = ''
  #   # Configure Git to use SSH for private repositories
  #   git config --global url."git@github.com:".insteadOf "https://github.com/"

  #   # Fetch and build the Go module
  #   go mod vendor
  # '';

  postBuild = ''
    echo "Building custom derivation...${name} ${pname}"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $GOPATH/bin/main $out/bin/dronsole
  '';

  meta = with pkgs.lib; {
    description = "dronsole";
    license = licenses.mit;
    # Remove or update this line
    platforms = platforms.linux;
  };
}
