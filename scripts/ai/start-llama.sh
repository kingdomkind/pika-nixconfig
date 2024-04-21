ollama serve </dev/null &>/dev/null &
hyprctl dispatch exec 'kitty -o allow_remote_control=yes sh -c "ollama run llama3 && pkill ollama"'
