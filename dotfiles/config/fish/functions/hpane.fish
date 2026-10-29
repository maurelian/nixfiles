function hpane --description 'Print the current herdr pane id'
    if set -q HERDR_PANE_ID
        echo $HERDR_PANE_ID
    else
        _h_id pane_id
    end
end
