{
  config,
  lib,
  ...
}:
let
  cfg = config.clan-net.programs.docker;
in
{
  options.clan-net.programs.docker.enable = lib.mkEnableOption "docker";

  config = lib.mkIf cfg.enable {
    # lazydocker
    programs.lazydocker = {
      enable = true;
      settings = {
        commandTemplates = {
          dockerCompose = "docker compose";
        };
        customCommands.containers = [
          {
            name = "Bash";
            attach = true;
            command = "docker exec -it {{ .Container.ID }} bash";
            serviceNames = [ ];
          }
          {
            name = "Shell";
            attach = true;
            command = "docker exec -it {{ .Container.ID }} sh";
            serviceNames = [ ];
          }
        ];
      };
    };
    home.sessionVariables = {
      COMPOSE_BAKE = "true";
    };
  };
}
