function pk
    cast wallet dk $argv | awk '{print $NF}'
end
