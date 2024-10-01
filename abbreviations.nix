{
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
  hm = "home-manager switch --flake $HOME/.config/nix#maurelian";
  lg = "lazygit --ucd ~/.config/lazygit/";
  rpu = "source ~/.rpc-urls";
  secret = "source ~/.secrets";
  was = "which -as";
  brewup = "brew update && brew upgrade";
  nv = "nvim";
  f = "forge";
  prurl = "gh pv --json url -q .url | pbc";



# --------------------------------- #
#  Git stuff #
# --------------------------------- #
  gt = "/opt/homebrew/bin/gt";
  # git log..
  glog = "git log --oneline --decorate --graph";
  glv = "git log"; # verbose logging
  glob = "glog  --pretty=format:\"$_git_log_brief_format\"";
  gl = "glob"; # preferred log

  # git commit
  gcn = "git commit --amend --no-edit";
  gcan = "git commit --all --amend --no-edit";
  # git cherry-pick
  gcp = "git cherry-pick";

  # git restore
  gors = "git restore --staged";
  gor = "git restore";

  #  branch management
  gbc = "git branch --show-current";
  gbM = "git branch --merged | egrep -v \"(^\\*|master|main|dev)\"";
  gbl = "git describe --all $(git rev-parse @{-1})";

  # quickly create a WIP commit
  gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m \"--wip--\"";

  # other git
  gwS = "git status --ignore-submodules=$_git_status_ignore_submodules --show-stash";
  gRS = "git submodule foreach --recursive git reset --hard";

  # this overrides g='git', but I wasn't using it anyways.
  g = "gws";
  gq = "git show --quiet";
  gcss = "git show --stat";
  gci = "git check-ignore -v *";
  gsamscp = "git am --show-current-patch";

  # branch aliases
  gmain = "git branch | grep -o -m1 \"\\b\\(master\\|main\\)\\b\""; # print main or master
  gmbl = "git rev-parse --abbrev-ref HEAD";                  # print main branch local
  gmbr = "git rev-parse --abbrev-ref origin/HEAD";           # print main branch remote
  gcur = "git branch --show-current";
  gcuru = "git rev-parse --abbrev-ref $gcur@{u}";

  # inspired by Kelvins stuff
  gf = "git fetch";
  gp = "git push origin $(gcur)";
  gpf = "git push -f origin $(gcur)";
  grd = "gf && git rebase -i $(gmbr)";
  grr = "gf && gco $(gmbl) && git reset --hard $(gmbr)"; #  change to the primary branch, wipe all changes, and match the remote
  grt = "gf && git reset --hard $(gcuru)";               #  wipe all changes, and match the remote branch
  glau = "glog `gcuru` `gcur`";                          # git log current branch against upstream

  gfo = "git fetch origin";
  gfodd = "gfo develop:develop"; # get changes from origin into develop without switching branches
  grmain = "git rebase `gmain`";
  # grd = "git rebase develop";

  gfmoc = "git pull origin";
  gfmod = "git pull origin develop:develop";
  gfmom = "gfo `gmain`:`gmain`"; # get changes from origin into main/master without switching branches

  # pull and rebase on the main branch
  gfdr = "gfmod && git rebase develop";
  gfmr = "gfmom && git rebase `gmain`";

  gbsu = "git branch --set-upstream-to=origin/$(gcur) $(gcur)";
  gifl = "git status -s | sed \"$1q;d\" | cut -c4-"; # list files in the index that are different from the HEAD commit
  gcod = "gco develop";

  # git notes (but not actually using `git note`)
  gnote = "git branch --edit-description";
  gread = "git config \"branch.$(git-branch-current).description\"";

  # git worktree aliases
  gwk = "git worktree";
  gwkl = "git worktree list";

  gdau = "git diff `gcuru` `gcur`";
  gch = "git rev-parse HEAD";
  nu = "nvm use";
  gtst = "gt pr --stack";
  beep = "osascript -e 'display notification \"beep\" with title \"BEEP\"'";
  beep2 = "echo \"ring a bell\"";
  dsf = "diff-so-fancy";

  # get common strings
  b20 = "echo 0x0000000000000000000000000000000000000000";
  b32 = "echo 0x0000000000000000000000000000000000000000000000000000000000000000";
}
