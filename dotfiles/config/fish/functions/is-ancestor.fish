function is-ancestor
    # Usage: is-ancestor <ancestor> [descendant]
    # Check if <ancestor> is in the history of <descendant> (default: HEAD)

    if test (count $argv) -lt 1
        echo "Usage: is-ancestor <ancestor> [descendant]"
        echo "Check if <ancestor> is in the history of <descendant> (default: HEAD)"
        echo ""
        echo "Examples:"
        echo "  is-ancestor main              # Check if main is an ancestor of HEAD"
        echo "  is-ancestor abc123 feature    # Check if abc123 is an ancestor of feature"
        echo "  is-ancestor origin/main HEAD  # Check if origin/main is an ancestor of HEAD"
        return 1
    end

    set -l ancestor $argv[1]
    set -l descendant HEAD
    if test (count $argv) -ge 2
        set descendant $argv[2]
    end

    # Resolve to actual commit hashes
    set -l ancestor_hash (git rev-parse --verify "$ancestor" 2>/dev/null)
    if test $status -ne 0
        echo "Error: Could not resolve '$ancestor' to a commit"
        return 1
    end

    set -l descendant_hash (git rev-parse --verify "$descendant" 2>/dev/null)
    if test $status -ne 0
        echo "Error: Could not resolve '$descendant' to a commit"
        return 1
    end

    # Get short hashes and references for display
    set -l ancestor_short (git rev-parse --short "$ancestor_hash")
    set -l descendant_short (git rev-parse --short "$descendant_hash")

    # Check if ancestor is the same as descendant
    if test "$ancestor_hash" = "$descendant_hash"
        set_color green
        echo "✓ '$ancestor' ($ancestor_short) is the same as '$descendant'"
        set_color normal
        return 0
    end

    # Use git merge-base --is-ancestor for the check
    if git merge-base --is-ancestor "$ancestor_hash" "$descendant_hash" 2>/dev/null
        set_color green
        echo "✓ '$ancestor' ($ancestor_short) is an ancestor of '$descendant' ($descendant_short)"
        set_color normal
        return 0
    else
        set_color red
        echo "✗ '$ancestor' ($ancestor_short) is NOT an ancestor of '$descendant' ($descendant_short)"
        set_color normal
        return 1
    end
end
