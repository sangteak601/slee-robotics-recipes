# Design: slee-robotics-recipes

## Summary

Add rattler-build recipes for **libmodbus 3.1.10** and **quicktype CLI** to host on a prefix.dev pixi channel. Target platform: linux-64 only. GitHub Actions CI builds and uploads packages automatically.

## Repository Structure

```
slee-robotics-recipes/
├── recipes/
│   ├── libmodbus/
│   │   └── recipe.yaml
│   └── quicktype/
│       └── recipe.yaml
├── .github/
│   └── workflows/
│       └── build.yml
├── pixi.toml
└── README.md
```

## Recipe: libmodbus 3.1.10

- **Source:** GitHub tarball from `libmodbus/libmodbus` v3.1.10
- **Build system:** Autotools (`autoreconf -fi && ./configure --prefix=$PREFIX && make && make install`)
- **Build dependencies:** `autoconf`, `automake`, `libtool`, `make`, `gcc` (from conda-forge)
- **Run dependencies:** `libgcc-ng`
- **Outputs:** Shared library (`libmodbus.so`), headers, pkg-config file
- **Platform:** linux-64

## Recipe: quicktype CLI

- **Source:** npm registry, `quicktype` package (latest)
- **Strategy (Approach C):** Depend on conda-forge `nodejs` as a runtime dependency. At build time, use `nodejs`/`npm` to `npm install -g quicktype` into `$PREFIX`. The package ships the JS files and a node shim script.
- **Build dependencies:** `nodejs`, `npm` (from conda-forge)
- **Run dependencies:** `nodejs` (from conda-forge)
- **Outputs:** `bin/quicktype` executable on PATH
- **Platform:** linux-64

## CI: GitHub Actions

- **Trigger:** Push to `main`, pull requests
- **Steps:**
  1. Install `rattler-build` (via pixi or standalone installer)
  2. Build each recipe (`rattler-build build --recipe recipes/<name>/recipe.yaml`)
  3. Upload to prefix.dev channel (`rattler-build upload prefix -c <channel>`)
- **Secrets required:** `PREFIX_DEV_API_KEY`
- **Matrix:** Not needed (single platform linux-64)

## Dev Environment (pixi.toml)

A `pixi.toml` at the repo root provides `rattler-build` for local development/testing of recipes.

## Decisions

- quicktype uses Approach C (nodejs as conda-forge runtime dependency) for clean separation
- Environments already use conda-forge, so nodejs dependency resolves naturally
- Single platform (linux-64) keeps things simple; can expand later
