#!/bin/bash
# Mikey Garcia, @gikeymarcia
# Delete tmux buffers

LOG="$HOME/.var/$(basename "$0").log"
LOG_DIR="$(dirname "$LOG")"
[[ ! -d $LOG_DIR ]] && mkdir "$LOG_DIR"
date >> "$LOG"

selected=$(tmux list-buffers | fzf --prompt="which buffer do you want to delete? " | cut -d: -f1)

if [[ -n $selected ]]; then
    echo "$selected" | xargs -I{} echo tmux delete-buffer -b {} >> "$LOG"
    echo "$selected" | xargs -I{} tmux delete-buffer -b {}
else
    echo "Selection cancelled."
fi
