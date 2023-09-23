{
  programs.thunderbird = {
    enable = true;
    profiles.stephen = {
      isDefault = true;
      settings = {
        mail.biff.play_sound = false;
        mail.e2ee.auto_disable = true;
        mail.e2ee.auto_enable = true;
        mail.uifontsize = 14;
        mailnews.start_page.enabled = false;
        network.cookie.cookieBehavior = 1;
      };
    };
  };

  services.protonmail-bridge = {
    enable = true;
    nonInteractive = true;
  };
}
