# Setting up the tutorial inside `EBVcube/EBV_resources`

`EBV_resources` is a good home for this — it's already the team's catch-all for public resources (manual, presentation), it has the right owners with write access, and you don't need to stand up a new repo, new CI, or new permissions from scratch. Below is the exact sequence to add the tutorial alongside `manual/` and `presentation/`.

## 1. What you're adding

```
EBV_resources/
├── manual/                          (existing)
├── presentation/                    (existing)
├── tutorial/                        ← NEW: everything in this scaffold
│   ├── _quarto.yml
│   ├── index.qmd
│   ├── 01-introduction.qmd
│   ├── 02-installation.qmd
│   ├── 03-preparing-data.qmd
│   ├── 04-creating-the-cube.qmd
│   ├── 05-validating.qmd
│   ├── 06-uploading.qmd
│   ├── 07-troubleshooting.qmd
│   ├── 08-resources.qmd
│   ├── OUTLINE.md                   (writing brief, not part of the book)
│   ├── README.md
│   └── .gitignore
├── .github/workflows/
│   └── publish-tutorial.yml         ← NEW, goes at repo ROOT (see step 3)
├── README.md                        (existing — add one line, step 4)
├── LICENSE
```

Everything under `tutorial/` in this scaffold folder maps 1:1 onto that structure. The one exception is `publish-tutorial.yml`, which currently sits in a `gh-root-workflow/` folder in this scaffold only because it *must* live at the repo root, not inside `tutorial/` — GitHub only looks for workflows in `.github/workflows/` at the top level.

## 2. Add the files to the repo

If you don't already have the repo cloned:

```bash
git clone https://github.com/EBVcube/EBV_resources.git
cd EBV_resources
```

Create a branch, then copy the scaffold in:

```bash
git checkout -b add-ebv-tutorial

# copy the tutorial/ folder itself
cp -r /path/to/tutorial-scaffold tutorial

# the workflow file needs to land at the repo root's .github/workflows/,
# not inside tutorial/
mkdir -p .github/workflows
cp tutorial/gh-root-workflow/publish-tutorial.yml .github/workflows/
rm -rf tutorial/gh-root-workflow
```

(Adjust `/path/to/tutorial-scaffold` to wherever you saved the files I generated.)

## 3. Enable GitHub Pages for this repo

The workflow publishes to a `gh-pages` branch, but Pages needs to be told to serve from it — this repo has never had Pages configured before, so it's a one-time step:

1. Push your branch and merge the PR into `main` first (Pages can't serve a branch that doesn't exist yet, and `gh-pages` is created automatically the first time the workflow runs).
2. After the first successful run of **Actions → Publish EBV tutorial**, go to **Settings → Pages**.
3. Under **Source**, choose **Deploy from a branch** → branch `gh-pages` → folder `/ (root)** → **Save**.
4. GitHub will show you the URL (something like `https://ebvcube.github.io/EBV_resources/`) once it's live — usually within a minute or two.

If the Actions run fails the first time, check the **Actions** tab logs — the most common first-run failure is a missing `permissions:` block, which is already included in the workflow above, so this should work out of the box.

## 4. Update the root README

The current root `README.md` just says the repo allocates public EBV Data Portal team resources. Add a line pointing at the new tutorial, e.g.:

```markdown
## Contents

- `manual/` — the EBVCube manual PDF
- `presentation/` — slides introducing EBVCube
- `tutorial/` — step-by-step tutorial: creating an EBV netCDF and publishing it
  to the EBV Data Portal ([rendered site](https://ebvcube.github.io/EBV_resources/))
```

## 5. Commit and open the PR

```bash
git add tutorial .github/workflows/publish-tutorial.yml README.md
git commit -m "Add EBV netCDF creation and portal upload tutorial"
git push -u origin add-ebv-tutorial
```

Open a PR on GitHub as usual. Once merged to `main`, the Actions workflow renders and publishes automatically — you don't need to run `quarto publish` by hand.

## 6. Writing the actual content

The `.qmd` files are stubs with `<!-- TODO -->` markers matching each section of `OUTLINE.md`. Work through them unit by unit — most of Units 2, 4, 5, 7 can be adapted almost directly from the existing `ebvcube-docs` book (the outline says exactly which paragraph to pull from where); Units 1, 3, 6 need new writing plus portal screenshots.

To preview locally while writing (requires [Quarto](https://quarto.org/docs/get-started/) and R with `ebvcube` installed — see `02-installation.qmd`):

```bash
cd tutorial
quarto preview
```
