{lib, ... }:
{
  services.gitea = {
    enable = true;
    database.type = "postgres";

    stateDir= "/mnt/0_5TB_internal_SSD/gitea";

    settings = {
    server = {
        HTTP_PORT = 8991;
    };
    service = {
        DISABLE_REGISTRATION = true;
    };
    };
};
}
