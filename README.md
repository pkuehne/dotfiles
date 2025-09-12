# Dotfiles (Nix + Home Manager)

This repo defines my user environment via [Home
Manager](https://nix-community.github.io/home-manager/).\
It works on Ubuntu (WSL2) with flakes enabled.

------------------------------------------------------------------------

## Quickstart (new machine)

1.  **Install Nix** (multi-user, with flakes):

    ``` bash
    sh <(curl -L https://nixos.org/nix/install) --daemon
    echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
    ```

2.  **Clone repo into Home Manager config dir**:

    ``` bash
    git clone https://github.com/<your-username>/dotfiles-flake.git ~/.config/home-manager
    cd ~/.config/home-manager
    ```

3.  **Activate** (choose profile):

    ``` bash
    home-manager switch --flake .#home
    # or
    home-manager switch --flake .#work
    ```

4.  **Set Zsh as login shell**:

    ``` bash
    chsh -s "$HOME/.nix-profile/bin/zsh"
    ```

5.  **Restart WSL / shell**:

    ``` bash
    exec zsh -l
    ```

------------------------------------------------------------------------

## Layout

    flake.nix        # Entrypoint, defines profiles (home, work)
    flake.lock       # Version pins (commit to repo!)
    modules/
      common.nix     # Shared config (packages, basics)
      zsh.nix        # Zsh setup (plugins, aliases)
      p10k.nix       # Powerlevel10k config (theme, prompt)
      work.nix       # Work-only overrides (no secrets!)

------------------------------------------------------------------------

## Notes

-   **Secrets** are *not* in this repo (`.ssh/config`, proxies, corp
    repos, etc.).\
-   Profiles:
    -   `home` = personal config\
    -   `work` = minimal safe config for corp machines\
-   **Fonts**: use a Nerd Font (e.g. *MesloLGS NF*) in your terminal for
    Powerlevel10k glyphs.\
-   **Garbage collection**: Nix GC won't break Zsh; we source from
    `~/.nix-profile`.

------------------------------------------------------------------------

## Updating

Update inputs (nixpkgs, home-manager):

``` bash
nix flake update
home-manager switch --flake .#home
```

------------------------------------------------------------------------

## Troubleshooting

-   If `home-manager` command is missing:

    ``` bash
    nix run github:nix-community/home-manager/release-<version> -- switch --flake .#home
    ```

-   If Zsh doesn't start automatically in WSL, set the shell in Windows
    Terminal profile:

        Command line: wsl.exe -d <DistroName> -- zsh

