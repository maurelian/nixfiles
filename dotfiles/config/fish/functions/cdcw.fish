function cdcw
    complete -c cdcw -f
    complete -c cdcw -a '(__path_complete)'
    if test (count $argv) -lt 1
        echo "Usage: cdcw <directory>"
        return 1
    end
    set -l target $argv[1]
    set -l prev (pwd)
    # Use cd to leverage CDPATH resolution
    if not cd "$target"
        echo "cdcw: cannot cd to '$target'"
        return 1
    end
    cw
    cd "$prev"
end
