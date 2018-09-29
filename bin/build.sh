#!/usr/bin/env bash

. "${0%[/\\]*}/_common.bash" || exit

[[ $(uname -n) =~ webfaction ]] || die "cannot be executed on this system"

src_dir="$HOME/src/name_of_project"
build_dir="$HOME/webapps/name_of_project"

cert="$HOME/etc/ssl/name_of_project/.well-known"

# -----------------------------------------------------------------------------

link_certificates()
{
  ln -sf "$cert" "$build_dir"
}

mm_build()
{
  say "middleman build${@:+ $@}..."

  cd "$parent_dir"
  bundle exec middleman build "$@" # | grep -Ev '^\s*identical\>'
}

main()
{
  mm_build "$@"
  link_certificates
}

main "$@"
