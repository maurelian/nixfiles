function glau
    set -l upstream (git rev-parse --abbrev-ref @{upstream})
    echo "upstream: $upstream"
    set -l current (git rev-parse --abbrev-ref HEAD)
    echo "current: $current"
    glog $upstream $current
end
