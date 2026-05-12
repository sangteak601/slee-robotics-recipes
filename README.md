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
