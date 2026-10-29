function _h_id --description 'Print one id field for the current or focused herdr pane'
    herdr pane current 2>/dev/null | jq -er ".result.pane.$argv[1]" 2>/dev/null
    or begin
        echo "not in a herdr session" >&2
        return 1
    end
end
