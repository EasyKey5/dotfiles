#!/usr/bin/env bash
# Mikey Garcia, @gikeymarcia
# update tmux plugins

set -e
set -u

TPM="$HOME/.config/tmux/plugins/tpm"

"$TPM/bin/update_plugins all"
