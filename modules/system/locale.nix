{ config, lib, ... }:
with lib;
let
  cfg = config.modules.system.locale;

  nospace = str: filter (c: c == " ") (stringToCharacters str) == [ ];
  timezone = types.nullOr (types.addCheck types.str nospace) // {
    description = "null or string without spaces";
  };
in {
  options.modules.system.locale = {
    time = {
      timeZone = mkOption {
        type = timezone;
        default = null;
        example = "America/New_York";
        description = "The time zone used when displaying time and dates.";
      };
    };

    i18n = {
      defaultLocale = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
        description = "The default locale used for the system.";
      };

      supportedLocales = mkOption {
        type = types.listOf types.str;
        default = [ "en_US.UTF-8/UTF-8" ];
        description = "The list of locales supported by the system.";
      };
    };
  };

  config = {
    time.timeZone = mkDefault cfg.time.timeZone;

    i18n = {
      defaultLocale = mkDefault cfg.i18n.defaultLocale;
      supportedLocales = mkDefault cfg.i18n.supportedLocales;
    };
  };
}
