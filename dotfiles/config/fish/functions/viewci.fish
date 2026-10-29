function viewci
    set -l branch (git rev-parse --abbrev-ref HEAD | string collect; or echo)
    set -l repo (gh repo view --json owner,name | jq -r .name | string collect; or echo)
    set -l org (gh repo view --json owner,name | jq -r .owner.login | string collect; or echo)
    set -l url "https://app.circleci.com/pipelines/github/$org/$repo?branch=$branch"
    echo "Opening $url"
    open "$url"
end
