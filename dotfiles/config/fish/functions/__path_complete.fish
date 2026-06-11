function __path_complete
    set -l tokens (commandline -poc)
    set -l current_token (commandline -t)

    # Get all directories from CDPATH
    set -l dirs
    set -l descriptions

    # Add current directory contents first
    for entry in ./*
        if test -d $entry -o -f $entry
            set -a dirs (realpath $entry)
            set -a descriptions (basename $entry)
        end
    end

    # Then add CDPATH entries
    for cdpath in $CDPATH
        if test -d $cdpath
            for dir in $cdpath/*/
                set -l full_path (realpath $dir)
                set -l base (basename $dir)
                if string match -q "$current_token*" $base
                    set -a dirs $full_path
                    set -a descriptions $base
                end
            end
        end
    end

    # Output in the format that fish completion expects:
    # full_path\tdescription
    for i in (seq (count $dirs))
        # Only show entries matching current token
        if string match -q "$current_token*" $descriptions[$i]
            printf "%s\t%s\n" $dirs[$i] $descriptions[$i]
        end
    end
end
