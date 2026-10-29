function fix-ssh-agent --description 'Point SSH_AUTH_SOCK at the live launchd ssh-agent'
    # Long-lived parents (herdr, tmux) keep the SSH_AUTH_SOCK they started with,
    # but macOS moves the socket whenever launchd restarts ssh-agent (e.g. on update).
    ssh-add -l >/dev/null 2>&1
    test $status -ne 2; and return 0
    set -l sock (launchctl print gui/(id -u)/com.openssh.ssh-agent 2>/dev/null | string match -rg 'path = (/\S+/Listeners)')[1]
    if test -z "$sock"
        echo "fix-ssh-agent: no launchd ssh-agent socket found" >&2
        return 1
    end
    set -gx SSH_AUTH_SOCK $sock
end
