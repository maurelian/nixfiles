function cdrt
    set GITDIR (git rev-parse --show-toplevel | string collect; or echo)
    if test -n "$GITDIR"
        # if not in a git repo, do nothing
        cd $GITDIR
    else
        echo 'not in a git repo'
    end
end
