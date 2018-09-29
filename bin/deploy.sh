#!/usr/bin/env bash

. "${0%[/\\]*}/_common.bash" || exit

[[ $(uname -n) =~ Athena ]] || die "cannot be executed on this system"

host="WebFaction"

local_build_dir="$parent_dir/build"
remote_build_dir="/path/to/remote/build/directory"

sync_built_files()
{
  say "syncing built files with $host..."

  local -a filters=(
    --delete-delay
    --exclude=.well-known
    --exclude=cgi-bin
  )

  syncdir "$local_build_dir" "$host:$remote_build_dir" "${filters[@]}"
}

build_files()
{
  say "middleman build${@:+ $@}..."

  cd "$parent_dir"
  bundle exec middleman build "$@" || exit
}

link_certificate()
{
  local cert="/home/zozo/etc/ssl/name_of_project/.well-known"

  say "connecting to $host for link..."
  ssh "$host" ln -sfv "$cert" "$remote_build_dir"
}

main()
{
  build_files "$@"
  sync_built_files
  # link_certificate
}

while getopts ':bs' OPT; do
  case $OPT in
    b)
      shift
      build_files "$@"
      exit
      ;;
    s)
      sync_built_files
      exit
      ;;
    *)
      break
      ;;
  esac
done

main "$@"
