function hws --description 'Print the current herdr workspace id'
    if set -q HERDR_WORKSPACE_ID
        echo $HERDR_WORKSPACE_ID
    else
        _h_id workspace_id
    end
end
