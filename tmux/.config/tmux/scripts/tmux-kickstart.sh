#!/usr/bin/env bash
# Mikey Garcia, @gikeymarcia
# Kickstart customized tmux

set -e
set -u

GITHUB=https://github.com/tmux-plugins/tpm
TPM="$HOME/.config/tmux/plugins/tpm"
OLD_CONFIG="$HOME/.tmux.conf"

[[ -f $OLD_CONFIG ]] && mv "$OLD_CONFIG" "${OLD_CONFIG}.bak"
git clone $GITHUB "$TPM"                # grab tmux plugin manager
tmux new-session -d -s kickstart        # launch tmux in background
tmux source ~/.config/tmux/tmux.conf    # load tmux config

"$TPM/bin/install_plugins"              # Install tmux plugins

echo " - - - - - INSTALLED PLUGINS - - - - - "
ls -l "$TPM/plugins"
