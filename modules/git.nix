{ config, ... }: {
  home = {
    file = {
      ".gitignore_global" = {
        text = ''
          tags
          Session.vim
        '';
      };
      ".ssh/allowed_signers" = {
        text = ''
          * ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+6xGZK4EH3BVqLq/wz+WBtLo3XRPVzQZ716xoCE/FCewpmDe1L9HDgklmYMMnNsCcKs0Lbdd9Nw2Z2j9EQw5YJKPmAQBwX86RIGqFM5H++Byj0SXU382N27Nyd2UtDiNkIu52pyd90KGP3/LXJ3OT0H8c+7caWOrrblg0XT8D150ReOZUmbNfHup8tfvaEbcKK/TWB3KiBqbhjl2aO+qj3zAxhz3DyV9SlOFPwWoUFTaeDDyfuCV8PT8INJ1F+7lQIdSR5gEcTMdmeEq5aIWafu8hOk1cB1O+68SrqLj9u8N1GP2sHoY7gYtmG7XpZtGKKd67P61p0AueYccSrKub
        '';
      };
    };
  };

  programs.git = {
    enable = true;

    userName = "Peter Kuehne";
    userEmail = "peter.kuehne@gmail.com";

    signing = {
      key = "${config.home.homeDirectory}/.ssh/github_rsa.pub";
      signByDefault = true;
    };

    aliases = {
      logdog = "log --decorate --oneline --graph";
      logdogs = "log --decorate --oneline --graph --simplify-by-decoration";
      d = "difftool";
    };

    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        autocrlf = "input";
      };

      color.ui = true;

      diff.tool = "vimdiff";
      difftool.prompt = false;

      init.defaultBranch = "main";
      push.default = "current";
      pull.rebase = false;

      gpg.format = "ssh";
      "gpg \"ssh\"".allowedSignersFile =
        "${config.home.homeDirectory}/.ssh/allowed_signers";

      credential.helper = "store";

      http.sslCAInfo = "/etc/ssl/certs/ca-certificates.crt";
    };
  };

}

