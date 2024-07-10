{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.git;
in {
  options.apps.tools.git = with types; {
    enable = mkBoolOpt false "Enable Git Integration";

    signByDefault = mkBoolOpt true "Sign by default";
    signingKey = mkStringOpt "5F873416BCF59F35" "The KeyID of your GPG signingKey";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [zsh-forgit gitflow];
    programs.git = {
      enable = true;
      userName = "zack";
      userEmail = "zackmyers@lavabit.com";
      ignores = [
        ".cache/"
        ".DS_Store"
        ".idea/"
        "*.swp"
        "*.elc"
        "auto-save-list"
        ".direnv/"
        "node_modules"
        "result"
        "result-*"
      ];
      signing = {
        key = cfg.signingKey;
        signByDefault = cfg.signByDefault;
      };
      extraConfig = {
        init = {defaultBranch = "main";};
        delta = {
          options.map-styles = "bold purple => syntax #ca9ee6, bold cyan => syntax #8caaee";
          line-numbers = true;
        };
        branch.autosetupmerge = "true";
        push.default = "current";
        merge.stat = "true";
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        repack.usedeltabaseoffset = "true";
        pull.ff = "only";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          autoupdate = true;
          enabled = true;
        };
      };
      lfs.enable = true;
      delta.enable = true;
      aliases = {
        essa = "push --force";
        co = "checkout";
        fuck = "commit --amend -m";
        c = "commit -m";
        ca = "commit -am";
        forgor = "commit --amend --no-edit";
        graph = "log --all --decorate --graph --oneline";
        oops = "checkout --";
        l = "log";
        r = "rebase";
        s = "status --short";
        ss = "status";
        d = "diff";
        ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        af = "!git add $(git ls-files -m -o --exclude-standard | sk -m)";
        st = "status";
        br = "branch";
        df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
        hist = ''
          log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
        llog = ''
          log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
        edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
      };
    };
  };
}
