{ lib, den, ... }:
{
  den.schema.host = {
    imports = [ den.lib.strict ];

    options.role = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "server"
      ];
    };
  };

  den.schema.user = {
    imports = [ den.lib.strict ];
  };

  den.schema.home = {
    imports = [ den.lib.strict ];
  };
}
