#! /bin/bash

# Run again when plugins have changed:
# {{ include "dot_tmux.conf.tmpl" | sha256sum }}
echo "-- Installing tmux plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins
