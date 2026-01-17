# build-ia16-custom

Custom fork of the IA-16 toolchain build system with modern Makefile-based construction.

## Upstream

- **Repository**: https://gitlab.com/tkchia/build-ia16
- **Branch**: `master`
- **Maintainer**: TK Chia

## Modifications

This fork replaces the original `build.sh` script with a proper Makefile-based build system:

### Why Makefile Instead of build.sh

- **Dependency tracking** - Automatic detection of what needs rebuilding
- **Parallel builds** - Proper `-j` support across all stages
- **Reproducibility** - Deterministic build order and flags
- **Standard interface** - Familiar `make`, `make install`, `make clean`
- **Integration** - Works with PKGBUILDs and CI/CD pipelines

### Build Stages

1. **binutils** - Assembler, linker, and binary utilities
2. **gcc-stage1** - Bootstrap C compiler (no libc)
3. **newlib** - C library (requires stage1 gcc)
4. **gcc-stage2** - Full C compiler with libc support

## Building

### Using Master Makefile

```bash
cd ~/Playground/ia16
make -f Makefile all PREFIX=$HOME/.local/ia16
```

### Using PKGBUILDs (Arch Linux)

```bash
cd ~/pkgbuilds/ia16-toolchain
make all
```

## Build Order

The Makefile enforces proper build order:

```
binutils -> gcc-stage1 -> newlib -> gcc-stage2
```

## Configuration

Key variables (can be overridden):

| Variable | Default | Description |
|----------|---------|-------------|
| `PREFIX` | `~/.local/ia16` | Installation prefix |
| `PARALLEL` | `-j$(nproc)` | Parallel job count |
| `TARGET` | `ia16-elf` | Target triplet |

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
