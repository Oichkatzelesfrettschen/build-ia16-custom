#!/bin/sh

set -e

banner_beg="`tput bold 2>/dev/null || :`*** "
banner_end=" ***`tput sgr0 2>/dev/null || :`"

do_banner () {
    echo "$banner_beg$*$banner_end"
}

do_git_pull () {
    name="$1"
    path="${2:-$name}"
    if [ -d "$path" ]; then
      do_banner "Trying to pull updates from $name Git repository"
      (cd "$path" && git pull)
    else
      do_banner "No existing $name tree, not updating"
    fi
}

if [ -n "${ELKS_DIR:-}" ]; then
  ELKS_DIR="$ELKS_DIR"
elif [ -n "${IA16_EXTERNAL_TESTS:-}" ]; then
  if [ -d "$IA16_EXTERNAL_TESTS/external/elks" ]; then
    ELKS_DIR="$IA16_EXTERNAL_TESTS/external/elks"
  elif [ -d "$IA16_EXTERNAL_TESTS/external/elks-tkchia" ]; then
    ELKS_DIR="$IA16_EXTERNAL_TESTS/external/elks-tkchia"
  else
    ELKS_DIR="$IA16_EXTERNAL_TESTS/external/elks"
  fi
fi
if [ -n "${REENIGNE_DIR:-}" ]; then
  REENIGNE_DIR="$REENIGNE_DIR"
elif [ -n "${IA16_EXTERNAL_TESTS:-}" ]; then
  REENIGNE_DIR="$IA16_EXTERNAL_TESTS/emulators/reenigne"
fi

do_git_pull gcc-ia16
do_git_pull newlib-ia16
do_git_pull binutils-ia16
if [ "${IA16_UPDATE_EMULATORS:-0}" = "1" ]; then
  if [ -n "${REENIGNE_DIR:-}" ]; then
    do_git_pull reenigne "$REENIGNE_DIR"
  else
    do_git_pull reenigne
  fi
else
  do_banner "Skipping reenigne update (set IA16_UPDATE_EMULATORS=1 to enable)"
fi
if [ "${IA16_UPDATE_ELKS:-0}" = "1" ]; then
  do_git_pull elks "$ELKS_DIR"
else
  do_banner "Skipping ELKS update (set IA16_UPDATE_ELKS=1 to enable)"
fi
do_git_pull causeway
do_git_pull libi86
do_git_pull pdcurses
do_git_pull ubasic-ia16
do_git_pull tinyasm
