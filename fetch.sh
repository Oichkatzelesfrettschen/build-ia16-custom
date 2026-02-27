#!/bin/sh

set -e

banner_beg="`tput bold 2>/dev/null || :`*** "
banner_end=" ***`tput sgr0 2>/dev/null || :`"

# Keep ELKS/emulators out of this repo: prefer cloning into IA16_EXTERNAL_TESTS.
if [ -z "${ELKS_DIR:-}" ] && [ -n "${IA16_EXTERNAL_TESTS:-}" ]; then
    # This script fetches tkchia's ELKS fork; keep it separate from any
    # upstream ELKS checkout under external/elks.
    ELKS_DIR="$IA16_EXTERNAL_TESTS/external/elks-tkchia"
fi
if [ -z "${REENIGNE_DIR:-}" ] && [ -n "${IA16_EXTERNAL_TESTS:-}" ]; then
    REENIGNE_DIR="$IA16_EXTERNAL_TESTS/emulators/reenigne"
fi

do_banner () {
    echo "$banner_beg$*$banner_end"
}

do_git_clone () {
    local name server path opts dest
    name="$1"
    server="$2"
    path="$3"
    if test shallow = "$4"; then
	opts='--depth 1'
    else
	opts=
    fi
    dest="${5:-$name}"
    if test -e "$dest/.git/config"
    then
	do_banner "$name already downloaded; updating via fast-forward pull"
	(cd "$dest" && git pull --ff-only)
	return 0
    fi
    do_banner "Trying to download $name Git repository using SSH"
    echo URL: git@"$server":"$path"
    mkdir -p "$(dirname "$dest")"
    if git clone --recurse-submodules -v $opts git@"$server":"$path" "$dest"
    then
	do_banner "Successfully downloaded $name"
	return 0
    fi
    do_banner "SSH failed; falling back on using HTTPS to download $name"
    echo URL: https://"$server"/"$path"
    if git clone --recurse-submodules -v $opts https://"$server"/"$path" "$dest"
    then
	do_banner "Successfully downloaded $name"
	return 0
    fi
    do_banner "Could not download $name!"
    exit 1
}

do_git_clone gcc-ia16 "${1-gitlab.com}" tkchia/gcc-ia16.git "$2"
do_git_clone newlib-ia16 "${1-gitlab.com}" tkchia/newlib-ia16.git "$2"
do_git_clone binutils-ia16 "${1-gitlab.com}" tkchia/binutils-ia16.git "$2"
if [ "${IA16_FETCH_EMULATORS:-0}" = "1" ]; then
    if [ -z "${REENIGNE_DIR:-}" ] && [ -z "${IA16_EXTERNAL_TESTS:-}" ]; then
	do_banner "Refusing reenigne checkout without IA16_EXTERNAL_TESTS or REENIGNE_DIR"
	exit 1
    fi
    if [ -n "${REENIGNE_DIR:-}" ]; then
	do_git_clone reenigne "${1-gitlab.com}" tkchia/reenigne.git "$2" "$REENIGNE_DIR"
	REENIGNE_SYMLINK_TARGET="$REENIGNE_DIR/8088/86sim"
    else
	do_git_clone reenigne "${1-gitlab.com}" tkchia/reenigne.git "$2"
	REENIGNE_SYMLINK_TARGET="reenigne/8088/86sim"
    fi
    if [ -n "${IA16_EXTERNAL_TESTS:-}" ]; then
	mkdir -p "$IA16_EXTERNAL_TESTS/emulators"
	rm -f "$IA16_EXTERNAL_TESTS/emulators/86sim"
	ln -s "$REENIGNE_SYMLINK_TARGET" "$IA16_EXTERNAL_TESTS/emulators/86sim"
    else
	do_banner "Note: IA16_EXTERNAL_TESTS is unset; not creating in-repo 86sim symlink"
    fi
else
    do_banner "Skipping reenigne/86sim (set IA16_FETCH_EMULATORS=1 to enable)"
fi
if ! tar -tjf gmp-6.1.2.tar.bz2 >/dev/null 2>&1
then
    rm -f gmp-6.1.2.tar.bz2
    wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
    tar -xjf gmp-6.1.2.tar.bz2
fi
if ! tar -tjf mpfr-3.1.5.tar.bz2 >/dev/null 2>&1
then
    rm -f mpfr-3.1.5.tar.bz2
    wget https://www.mpfr.org/mpfr-3.1.5/mpfr-3.1.5.tar.bz2 || \
      wget https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.5.tar.bz2
    tar -xjf mpfr-3.1.5.tar.bz2
fi
if ! tar -tzf mpc-1.0.3.tar.gz >/dev/null 2>&1
then
    rm -f mpc-1.0.3.tar.gz
    wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
    tar -xzf mpc-1.0.3.tar.gz
fi
if ! tar -tjf isl-0.16.1.tar.bz2 >/dev/null 2>&1
then
    rm -f isl-0.16.1.tar.bz2
    wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.16.1.tar.bz2
    tar -xjf isl-0.16.1.tar.bz2
fi
if [ "${IA16_FETCH_ELKS:-0}" = "1" ]; then
    if [ -z "${ELKS_DIR:-}" ] && [ -z "${IA16_EXTERNAL_TESTS:-}" ]; then
	do_banner "Refusing ELKS checkout without IA16_EXTERNAL_TESTS or ELKS_DIR"
	exit 1
    fi
    if [ -n "${ELKS_DIR:-}" ]; then
	do_git_clone elks "${1-gitlab.com}" tkchia/elks.git "$2" "$ELKS_DIR"
    else
	do_git_clone elks "${1-gitlab.com}" tkchia/elks.git "$2"
    fi
else
    do_banner "Skipping ELKS fetch (set IA16_FETCH_ELKS=1 to enable)"
fi
do_git_clone causeway "${1-gitlab.com}" tkchia/causeway.git "$2"
do_git_clone libi86 "${1-gitlab.com}" tkchia/libi86.git "$2"
# ^- GitLab, not GitHub!
if ! tar -tjf djgpp-linux64-gcc720.tar.bz2 >/dev/null 2>&1
then
    rm -f djgpp-linux64-gcc720.tar.bz2
    wget https://github.com/andrewwutw/build-djgpp/releases/download/v2.8/djgpp-linux64-gcc720.tar.bz2
    tar -xjf djgpp-linux64-gcc720.tar.bz2
fi
