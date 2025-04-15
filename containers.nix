# Auto-generated using compose2nix v0.1.9.
{
  pkgs,
  lib,
  ...
}: {
  #######################################################################################
  # INSTALL DRONSOLE
  #######################################################################################
  # docker run --rm -it -v /usr/bin:/host --entrypoint= ghcr.io/tiiuae/tii-dronsole:main cp /bin/dronsole /host/
  #######################################################################################

  virtualisation.oci-containers.containers."dronsole" = {
    environment = {
      # POSTGRES_PASSWORD = "mealie";
      # POSTGRES_USER = "mealie";
    };
    image = "ghcr.io/tiiuae/tii-dronsole:latest";
    mounts = [
      {
        source = "/usr/bin";
        target = "/host";
        type = "bind";
        options = ["rw"];
      }
    ];
    # log-driver = "journald";
    extraOptions = [
      # "--health-cmd='[\"pg_isready\"]'"
      # "--health-interval=30s"
      # "--health-retries=3"
      # "--health-timeout=20s"
      # "--network-alias=postgres"
      # "--network=mealieio_default"
      # "--network=host"
    ];
    entrypoint = ["cp"];
    args = ["/bin/dronsole" "/host/"];
    autoRemove = true;
  };
}
