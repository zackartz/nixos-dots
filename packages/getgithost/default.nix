{writeShellScriptBin, ...}:
writeShellScriptBin "getgithost" ''
  IFS="/"
  GIT_REMOTE=$(command git ls-remote --get-url 2> /dev/null)
  read -ra GIT_HOST <<< "$GIT_REMOTE"

  if [[ "$GIT_REMOTE" =~ "github" ]]; then
      GIT_REMOTE_SYMBOL=" "
  elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then
      GIT_REMOTE_SYMBOL=" "
  elif [[ "$GIT_REMOTE" =~ "bitbucket" ]]; then
      GIT_REMOTE_SYMBOL=" "
  elif [[ "$GIT_REMOTE" =~ "git" ]]; then
      GIT_REMOTE_SYMBOL=" "
  else
      GIT_REMOTE_SYMBOL=" localhost"
  fi

  echo "$GIT_REMOTE_SYMBOL''${GIT_HOST [2]}"
  IFS=" "
''
