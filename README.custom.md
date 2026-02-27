# build-ia16-custom

Custom fork of TK Chia’s `build-ia16` scripts. In this workspace it is kept mainly for
reference and for upstream-style scripted builds (`build.sh`), while the primary build
entrypoint is the repo-root `Makefile` (which builds the custom toolchain forks).

## Upstream

- **Repository**: https://gitlab.com/tkchia/build-ia16
- **Branch**: `master`
- **Maintainer**: TK Chia

## Modifications

This fork carries local tweaks to better fit this mono-repo layout and the “external tests”
policy (ELKS/emulators/demos live outside the repo under `IA16_EXTERNAL_TESTS`).

## Building (recommended)

Use the repo-root `Makefile` to build the custom forks:

```bash
REPO="${IA16_REPO:-$HOME/Playground/ia16}"
cd "$REPO"
make all PREFIX=$HOME/.local/ia16 IA16_WERROR=1
```

Build order:

```
binutils -> gcc-stage1 -> newlib -> gcc-stage2
```

## Building (scripted upstream flow)

`build.sh` is still present for upstream-style scripted builds. See `build-ia16-custom/README.md`
for the stage list and notes about optional external runtime stages.

## Configuration

Key variables (can be overridden):

| Variable | Default | Description |
|----------|---------|-------------|
| `PREFIX` | `~/.local/ia16` | Installation prefix |
| `TARGET` | `ia16-elf` | Target triplet |
| `IA16_EXTERNAL_TESTS` | unset | Optional external tests root |
| `IA16_HOST_CXXSTD` | `-std=gnu++11` | Host C++ standard for GCC 6.3 cross builds (avoid relying on modern-default C++17) |

## Dependencies

This repo’s canonical dependency list lives in the workspace root:
- `REQUIREMENTS.md`

If you use `build-ia16-custom/build.sh` directly (instead of the repo-root `Makefile`), you may need extra host tools beyond the “core toolchain” set:
- Autotools helpers: `autoconf`, `automake`, `autogen`, `m4`
- Test harness: `dejagnu`, `expect`
- Packaging helpers (optional): `zip`, `xz`, plus distro-specific packaging tooling (see `REQUIREMENTS.md`)

External runtimes/emulators (ELKS, bochs/86box, etc.) are intentionally **out-of-repo** and manual-only;
if you build those stages, they should live under `$IA16_EXTERNAL_TESTS` (or explicitly configured paths).

## Syncing with Upstream

```bash
git fetch upstream
git merge upstream/master
```

## License

GPL v3 (see upstream for complete license terms)

## Related Repositories

- [binutils-ia16-custom](https://github.com/Oichkatzelesfrettschen/binutils-ia16-custom) - IA-16 binutils
- [gcc-ia16-8088-custom](https://github.com/Oichkatzelesfrettschen/gcc-ia16-8088-custom) - GCC 6.3.0 for IA-16
- [newlib-ia16-custom](https://github.com/Oichkatzelesfrettschen/newlib-ia16-custom) - C library for IA-16
