{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [ age ];
    file = {
      ".ssh/id_peter.pub" = {
        text =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAoiO7PsUBpSipuiU5uHlmGH3Ii3lCbSTHoZ8tbz+fX peter@peterkuehne.com";
      };
    };
  };

  age = {
    identityPaths = [ "${config.home.homeDirectory}/.config/age/keys.txt" ];
    secrets = {
      id_peter = {
        file = ../secrets/id_peter.age;
        path = "${config.home.homeDirectory}/.ssh/id_peter";
        mode = "0600";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraOptionOverrides = {
      user = "peter";
      IdentityFile = "~/.ssh/id_peter";
      # PreferredAuthentications = "publickey";
      CanonicalizeHostname = "yes";
      CanonicalizeMaxDots = "1";
      CanonicalDomains = "prod.homelab.peterkuehne.com";
      AddKeysToAgent = "yes";
      HashKnownHosts = "no";
      UserKnownHostsFile = " ~/.ssh/known_hosts";
    };
    matchBlocks = {
      "*.prod.homelab.peterkuehne.com" = {
        user = "peter";
        extraOptions = {
          GSSAPIAuthentication = "yes";
          GSSAPIDelegateCredentials = "yes";
          PreferredAuthentications = "gssapi-with-mic";
          VerifyHostKeyDNS = "ask";
          PubkeyAuthentication = "no";
          PasswordAuthentication = "no";
        };
      };
    };
  };
}
