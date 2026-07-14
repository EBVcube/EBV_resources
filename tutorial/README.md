# EBV tutorial: creating an EBVCube NetCDF and publishing to the EBV Data Portal

This folder is a [Quarto book](https://quarto.org/docs/books/) that teaches the full workflow from
raw biodiversity data to a published dataset on the [EBV Data Portal](https://portal.geobon.org/),
using the `ebvcube` R package. Written for the NaturaConnect Learning Platform.

## Building locally

You need:

- **Quarto ≥ 1.5** ([install instructions](https://quarto.org/docs/get-started/))
- **R ≥ 4.2** with `ebvcube` installed (see `02-installation.qmd`)

From this folder:

```bash
quarto preview     # live preview while editing
quarto render      # one-shot build into _book/
```

## Content status

`OUTLINE.md` in this folder is the detailed writing brief (objectives, content
bullets, what to adapt from `ebvcube-docs`, screenshots needed) for every unit.
The `.qmd` files currently contain that outline as `<!-- TODO -->` comments —
fill each unit in following its outline entry, then delete the comment.

## Deploying

Publishing is handled by `.github/workflows/publish-tutorial.yml` at the repo
root, which renders this folder and pushes it to the `gh-pages` branch on
every push to `main` that touches files under `tutorial/`.
