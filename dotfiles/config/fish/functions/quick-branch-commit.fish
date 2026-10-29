function quick-branch-commit
    set -l msg $argv
    set -l branch (string lower (string join '-' (string split ' ' $msg)))
    git checkout -b $branch
    git add .
    git commit -m "$msg"
end
