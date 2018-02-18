#!/usr/bin/env bash

set -e

type cweb_stderr >/dev/null 2>&1 || . ./profile.sh


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
      cweb_stderr "Installed cweb $CWEB_VERSION binaries to $PREFIX/bin"
    } || {
      make
      ${sudo}cp ctangle cweave $PREFIX/bin/
      cweb_stderr "Installed cweb binaries to $PREFIX/bin"
    }
    git clean -df
  )
}


main_entry()
{
  test -n "$1" || set -- all
  main_load

  case "$1" in all|cweb )

      for bin in cweave ctangle
      do
        rm $PREFIX/bin/$bin || true
        test -z "$CWEB_VERSION" || {
          ln -s $PREFIX/bin/$bin-$CWEB_VERSION $PREFIX/bin/$bin
        }
      done

      install_cweb

    ;; esac

  cweb_stderr "OK. All pre-requisites for '$1' checked"
}

main_load()
{
  #test -x "$(which tput)" && ...
  log_pref="[install-dependencies] "
  cweb_stderr "Loaded"
}


{
  test "$(basename "$0")" = "install-dependencies.sh" ||
  test "$(basename "$0")" = "bash" ||
    cweb_stderr "0: '$0' *: $*" 1
} && {
  test -n "$1" -o "$1" = "-" || set -- all
  while test -n "$1"
  do
    main_entry "$1" || exit $?
    shift
  done
} || printf ""

# Id: script-mpe/0 install-dependencies.sh
