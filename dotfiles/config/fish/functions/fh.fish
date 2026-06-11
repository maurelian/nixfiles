function fh
    history merge # Merge history from all active sessions
    set cmd (history | fzf --tac --no-sort --height 40% --layout=reverse --border --inline-info --query=(commandline))
    if test $status -eq 0
        commandline $cmd
    end
    commandline -f repaint
end
