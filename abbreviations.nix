{
  aliases = {
    # --------------------------------- #
    # Optimism things aliases
    # --------------------------------- #
    cdpb = "cd packages/contracts-bedrock";

    # --------------------------------- #
    # Foundry stuff
    # --------------------------------- #
    ft = "forge test";
    ftmt = "forge test -vvvv --match-test";
    ftmc = "forge test -vvvv --match-contract";
    fs = "forge snapshot";
    fb = "forge build";
    fd = "forge script scripts/deploy/Deploy.s.sol:Deploy -vvv";

    # run locally built foundry tools
    forgel = "~/Projects/Tools/foundry/target/debug/forge";
    castl = "~/Projects/Tools/foundry/target/debug/cast";
    anvill = "~/Projects/Tools/foundry/target/debug/anvil";
    chisell = "~/Projects/Tools/foundry/target/debug/chisel";

    # misc utils
    rpu = "source ~/.rpc-urls";
    secret = "source ~/.secrets";
    was = "which -as";
    brewup = "brew update && brew upgrade";
    nv = "nvim";
    f = "forge";
    prurl = "gh pv --json url -q .url | pbc";

    # Git stuff
    g = "git status";
    glog = "git log --oneline --decorate --graph";
    glv = "git log";
    glob = "glog --pretty=format:\"$_git_log_brief_format\"";
    gl = "glob";
    gcn = "git commit --amend --no-edit";
    gcan = "git commit --all --amend --no-edit";
    gcp = "git cherry-pick";
    gors = "git restore --staged";
    gor = "git restore";
    gbc = "git branch --show-current";
    gbM = "git branch --merged | egrep -v \"(^\\*|master|main|dev)\"";
    gbl = "git describe --all $(git rev-parse @{-1})";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m \"--wip--\"";
    gwS = "git status --ignore-submodules=$_git_status_ignore_submodules --show-stash";
    gRS = "git submodule foreach --recursive git reset --hard";
    gq = "git show --quiet";
    gcs = "git show";
    gcss = "git show --stat";
    gci = "git check-ignore -v *";
    gsamscp = "git am --show-current-patch";
    gmain = "git branch | grep -o -m1 \"\\b\\(master\\|main\\)\\b\"";
    gmbl = "git rev-parse --abbrev-ref HEAD";
    gmbr = "git rev-parse --abbrev-ref origin/HEAD";
    gf = "git fetch";
    gcod = "gco develop";
    gnote = "git branch --edit-description";
    gread = "git config \"branch.$(git-branch-current).description\"";
    gwk = "git worktree";
    gwkl = "git worktree list";
    gch = "git rev-parse HEAD";
    gia = "git add --all";
    giu = "git add --update";
    gtst = "gt pr --stack";
    beep = "osascript -e 'display notification \"beep\" with title \"BEEP\"'";
    beep2 = "echo \"ring a bell\"";
    dsf = "diff-so-fancy";

    # get common strings
    b20 = "echo 0x0000000000000000000000000000000000000000";
    b32 = "echo 0x0000000000000000000000000000000000000000000000000000000000000000";
    lg = "lazygit --ucd ~/.config/lazygit/";
    gdd = "git restore --worktree -- $(git rev-parse --show-toplevel) && git restore --staged -- $(git rev-parse --show-toplevel) && git clean -fd -- $(git rev-parse --show-toplevel)";
  };

  abbreviations = {
    srf = "source ~/.config/fish/config.fish";
    hm = "home-manager switch --flake $HOME/.config/nix#maurelian";
    gp = "git push origin $gcur";
    gpf = "git push --force-with-lease origin $gcur";
    grd = "gf && git rebase -i $gmbr";
    grr = "gf && gco $gmbl && git reset --hard $gmbr";
    grt = "gf && git reset --hard $gcuru";

    gcur = "git branch --show-current";
    gcuru = "git rev-parse --abbrev-ref @{upstream}";
    gdau = "git diff $gcuru $gcur";
    gfo = "git fetch origin";
    gfodd = "gfo develop:develop";
    grmain = "git rebase $gmain";
    gfm = "git pull ";
    gfmoc = "git pull origin";
    gfmod = "git pull origin develop:develop";
    gfmom = "gfo $gmain:$gmain";
    gfdr = "gfmod && git rebase develop";
    gfmr = "gfmom && git rebase $gmain";
    gbsu = "git branch --set-upstream-to=origin/$gcur $gcur";
    gifl = "git status -s | sed \"$1q;d\" | cut -c4-";
  };

  functions = {
      glau = ''
        set -l upstream (git rev-parse --abbrev-ref @{upstream})
        echo "upstream: $upstream"
        set -l current (git rev-parse --abbrev-ref HEAD)
        echo "current: $current"
        glog $upstream $current
      '';
      ff = "find . -iname \"*$argv[1]*\" $argv[2..-1]";
      cw = ''
          # get the path passed in
          set DIR $argv[1]
          set GITDIR (git rev-parse --show-toplevel | string collect; or echo)
          # If something was passed in, open it
          if test -n "$DIR"
            echo 'opening directory '"$DIR"
            $EDITOR -n $DIR
          else if test -n "$GITDIR"
            # if nothing was passed in, see if we're in a git repo
            echo 'opening git repo in '"$GITDIR"', on branch '(git branch --show-current | string collect; or echo)
            $EDITOR -n $GITDIR
          else
            # if we're not in a git repo, set DIR to cwd
            $EDITOR -n (pwd)
          end
        '';
      viewci = ''
        set -l branch (git rev-parse --abbrev-ref HEAD | string collect; or echo)
        set -l repo (gh repo view --json owner,name | jq -r .name | string collect; or echo)
        set -l org (gh repo view --json owner,name | jq -r .owner.login | string collect; or echo)
        open 'https://app.circleci.com/pipelines/github/'"$org"'/'"$repo"'?branch='(string replace '/' '%2F' "$branch")
      '';
    };
}
