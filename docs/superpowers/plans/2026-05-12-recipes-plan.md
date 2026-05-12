# slee-robotics-recipes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Set up a rattler-build recipe repository with libmodbus and quicktype packages, CI to build and upload to prefix.dev.

**Architecture:** Each recipe lives in `recipes/<name>/recipe.yaml`. A GitHub Actions workflow builds all recipes and uploads to prefix.dev. A `pixi.toml` provides `rattler-build` for local dev.

**Tech Stack:** rattler-build, pixi, GitHub Actions, conda-forge dependencies

---

### Task 1: Repository scaffold (pixi.toml + README)

**Files:**
- Create: `pixi.toml`
- Create: `README.md`

- [ ] **Step 1: Create pixi.toml**

```toml
[project]
name = "slee-robotics-recipes"
version = "0.1.0"
description = "Rattler-build recipes for slee-robotics pixi channel"
channels = ["conda-forge"]
platforms = ["linux-64"]

[dependencies]
rattler-build = ">=0.35"
```

- [ ] **Step 2: Create README.md**

```markdown
# slee-robotics-recipes

Rattler-build recipes for the slee-robotics prefix.dev channel.

## Recipes

- **libmodbus** (3.1.10) — Modbus protocol library
- **quicktype** — JSON schema to typed code generator CLI

## Local development

```bash
pixi install
pixi run rattler-build build --recipe recipes/libmodbus/recipe.yaml
pixi run rattler-build build --recipe recipes/quicktype/recipe.yaml
```

## CI

GitHub Actions builds and uploads packages to prefix.dev on push to main.
Requires `PREFIX_DEV_API_KEY` repository secret.
```

- [ ] **Step 3: Commit**

```bash
git add pixi.toml README.md
git commit -m "feat: add pixi.toml and README"
```

---

### Task 2: libmodbus recipe

**Files:**
- Create: `recipes/libmodbus/recipe.yaml`

- [ ] **Step 1: Create recipes/libmodbus/recipe.yaml**

```yaml
schema_version: 1

context:
  version: "3.1.10"

package:
  name: libmodbus
  version: ${{ version }}

source:
  url: https://github.com/stephane/libmodbus/releases/download/v${{ version }}/libmodbus-${{ version }}.tar.gz
  sha256: e93503749cd89fda088cbf6125ff04b468f881dc5e5d62e8ae9aaae1a9d9fdd3

build:
  number: 0

requirements:
  build:
    - ${{ compiler('c') }}
    - make
    - autoconf
    - automake
    - libtool
  host:
    - libgcc-ng
  run:
    - libgcc-ng

test:
  commands:
    - test -f $PREFIX/lib/libmodbus.so
    - test -f $PREFIX/include/modbus/modbus.h
    - pkg-config --modversion libmodbus | grep ${{ version }}
  requires:
    - pkg-config

about:
  homepage: https://libmodbus.org
  license: LGPL-2.1-or-later
  license_file: COPYING.LESSER
  summary: A Modbus library for Linux, Mac OS, FreeBSD and Windows
  repository: https://github.com/stephane/libmodbus
```

- [ ] **Step 2: Verify recipe parses**

Run: `pixi run rattler-build build --recipe recipes/libmodbus/recipe.yaml --render-only`
Expected: Recipe renders without errors

- [ ] **Step 3: Commit**

```bash
git add recipes/libmodbus/recipe.yaml
git commit -m "feat: add libmodbus 3.1.10 recipe"
```

---

### Task 3: quicktype recipe

**Files:**
- Create: `recipes/quicktype/recipe.yaml`
- Create: `recipes/quicktype/build.sh`

- [ ] **Step 1: Create recipes/quicktype/build.sh**

```bash
#!/bin/bash
set -euo pipefail

npm install -g quicktype --prefix "$PREFIX"
```

- [ ] **Step 2: Create recipes/quicktype/recipe.yaml**

```yaml
schema_version: 1

context:
  version: "23.0.170"

package:
  name: quicktype
  version: ${{ version }}

source:
  url: https://registry.npmjs.org/quicktype/-/quicktype-${{ version }}.tgz
  # sha256 will need to be filled after downloading

build:
  number: 0
  script: build.sh

requirements:
  build:
    - nodejs
    - npm
  host:
    - nodejs
    - npm
  run:
    - nodejs

test:
  commands:
    - quicktype --version

about:
  homepage: https://quicktype.io
  license: Apache-2.0
  summary: Generate types and converters from JSON, Schema, and GraphQL
  repository: https://github.com/glideapps/quicktype
```

- [ ] **Step 3: Verify recipe parses**

Run: `pixi run rattler-build build --recipe recipes/quicktype/recipe.yaml --render-only`
Expected: Recipe renders without errors

- [ ] **Step 4: Commit**

```bash
git add recipes/quicktype/
git commit -m "feat: add quicktype CLI recipe"
```

---

### Task 4: GitHub Actions CI workflow

**Files:**
- Create: `.github/workflows/build.yml`

- [ ] **Step 1: Create .github/workflows/build.yml**

```yaml
name: Build and Upload Recipes

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        recipe: [libmodbus, quicktype]
    steps:
      - uses: actions/checkout@v4

      - uses: prefix-dev/setup-pixi@v0.8.1
        with:
          pixi-version: latest

      - name: Build ${{ matrix.recipe }}
        run: pixi run rattler-build build --recipe recipes/${{ matrix.recipe }}/recipe.yaml

      - name: Upload to prefix.dev
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: |
          pixi run rattler-build upload prefix \
            -c slee-robotics \
            --api-key "${{ secrets.PREFIX_DEV_API_KEY }}" \
            output/**/*.conda
```

- [ ] **Step 2: Commit**

```bash
git add .github/workflows/build.yml
git commit -m "feat: add GitHub Actions CI for recipe builds"
```

---

### Task 5: Validate locally

- [ ] **Step 1: Run pixi install to verify pixi.toml**

Run: `pixi install`
Expected: Environment created successfully with rattler-build available

- [ ] **Step 2: Render both recipes to check syntax**

Run: `pixi run rattler-build build --recipe recipes/libmodbus/recipe.yaml --render-only`
Run: `pixi run rattler-build build --recipe recipes/quicktype/recipe.yaml --render-only`
Expected: Both render without errors

- [ ] **Step 3: Fix any issues and commit**

```bash
git add -A
git commit -m "fix: address recipe validation issues" # only if needed
```
