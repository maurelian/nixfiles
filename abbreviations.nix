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
    glob = "glog --pretty=format:$_git_log_brief_format";
    gl = "glob";
    gcn = "git commit --amend --no-edit";
    gce = "git commit --amend";
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

    gs = "git stash";
    gsp = "git stash pop";
    gdd = "git restore --worktree -- $(git rev-parse --show-toplevel) && git restore --staged -- $(git rev-parse --show-toplevel) && git clean -fd -- $(git rev-parse --show-toplevel)";
  };

  abbreviations = {
    g = "git status";
    gcs = "git show";
    gcss = "git show --stat";
    gp = "git push origin $gcur";
    gpf = "git push --force-with-lease origin $gcur";
    grd = "git fetch && git rebase -i $gmbr";
    grr = "git fetch && gco $gmbl && git reset --hard $gmbr";
    grt = "git fetch && git reset --hard $gcuru";

    gcur = "git branch --show-current";
    gcuru = "git rev-parse --abbrev-ref @{upstream}";
    gfo = "git fetch origin";
    gfodd = "git fetch origin develop:develop";
    grmain = "git rebase $gmain";
    gfm = "git pull ";
    gfmoc = "git pull origin";
    gfmod = "git pull origin develop:develop";
    gfmom = "git fetch origin $gmain:$gmain";
    gfdr = "git pull origin develop:develop && git rebase develop";
    gfmr = "git fetch origin $gmain:$gmain && git rebase $gmain";
    gbsu = "git branch --set-upstream-to=origin/$gcur $gcur";
    gifl = "git status -s | sed \"$1q;d\" | cut -c4-";

    lgl = "lg log";
    lgs = "lg status";
    lgd = "lg diff";
    lgb = "lg branch";

    srf = "source ~/.config/fish/config.fish";
    histm = "history merge";
    hm = "home-manager switch --flake $HOME/.config/nix#maurelian";
  };

  functions = {
      glau = ''
        set -l upstream (git rev-parse --abbrev-ref @{upstream})
        echo "upstream: $upstream"
        set -l current (git rev-parse --abbrev-ref HEAD)
        echo "current: $current"
        glog $upstream $current
      '';
      gdau = ''
        set -l upstream (git rev-parse --abbrev-ref @{upstream})
        echo "upstream: $upstream"
        set -l current (git rev-parse --abbrev-ref HEAD)
        echo "current: $current"
        git diff $upstream $current
      '';
      ff = "find . -iname \"*$argv[1]*\" $argv[2..-1]";
      cw = ''
          if test -z "$L_EDITOR"
              set L_EDITOR $EDITOR
          end
          set -l L_EDITOR (which nvim)
          # get the path passed in
          set DIR $argv[1]
          set GITDIR (git rev-parse --show-toplevel | string collect; or echo)
          # If something was passed in, open it
          if test -n "$DIR"
            echo 'opening directory '"$DIR"
            $L_EDITOR -n $DIR
          else if test -n "$GITDIR"
            # if nothing was passed in, see if we're in a git repo
            echo 'opening git repo in '"$GITDIR"', on branch '(git branch --show-current | string collect; or echo)
            $L_EDITOR -n $GITDIR
          else
            # if we're not in a git repo, set DIR to cwd
            $L_EDITOR -n (pwd)
          end
        '';
      nw = ''
        set -l L_EDITOR (which nvim)
        cw $argv[1]
      '';
      viewci = ''
        set -l branch (git rev-parse --abbrev-ref HEAD | string collect; or echo)
        set -l repo (gh repo view --json owner,name | jq -r .name | string collect; or echo)
        set -l org (gh repo view --json owner,name | jq -r .owner.login | string collect; or echo)
        set -l url "https://app.circleci.com/pipelines/github/$org/$repo?branch=$branch"
        echo "Opening $url"
        open "$url"
      '';
      cdrt = ''
        set GITDIR (git rev-parse --show-toplevel | string collect; or echo)
        if test -n "$GITDIR"
          # if not in a git repo, do nothing
          cd $GITDIR
        else
          echo 'not in a git repo'
        end
      '';
      cdi = ''
        set -l dir (z -l | sort -rn | sed 's/^[0-9.]* *//' | peco --prompt "Choose directory: ")
        if test -n "$dir"
            cd $dir
        end
      '';
      wchks = ''
        set -l NUMBER (gh pr view --json number --jq .number)
        set -l FAIL_MATCH "fail"
        set -l SUCCESS_MATCH "main.*pass"
        watch --chgexit  "gh pr checks $NUMBER | grep -E  -e $FAIL_MATCH -e $SUCCESS_MATCH" \
          && echo "ring a bell" \
          && gh pr checks $NUMBER
      '';
    fh = ''
      history merge  # Merge history from all active sessions
      set cmd (history | fzf --tac --no-sort --height 40% --layout=reverse --border --inline-info --query=(commandline))
      if test $status -eq 0
          commandline $cmd
      end
      commandline -f repaint
    '';
    cleanStash = ''
      set -l days $argv[1]
      if test -z "$days"
          set days 30
      end
      echo "Cleaning stash entries older than $days days..."
      git stash list | awk -v days=$days '$0 ~ /.*\((.*)\)/ {split($0,a,":"); split(a[1],b,"stash@{"); split(b[2],c,"}"); cmd="date -v-"days"d +%s"; cmd | getline cutoff; close(cmd); cmd="date -j -f \"%a %b %d %H:%M:%S %Y\" \""$0"\" +%s"; cmd | getline timestamp; close(cmd); if (timestamp < cutoff) {print "Dropping stash@{"c[1]"}"; system("git stash drop stash@{"c[1]"}")}}'
      echo "Stash cleaning complete."
      '';
    };

  aliases.gpftub = "git-push-fork-to-upstream-branch";
  abbreviations.nconf = "code ~/.config/nix";
}
