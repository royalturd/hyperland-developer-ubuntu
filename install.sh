#!/bin/bash
# Everything is inside main() and only called on the last line, so when this
# file is piped into bash, nothing runs until the whole script has arrived and
# later commands can't swallow the rest of it from stdin.
set -e

main() {
  local REPO_URL="https://github.com/royalturd/hyperland-developer-ubuntu.git"
  local BRANCH="${BRANCH:-main}"
  local DIR="hyperland-developer-ubuntu"

  if [ -d "$DIR/.git" ]; then
    echo "🔄 Existing copy found, updating it..."
    git -C "$DIR" fetch origin "$BRANCH"
    git -C "$DIR" checkout "$BRANCH"
    git -C "$DIR" pull --ff-only origin "$BRANCH"
  else
    echo "🔄 Cloning Hyprland setup repo ($BRANCH)..."
    git clone --branch "$BRANCH" "$REPO_URL" "$DIR"
  fi
  cd "$DIR"

  echo "🔧 Starting full setup..."
  chmod +x setup.sh
  # Read prompts from the terminal, not from the pipe this script came through
  if [ -r /dev/tty ]; then
    ./setup.sh </dev/tty
  else
    ./setup.sh
  fi
}

main "$@"
