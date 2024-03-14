{ config, lib, ... }:

let
  cfg = config.modules.system.locale;

  nospace = str:
    builtins.filter (c: c == " ") (lib.stringToCharacters str) == [ ];
  timezone = lib.types.nullOr (lib.types.addCheck lib.types.str nospace) // {
    description = "null or string without spaces";
  };
in {
  options.modules.system.locale = {
    time = {
      timeZone = lib.mkOption {
        type = timezone;
        default = null;
        example = "America/New_York";
        description = "The time zone used when displaying time and dates.";
      };
      automatic-timezoned = {
        enable = lib.mkEnableOption ''
          Whether to enable automatic-timezoned to keep the timezone up-to-date 
          based on the current location.
        '';
      };
    };

    i18n = {
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "The default locale used for the system.";
      };

      supportedLocales = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "en_US.UTF-8/UTF-8" ];
        description = "The list of locales supported by the system.";
      };
    };
  };

  config = {
    time.timeZone = lib.mkDefault cfg.time.timeZone;

    i18n = {
      defaultLocale = lib.mkDefault cfg.i18n.defaultLocale;
      supportedLocales = lib.mkDefault cfg.i18n.supportedLocales;
    };

    services.automatic-timezoned.enable = cfg.time.automatic-timezoned.enable;
  };
}
