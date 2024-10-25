{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    # Add any other Git-related configurations here
  };

  # Add the custom Git script
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "git-push-fork-to-upstream-branch";
      version = "1.0.0";
      src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/maurelian/git-push-fork-to-upstream-branch/master/git-push-fork-to-upstream-branch";
        sha256 = "sha256-rgkvv03NbG0jZprlkzAmhEp/ehs3mq9kyAoJOAu6YzU";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/git-push-fork-to-upstream-branch
        chmod 755 $out/bin/git-push-fork-to-upstream-branch
      '';
    })
  ];
}
