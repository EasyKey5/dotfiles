#!/bin/bash
# Mikey Garcia, @gikeymarcia
# fzf selector to attach-to/create tmux sessions
# dependencies: fzf tmux
# https://www.arp242.net/tmux.html

sessions="$(tmux ls -F '#S#{?session_attached,@,}' 2> /dev/null)"
[[ -z $sessions ]] && echo "no sessions."

# custom preview formatting
regex_home="${HOME//\//.}"      # replace forward slash '.'
Frmt="#I#{?window_active,*,#{?window_last_flag,-, }} (#{window_panes})#W  #{s/^$regex_home/~/r:pane_current_path}"
fzf_preview="echo {} | sed 's/@$//' | xargs -r tmux list-windows -F '$Frmt' -t"
# custom $TERM to support tmux + vim + italics

# choose your tmux session
selector=$(echo "$sessions" |
    fzf --no-multi -i --reverse --print-query \
    --border --height=75% --inline-info --margin 5%,5%,5%,0% \
    --prompt="Which tmux session? " \
    --preview="$fzf_preview" |
    sed 's|@$||')

# logic to determine script behavior
[[ -z $selector ]] && echo "selection cancelled." && exit
if [[ $(printf '%s\n' "$selector" | wc -l) -eq 2 ]]; then
    target="$(printf '%s\n' "$selector" | tail -n1)"

    # attach to an existing session
    printf "$  %s\n" "tmux attach -t $target"

    if [[ -z $TMUX ]]; then
        tmux attach -t "$target"
    else
        tmux switch-client -t "$target"
    fi
else
    # create new session
    target="$selector"
    [[ -z $target ]] && echo "selection cancelled!" && exit
    printf "$  %s\n" "tmux new-session -s ${target}"
    if [[ -z $TMUX ]]; then
        tmux new-session -s "${target}"
    else
        tmux new-session -d -s "${target}"
        tmux switch-client -t "${target}"
    fi
fi
