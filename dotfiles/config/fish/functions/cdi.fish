function cdi
    set -l dir (z -l | sort -rn | sed 's/^[0-9.]* *//' | peco --prompt "Choose directory: ")
    if test -n "$dir"
        cd $dir
    end
end
