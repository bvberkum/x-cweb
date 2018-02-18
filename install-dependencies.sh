#!/usr/bin/env bash

set -e

stderr()
{
  echo "$log_pref$1" >&2
  test -z "$2" || exit $2
}

test -z "$Build_Debug" || set -x

test -z "$Build_Deps_Default_Paths" || {

  test -n "$SRC_PREFIX" || {
    test -w /src/ \
      && SRC_PREFIX=/src/ \
      || SRC_PREFIX=$HOME/build
  }

  test -n "$PREFIX" || {
    test -w /usr/local/ \
      && PREFIX=/usr/local/ \
      || PREFIX=$HOME/.local
  }

  stderr "Setting default paths: SRC_PREFIX=$SRC_PREFIX PREFIX=$PREFIX"
}

test -n "$sudo" || sudo=
test -z "$sudo" || pref="sudo $pref"
test -z "$dry_run" || pref="echo $pref"

test -n "$SRC_PREFIX" ||
  stderr "Not sure where to checkout (SRC_PREFIX missing)" 1

test -n "$PREFIX" ||
  stderr "Not sure where to install (PREFIX missing)" 1


echo SRC_PREFIX=$SRC_PREFIX
echo PREFIX=$PREFIX
echo "install-dependencies: '$*'"
test -d $SRC_PREFIX || ${pref} mkdir -vp $SRC_PREFIX
test -d $PREFIX || ${pref} mkdir -vp $PREFIX


# Last version at this time
# cweb-3.64c
install_cweb()
{
  test -e $SRC_PREFIX/github.com/ascherer/cweb || {
    mkdir -p $SRC_PREFIX/github.com/ascherer
    git clone https://github.com/ascherer/cweb $SRC_PREFIX/github.com/ascherer/cweb
  }
  (
    cd $SRC_PREFIX/github.com/ascherer/cweb
    test -n "$CWEB_VERSION" && {
      git checkout $CWEB_VERSION
      make
      ${sudo}cp ctangle $PREFIX/bin/ctangle-$CWEB_VERSION
      ${sudo}cp cweave $PREFIX/bin/cweave-$CWEB_VERSION
      stderr "Installed cweb $CWEB_VERSION binaries to $PREFIX/bin"
    } || {
      make
      ${sudo}cp ctangle cweave $PREFIX/bin/
      stderr "Installed cweb binaries to $PREFIX/bin"
    }
    git clean -df
  )
}


main_entry()
{
  test -n "$1" || set -- all
  main_load

  case "$1" in all|cweb )
      install_cweb
    ;; esac

  stderr "OK. All pre-requisites for '$1' checked"
}

main_load()
{
  #test -x "$(which tput)" && ...
  log_pref="[install-dependencies] "
  stderr "Loaded"
}


{
  test "$(basename "$0")" = "install-dependencies.sh" ||
  test "$(basename "$0")" = "bash" ||
    stderr "0: '$0' *: $*" 1
} && {
  test -n "$1" -o "$1" = "-" || set -- all
  while test -n "$1"
  do
    main_entry "$1" || exit $?
    shift
  done
} || printf ""

# Id: script-mpe/0 install-dependencies.sh
