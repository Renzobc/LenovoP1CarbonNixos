{pkgs, ...}:
pkgs.buildGoModule rec {
  name = "dronesole";
  pname = "dronesole";
  # version = "1.0.0";

  src = builtins.fetchGit {
    rev = "145d380bc189b42f981eb89c9c76bb21f7150640";
    url = "git@github.com:tiiuae/dronsole.git";
    ref = "main";
  };

  vendorHash = pkgs.lib.fakeHash;  # If you have a vendor directory, provide the hash here



  subPackages = [ "main.go" ];
    # Ensure Go is available for go mod vendor
  nativeBuildInputs = [ pkgs.go pkgs.git pkgs.openssh];

  # GO111MODULE = "on";
  # GIT_SSH_COMMAND = "ssh -i /home/renzo/.ssh/id_ed25519.pub";  # Use your actual SSH key path

  # Sync the vendor directory before the build
  preBuild = ''
    export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
    export GOPROXY=https://proxy.golang.org,direct
    export GOSUMDB=off
    export GOPRIVATE=github.com/tiiuae
  '';


  postBuild = ''
    echo "Building custom derivation...${name} ${pname}"
  '';

  installPhase = ''
    go mod tidy
    go mod vendor
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