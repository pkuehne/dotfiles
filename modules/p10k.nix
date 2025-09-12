{ config, pkgs, ... }:
{
  home.file.".p10k.zsh".text = ''
    # Minimal, fast p10k with transient & instant prompt (Lean, two-line)
    # typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
    # typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)

    # typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    # typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
    # typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""

    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      # =========================[ Line #1 ]=========================
      os_icon                 # os identifier
      dir                     # current directory
      vcs                     # git status
      # =========================[ Line #2 ]=========================
      newline                 # \n
      prompt_char             # prompt symbol
    )
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      # =========================[ Line #1 ]=========================
      status                  # exit code of the last command
      command_execution_time  # duration of the last command
      background_jobs         # presence of background jobs
      direnv                  # direnv status (https://direnv.net/)
      asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
      virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
      anaconda                # conda environment (https://conda.io/)
      pyenv                   # python environment (https://github.com/pyenv/pyenv)
      goenv                   # go environment (https://github.com/syndbg/goenv)
      nodenv                  # node.js version from nodenv (https://github.com/nodenv/nodenv)
      nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
      nodeenv                 # node.js environment (https://github.com/ekalinin/nodeenv)
      # node_version          # node.js version
      # go_version            # go version (https://golang.org)
      # rust_version          # rustc version (https://www.rust-lang.org)
      # dotnet_version        # .NET version (https://dotnet.microsoft.com)
      # php_version           # php version (https://www.php.net/)
      # laravel_version       # laravel php framework version (https://laravel.com/)
      # java_version          # java version (https://www.java.com/)
      # package               # name@version from package.json (https://docs.npmjs.com/files/package.json)
      rbenv                   # ruby version from rbenv (https://github.com/rbenv/rbenv)
      rvm                     # ruby version from rvm (https://rvm.io)
      fvm                     # flutter version management (https://github.com/leoafarias/fvm)
      luaenv                  # lua version from luaenv (https://github.com/cehoffman/luaenv)
      jenv                    # java version from jenv (https://github.com/jenv/jenv)
      plenv                   # perl version from plenv (https://github.com/tokuhirom/plenv)
      perlbrew                # perl version from perlbrew (https://github.com/gugod/App-perlbrew)
      phpenv                  # php version from phpenv (https://github.com/phpenv/phpenv)
      scalaenv                # scala version from scalaenv (https://github.com/scalaenv/scalaenv)
      haskell_stack           # haskell version from stack (https://haskellstack.org/)
      kubecontext             # current kubernetes context (https://kubernetes.io/)
      terraform               # terraform workspace (https://www.terraform.io)
      # terraform_version     # terraform version (https://www.terraform.io)
      aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
      aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
      azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
      gcloud                  # google cloud cli account and project (https://cloud.google.com/)
      google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
      toolbox                 # toolbox name (https://github.com/containers/toolbox)
      context                 # user@hostname
      nordvpn                 # nordvpn connection status, linux only (https://nordvpn.com/)
      ranger                  # ranger shell (https://github.com/ranger/ranger)
      yazi                    # yazi shell (https://github.com/sxyazi/yazi)
      nnn                     # nnn shell (https://github.com/jarun/nnn)
      lf                      # lf shell (https://github.com/gokcehan/lf)
      xplr                    # xplr shell (https://github.com/sayanarijit/xplr)
      vim_shell               # vim shell indicator (:sh)
      midnight_commander      # midnight commander shell (https://midnight-commander.org/)
      nix_shell               # nix shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
      chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
      # vi_mode               # vi mode (you don't need this if you've enabled prompt_char)
      # vpn_ip                # virtual private network indicator
      # load                  # CPU load
      # disk_usage            # disk usage
      # ram                   # free RAM
      # swap                  # used swap
      todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
      timewarrior             # timewarrior tracking status (https://timewarrior.net/)
      taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
      per_directory_history   # Oh My Zsh per-directory-history local/global indicator
      # cpu_arch              # CPU architecture
      time                    # current time
      # =========================[ Line #2 ]=========================
      newline
      # ip                    # ip address and bandwidth usage for a specified network interface
      # public_ip             # public IP address
      # proxy                 # system-wide http/https/ftp proxy
      # battery               # internal battery
      # wifi                  # wifi speed
      # example               # example user-defined segment (see prompt_example function below)
    )
    typeset -g POWERLEVEL9K_MODE=nerdfont-v3
    typeset -g POWERLEVEL9K_ICON_PADDING=none
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%244F─╮'
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%244F─┤'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%244F─╯'

    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='─'
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=244
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'

    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'

    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=""
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=""
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

    typeset -g POWERLEVEL9K_DIR_SHORTEN_STRATEGY=truncate_to_last
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=1          # only one segment
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=               # disable markers
    typeset -g POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true             # don’t prepend …/

    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

    typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION=""
    typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SSH_CONTENT_EXPANSION="%n@%m"


    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  '';
}

