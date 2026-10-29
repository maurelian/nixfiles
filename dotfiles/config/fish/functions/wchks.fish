function wchks
    set -l NUMBER (gh pr view --json number --jq .number)
    set -l FAIL_MATCH fail
    set -l SUCCESS_MATCH "All\ checks\ were\ successful"
    watch --chgexit "gh pr checks $NUMBER | grep -E  -e $FAIL_MATCH -e $SUCCESS_MATCH" \
        && echo "ring a bell" \
        && gh pr checks $NUMBER
end
