shopt -s nullglob
shopt -s extglob

export TZ="America/Edmonton"

export HOSTNAME=$(uname -n)

. ~/.config/sh/paths.sh
. ~/.config/environment.d/rubygems.sh

script_dir=${0%[/\\]*}
parent_dir=$(readlink -e "$script_dir/..") || exit

export RUBYOPT="-E utf-8:utf-8"

say() { printf '%b»%b %s\n' "\e[34m" "\e[0m" "$@"; }

die() { printf '%b*%b %s\n' "\e[31m" "\e[0m" "fatal error: $@" >&2; exit 1; }

fixchmod()
{
  chmod -Rc go+rX "$@"/**
}

syncdir()
{ #: - synchronizes the contents of two directories
  #: $ syncdir <source> [[<user>@]<host>:]<destination> [<rsync options>]

  if (( $# >= 2 )); then
    local src="${1%/}" # trim trailing slash
    local dst="${2%/}" # trim trailing slash
    shift 2
  else
    return 64
  fi

  local -a flags=()
  local -a usrflags=("$@")

  # recurse; preserve symlinks, times, permissions, but not group/owner
  flags+=(--archive --no-group --no-owner)

  # use SSH instead of RSH
  flags+=(--rsh=$(type -P ssh))

  # compress file data during the transfer
  flags+=(--compress)

  # # find extraneous files during xfer, delete after
  # flags+=(--delete-delay)

  # output numbers in a human-readable format
  flags+=(--human-readable)

  # show progress during transfer
  flags+=(--progress)
  # flags+=(--verbose)
  # flags+=(--dry-run)

  rsync ${flags[*]} ${usrflags[*]} "$src/" "$dst" | grep -v '/$'
}

