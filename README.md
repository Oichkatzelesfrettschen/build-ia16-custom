[![Casual Maintenance Intended](badge.svg)](https://casuallymaintained.tech/)

(possible workflow to build compiler toolchain on Linux build machine, for Linux host and/or DJGPP/MS-DOS host)

         «START»
            ▾
    ./fetch.sh
            ▾
    ./build.sh clean ─────┐
            │             ▾
            │  ./build.sh binutils-debug
            ▾             │
    ./build.sh binutils ◂─┘
            ▾
    ./build.sh prereqs
            ▾
    ./build.sh gcc1 ◂───────────────┐
            ▾                       │
    ./build.sh newlib               │
            ▾                       │
    ./build.sh causeway             │
            ▾                       │
    ./build.sh libi86 ────────────────────────────┐
            ▾                       │             ▾
    ./build.sh gcc2 ──────┐         │     ./build.sh clean-djgpp
            │             ▾         │             ▾
            │  ./build.sh extra     │     ./build.sh prereqs-djgpp
            ├◂────────────┘         │             ▾
            ├─────────────┐         │     ./build.sh binutils-djgpp
            │             ▾         │             ▾
            │  ./build.sh sim       │     ./build.sh gcc-djgpp
            │             ▾         │             │
            │  ./build.sh test ─────┘             │
            ├◂────────────┘                       │
            ├─────────────┐                       │
            │             ▾                       ▾
            ▾  ./redist-ppa.sh all        ./redist-djgpp.sh all
          «END» ◂─────────┴◂──────────────────────┘

### Using `build.sh`

  * The Linux-hosted toolchain will be installed in the `prefix/` subdirectory under this top-level directory.  To use the newly-built toolchain, you can add ...`/prefix/bin` to your `$PATH`.
  * The DJGPP-hosted toolchain — if any — will appear under `prefix-djgpp/`.
  * You can specify multiple build stages together when running `build.sh`.  E.g., `./build.sh binutils prereqs gcc1`.
  * Optional external runtimes/tests (ELKS libc, elksemu, emulator builds) should live outside this repo.
  * To build ELKS-related stages, set `IA16_EXTERNAL_TESTS` (preferred) or `ELKS_DIR`/`ELKS_BUILD_DIR` before running `build.sh`.
  * ELKS build staging goes to `$IA16_EXTERNAL_TESTS/build-elks` (or `$ELKS_BUILD_DIR` if set).  If neither is configured, ELKS stages will error.

### Optional external runtime stages

  * `./build.sh elks-libc` (also builds `elf2elks` and `elksemu` for now)
  * These stages require an existing ELKS git checkout at `$ELKS_DIR`; `fetch.sh` does not download ELKS by default.
  * Optional: set `ELKS_TEST_SRC` to a C file for the elksemu smoke test (defaults to `$IA16_EXTERNAL_TESTS/tests/elks-fartext-test.c` if present, else `elks-fartext-test.c` in this directory).
  * If you *do* want `fetch.sh` to download ELKS and emulator repos, set `IA16_FETCH_ELKS=1` and/or `IA16_FETCH_EMULATORS=1` **and** set `IA16_EXTERNAL_TESTS` (preferred) or `ELKS_DIR`/`REENIGNE_DIR`.

### Using `redist-ppa.sh`

  * `redist-ppa.sh` produces Ubuntu source package bundles in the `redist-ppa/` directory.
  * Each package bundle comprises several files which are tied together by a `.changes` file.  You can (e.g.) pass the names of the `.changes` files to [`dput`](https://manpages.ubuntu.com/manpages/noble/en/man1/dput.1.html) to upload the source bundles to Ubuntu Launchpad.
  * You probably want to define the environment variable `$DEBSIGN_KEYID` to an OpenPGP key id to use, before running `redist-ppa.sh`.
  * You can target a specific Ubuntu distribution by passing a `--distro=` option.  On default, `redist-ppa.sh` targets the Ubuntu distribution which it is running on.

### Pre-compiled compiler toolchain packages

  * A pre-compiled [Ubuntu Personal Package Archive](https://launchpad.net/~tkchia/+archive/ubuntu/build-ia16/) is now available.
  * There are also binary FreeDOS packages [for the toolchain](https://gitlab.com/tkchia/build-ia16/-/releases) and [for `libi86`](https://gitlab.com/tkchia/build-ia16/-/releases).  The toolchain requires a 32-bit machine (i.e. 80386 or above), but it will produce 16-bit code.

### Further information

  * A [write-up](elf16-writeup.md) on the ELF relocation schemes implemented for IA-16 segmented addressing.
  * [`libi86` project home page](https://gitlab.com/tkchia/libi86), including documentation.
