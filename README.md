# dotfiles

## Bootstrap

On a fresh machine, install dots and apply the dotfiles in one step:

```bash
curl -fsSL https://gitea.apps.peterkuehne.com/peter/dotfiles/raw/branch/main/bootstrap.sh | bash
```

This will:
1. Install the [dots](https://github.com/pkuehne/dots) dotfile manager via pip
2. Symlink all dotfiles from the repo into `~`
3. Install configured CLI tools
4. Clone zsh and tmux plugins

After bootstrap completes, reload the shell:

```bash
exec zsh
```

## Applying changes

Once the repo is cloned, use `just` to manage updates:

```bash
just run     # deploy symlinks
just tools   # install/update tools
just update  # pull latest and deploy
```
