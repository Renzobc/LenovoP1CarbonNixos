{pkgs, ...}:
pkgs.buildGoModule rec {
  name = "fog-hyper";
  pname = "fog";
  # version = "1.0.0";

  src = builtins.fetchGit {
    # owner = "tiiuae";
    # repo = "fog_hyper";
    rev = "9976d86d3916f352726e16b45a7c28caa98083f2";
    url = "git@github.com:tiiuae/fog_hyper.git";
    ref = "feature/manifest-and-secrets-from-container-registry";
    # fetchSubmodules = true;
    # hash = "sha256-2xSE5uJr52AFXKr2sv8cuo2D1za1tkUQN0XgQHf0RMk=";  # Replace with the actual sha256 hash
  };

  vendorHash = "sha256-2xSE5uJr52AFXKr2sv8cuo2D1za1tkUQN0XgQHf0RMk=";#pkgs.lib.fakeHash;  # If you have a vendor directory, provide the hash here

  # goPackagePath = "github.com/tiiuae/fog_hyper";
  # buildFlags = ["./cmd/fog/main.go"];

  subPackages = [ "cmd/fog/main.go" ];
    # Ensure Go is available for go mod vendor
  nativeBuildInputs = [ pkgs.go pkgs.git ];

  # Sync the vendor directory before the build
  preBuild = ''
    export GOPROXY=https://proxy.golang.org,direct
  '';

  postBuild = ''
    echo "Building custom derivation...${name} ${pname}"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $GOPATH/bin/main $out/bin/fog
    '';

  meta = with pkgs.lib; {
    description = "fog";
    license = licenses.mit;
    # Remove or update this line
    platforms = platforms.linux; 
  };
}