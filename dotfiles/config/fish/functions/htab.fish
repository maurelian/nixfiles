function htab --description 'Print the current herdr tab id'
    if set -q HERDR_TAB_ID
        echo $HERDR_TAB_ID
    else
        _h_id tab_id
    end
end
