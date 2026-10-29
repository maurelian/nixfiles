function nw
    complete -c nw -f
    complete -c nw -a '(__path_complete)'
    set -l L_EDITOR (which nvim)
    # get the path passed in
    set DIR $argv[1]
    set GITDIR (git rev-parse --show-toplevel | string collect; or echo)
    # If something was passed in, open it
    if test -n "$DIR"
        echo 'opening directory '"$DIR"
        $L_EDITOR -n $DIR
    else if test -n "$GITDIR"
        # if nothing was passed in, see if we're in a git repo
        echo 'opening git repo in '"$GITDIR"', on branch '(git branch --show-current | string collect; or echo)
        $L_EDITOR -n $GITDIR
    else
        # if we're not in a git repo, set DIR to cwd
        $L_EDITOR -n (pwd)
    end
end
