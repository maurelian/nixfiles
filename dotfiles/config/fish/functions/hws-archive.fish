function hws-archive --description 'Archive the current herdr space to JSON and close it'
    set -l ws (hws); or return 1
    ~/.config/herdr/hws-archive.py archive $argv $ws
end
