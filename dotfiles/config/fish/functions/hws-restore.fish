function hws-restore --description 'Pick an archived herdr space and rebuild it here'
    set -l pick (~/.config/herdr/hws-archive.py list | fzf --delimiter '\t' --with-nth 2.. --query "$argv" --select-1 --exit-0)
    or return 1
    ~/.config/herdr/hws-archive.py restore (string split -f1 \t -- $pick)
end
