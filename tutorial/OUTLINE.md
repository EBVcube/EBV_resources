# Tutorial outline: Creating an EBVCube NetCDF and Uploading to the EBV Data Portal

Format assumption: each numbered item below becomes one `.qmd` unit, in the NaturaConnect course structure (short intro, objectives, stepped content, checkpoint, resources) — matching a typical blended-learning unit.

**Two datasets, two roles — important distinction verified during research:**

- **Portal ID 30 — "Global trends in biodiversity (BES-SIM cSAR-iDiv)"** (Martins & Pereira, 2022, DOI [10.25829/5zmy41](https://doi.org/10.25829/5zmy41)) is the dataset specified as the example. It is the real, live, citable dataset used whenever the tutorial talks about the *portal itself* (Units 1 and 6): its metadata form, entity list, citation, DOI, versioning. Its netCDF is only 3.27 MB, so it can also be downloaded and run through the full pipeline directly (Unit 3 shows how, via `ebv_download()` or a manual download from the dataset page).
- **Portal ID 1 — "Local bird diversity (cSAR/BES-SIM)"** is a *different* dataset, also by Inês Martins and the same cSAR/BES-SIM model family, but a distinct product (1900–2015, land-use driven, Africa subset). A spatial subset of this one — not of ID 30 — ships inside the `ebvcube` package itself as `martins_comcom_subset.nc`. This is what every existing `ebvcube-docs` code example (`getting-started.qmd`, `core-concepts.qmd`, `advanced-usage.qmd`) already uses, which is why it's the fastest path for hands-on code in Units 2, 4, 5, 7 — no download needed.

Be explicit about this distinction in Unit 1 so learners aren't confused when the bundled file's title doesn't match the dataset-30 page they were just looking at. Where full end-to-end fidelity to dataset 30 matters (a learner wants to literally reproduce it), Unit 3 covers downloading it.

Content in italics marks material that can be **adapted directly from `ebvcube-docs`** (the existing Quarto book) rather than written from scratch — cite the source `.qmd` file so whoever writes this can go straight to the paragraph.

---

## Unit 1 — Introduction to EBVs and the EBV Data Portal

**Objectives:** define an EBV; name the six EBV classes; describe why netCDF was chosen; locate a dataset on the portal.

1. What is an Essential Biodiversity Variable? *(adapt `core-concepts.qmd`, "What is an EBV?")*
2. The six EBV classes, and how the portal's filters map onto them. *(adapt `core-concepts.qmd` callout on canonical classes vs. portal labels)*
3. Why netCDF + CF conventions + ACDD — the interoperability problem this solves. *(adapt `core-concepts.qmd`, "Why netCDF?")*
4. Tour of the EBV Data Portal: Discover, Map, dataset detail page. Use dataset 30's page (portal.geobon.org/ebv-detail?id=30) as the walkthrough example — point out DOI, citation, entities list, download formats (netCDF / JSON / EML / CSV).
5. Where `ebvcube` fits: the package is the bridge between "data on your laptop" and "data on the portal."

**Checkpoint:** Learner can open the dataset-30 page and identify its EBV class, DOI, and file formats.

**Screenshots needed:** portal homepage (Discover), dataset 30 detail page, the class filter list.

---

## Unit 2 — Installing the required software and the `ebvcube` package

**Objectives:** install R, RStudio, and `ebvcube` with all system/Bioconductor dependencies; verify the install.

1. Prerequisites: R ≥ 4.2, RStudio, a C/C++ toolchain, HDF5 + GDAL system libraries. *(adapt `installation.qmd`, "Prerequisites")*
2. Install from CRAN (recommended path). *(adapt `installation.qmd`, "Installing the released version")*
3. Bioconductor dependencies (`rhdf5`, `DelayedArray`, `HDF5Array`) and why CRAN alone won't pull them in. *(adapt `installation.qmd`, "Bioconductor dependencies")*
4. Optional: b-cubed r-universe install for latest binaries; dev version via GitHub. *(adapt `installation.qmd`)*
5. Verify: load the package, check version, load the bundled `martins_comcom_subset.nc`, print its title. *(adapt `installation.qmd`, "Verifying your installation")*

**Checkpoint:** `library(ebvcube)` loads without error and `ebv_properties()` prints the dataset-30 subset's title.

**Common failure to flag here (forward-reference Unit 7):** missing Bioconductor packages, Linux system library gaps.

---

## Unit 3 — Preparing biodiversity data for conversion

**Objectives:** structure raster outputs and metadata so they are ready for `ebv_create()`/`ebv_add_data()`.

1. What `ebv_create()` needs conceptually: one GeoTIFF (or in-memory raster) per entity, per time step, all sharing the same CRS/extent/resolution.
2. Recap the four dimensions (lon, lat, time, entity) and the scenario/metric group hierarchy, this time from the *producer's* point of view: how do your model outputs map onto metrics, entities, and (optionally) scenarios? *(adapt `core-concepts.qmd`, "Scenarios, metrics and the group hierarchy")*
3. Checklist before moving on:
   - all rasters reprojected/aligned to a common grid;
   - a consistent naming scheme per entity/time step;
   - a decision on fill value and units;
   - entity names (or, for species-level data, a taxonomy table — genus/family/order/class columns) ready as a CSV.
4. Worked example: download dataset 30's real netCDF (3.27 MB — small enough to fetch directly from its [dataset page](https://portal.geobon.org/ebv-detail?id=30) or via `ebv_download()`) and inspect its structure with `ebv_properties()`/`ebv_datacubepaths()` to see the scenario/metric/entity hierarchy from step 2 realized in an actual published file — its SSP/RCP scenarios × community-composition metric × 1900–2050 time steps.
5. Building the metadata JSON: either through the portal's metadata form (safest — enforces controlled vocabularies) or programmatically with `ebv_metadata()`. *(adapt `advanced-usage.qmd`, "Step 1 — the metadata JSON")*

**Checkpoint:** learner has a folder of aligned rasters (or the package's bundled example tifs), an entities list, and a metadata JSON — either their own, or one built by inspecting dataset 30's downloaded file.

---

## Unit 4 — Creating an EBVCube NetCDF using the R package

**Objectives:** run the four-step creation pipeline end-to-end and produce a valid netCDF.

1. Step 1 recap — metadata JSON in hand (from Unit 3).
2. Step 2 — `ebv_create()`: write the empty, structurally valid netCDF from the JSON + entities + spatial parameters. *(adapt `advanced-usage.qmd`, "Step 2 — `ebv_create()`", full runnable code block)*
3. Step 3 — `ebv_add_data()`: fill cubes entity-by-entity (and optionally time-slice-by-time-slice); note it appends rather than overwrites. *(adapt `advanced-usage.qmd`, "Step 3", full runnable code block)*
4. Step 4 — `ebv_attribute()`: fix a wrong unit/description/title after the fact without rebuilding. *(adapt `advanced-usage.qmd`, "Step 4")*
5. Special case: taxonomic/species-level datasets — `ebv_create_taxonomy()` instead of `ebv_create()`, with a taxonomy CSV. *(adapt `advanced-usage.qmd`, "Taxonomic datasets")* — flag this as directly relevant since dataset 30 is a community-composition (species-level) product.
6. Sanity-check the result immediately: `ebv_properties()`, `ebv_datacubepaths()`. *(adapt `advanced-usage.qmd` callout tip)*

**Checkpoint:** learner has produced their own `.nc` file and can list its datacube paths.

**Optional enrichment:** short callout on opening the new file in [Panoply](https://www.giss.nasa.gov/tools/panoply/) to see the group hierarchy visually — good for learners who like a GUI confirmation before trusting the R output.

---

## Unit 5 — Validating the generated file

**Objectives:** confirm the file is portal-ready before attempting upload.

1. Structural self-checks in R: `ebv_properties()` slot by slot (general/spatial/temporal/metric/scenario/ebv_cube), confirming entity names, CRS, timesteps, and units all match what was intended. *(adapt `core-concepts.qmd`, "Metadata" table)*
2. Visual check: `ebv_map()` on one entity/time step — does the map look geographically sane (no 180° shift, no obviously wrong classes)? *(adapt `faq.qmd`, "The map looks shifted by 180°")*
3. Cross-check against the source metadata JSON: does `entities` length match? Does every declared metric have a populated cube (no all-fillvalue cubes left over from a skipped `ebv_add_data()` call)?
4. External validation options: open in Panoply; if the portal exposes a validator endpoint/step during upload, run it before the final submit.
5. A short "pre-flight checklist" callout box summarizing 1–4 as tick boxes.

**Checkpoint:** learner can state, in their own words, why each of the five checks matters and has run all of them on their file.

---

## Unit 6 — Uploading the dataset to the EBV Data Portal

**Objectives:** submit a dataset through the portal UI and understand its review lifecycle.

1. Account & login: register at members.geobon.org if new, then sign in on the portal.
2. Start a new dataset submission; fill in the metadata form (general info, EBV class, spatial/temporal extent, entities) — cross-reference: this is the same form that can export the JSON used in Unit 3/4, so returning users can go form → JSON → `ebv_create()` → back to the portal to attach the final file.
3. Upload the netCDF produced in Unit 4; upload a preview image (JPG/PNG) representing the dataset.
4. Dataset status states observed on the portal: **Draft** (submitter can still edit) → **Submit for review** → published/versioned. Explain what changes at each state and who can still edit.
5. Versioning: the portal supports multiple versions of the same dataset (e.g. dataset 30 currently shows "Initial Version," 1 version available) — explain when to add a new version vs. create a new dataset entry.
6. After publication: DOI assignment, citation format, and how the dataset appears on Discover/Map.

**Checkpoint:** learner has either completed a real submission (draft state) or can walk through each screen using dataset 30's page as a worked reference.

**Screenshots needed:** login/register screen, submission form (general info / EBV attributes / entities tabs — mirrors the tab structure visible on the dataset-30 detail page), status-change dialog, published dataset page.

---

## Unit 7 — Troubleshooting common issues and best practices

**Objectives:** resolve the errors most users hit, without re-reading the whole tutorial.

Organize as a categorized FAQ, largely reusable from the existing docs:

- **Installation** — missing Bioconductor packages, R version too old, Linux HDF5/GDAL compile failures, HDF5 version mismatch. *(adapt `faq.qmd`, "Installation" section wholesale)*
- **Creating data** — `entities` length mismatch with metadata JSON; `ebv_add_data()` dimension mismatch (misaligned CRS/extent — fix with `terra::project()`); wrong units/titles after creation (fix with `ebv_attribute()`, no rebuild needed). *(adapt `faq.qmd`, "Creating data" section)*
- **Validating** — map looks shifted 180° (longitude convention); reading a shapefile subset returns all `NA` (CRS mismatch or no overlap). *(adapt `faq.qmd`, "Reading data" section, reframed as validation issues)*
- **Uploading/portal-specific** — new content to write: file size limits, unsupported CRS/EBV class combinations, what to do if the submission gets stuck in review, who to contact for portal-side errors (vs. package-side errors).
- **Performance** — slow reads on network drives; slow plotting at full resolution. *(adapt `faq.qmd`, "Performance" section)*
- **Best practices box:** keep a local copy of the metadata JSON and the pre-upload netCDF; version-control your creation script; re-run Unit 5's checklist after any edit; cite the dataset DOI (not the package) when referring to your published data. *(adapt `faq.qmd`, "Citation, licensing and contribution")*

**Checkpoint:** none — this is a reference unit, findable via search/anchors rather than read linearly.

---

## Unit 8 — Additional resources, documentation, repositories, and references

**Objectives:** give learners a map of where to go next.

- **`ebvcube` R package** — <https://github.com/EBVcube/ebvcube> (source, issues, discussions), [CRAN](https://cran.r-project.org/package=ebvcube), [b-cubed r-universe](https://b-cubed-eu.r-universe.dev/ebvcube).
- **`ebvcube` documentation book** — <https://EBVcube.github.io/ebvcube/> — full function reference (installation, core concepts, getting started, key functions, visualisation, advanced usage, FAQ).
- **EBV netCDF format specification** — <https://github.com/EBVcube/EBVCube-format>.
- **EBV Data Portal** — <https://portal.geobon.org/> — Discover, Map, How-to.
- **GEO BON — What are EBVs?** — <https://geobon.org/ebvs/what-are-ebvs/>.
- **Example dataset used throughout this tutorial** — Martins, I., Pereira, H. (2022). *Global trends in biodiversity (BES-SIM cSAR-iDiv)* (Version 1) [Dataset]. iDiv. <https://doi.org/10.25829/5zmy41>.
- **Methods paper** — Quoss et al. (2022), the ebvcube/format design paper (full citation from `references.bib` in `ebvcube-docs`).
- **Getting help** — GitHub issues (bug reports with `sessionInfo()` + reproducible example), GitHub Discussions, portal contact for dataset-specific/review questions.

---

## Notes for the writer, not for learners

- **Repo strategy:** see `repo-strategy.md` — recommend a new dedicated repo for this tutorial, cross-linking rather than duplicating `ebvcube-docs` content.
- **Screenshots:** Units 1 and 6 need real portal screenshots; I could not access the linked NaturaConnect example course to confirm its exact visual template (it required login), so screenshot framing above follows general instructional-design defaults (one annotated screenshot per major screen/action). Worth a quick look once you're logged in, to match callout style/length to NaturaConnect's existing units.
- **Length:** Units 1–2 and 7–8 are short/reference-like; Units 3–6 are the core hands-on material and will be the longest.
- **Dataset choice, double-checked:** I verified this carefully because it's easy to get wrong. Dataset ID 30 (Martins & Pereira, "Global trends in biodiversity," BES-SIM) is **not** the same dataset as the one bundled in the package. The bundled `martins_comcom_subset.nc` is a subset of portal ID 1, "Local bird diversity (cSAR/BES-SIM)" — same lead author and model family, different product and different time span (1900–2015 vs. 1900–2050). I've made this distinction explicit up top and in Unit 3 rather than silently conflating the two, since a learner who checks the bundled file's title against dataset 30's portal page would otherwise notice they don't match.
