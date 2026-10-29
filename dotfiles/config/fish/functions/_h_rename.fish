function _h_rename --description 'Rename a herdr object: <kind> <caller> <id> <label...>'
    set -l kind $argv[1]
    set -l caller $argv[2]
    set -l id $argv[3]
    set -l label (string join ' ' $argv[4..])
    if test -z "$id"
        return 1
    end
    if test -z "$label"
        echo "usage: $caller <label>" >&2
        return 1
    end
    set -l out (herdr $kind rename $id "$label" 2>&1)
    if string match -q '*"error"*' -- $out
        echo $out | jq -r '.error.message' 2>/dev/null; or echo $out
        return 1
    end
    echo "$kind $id -> $label"
end
