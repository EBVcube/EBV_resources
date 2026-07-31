# prepare-inputs.R
#
# Provenance script for Unit 4 ("Creating an EBVCube").
#
# It rebuilds the raster inputs used in the tutorial from the published
# dataset itself: "Local bird diversity (cSAR/BES-SIM)", EBV Portal id = 1,
# DOI 10.25829/8grx36. Each data cube is read back out of the netCDF and
# written to a multi-band GeoTIFF (one band per time step) in data/tifs/.
#
# Run this once from the project root. The GeoTIFFs it writes are the
# inputs that Unit 4 feeds to ebv_add_data(). Because they come straight
# from the published file, the cube rebuilt in Unit 4 can be checked back
# against the original.
#
# You only need to run this if data/tifs/ is missing or you want to
# regenerate it; the tutorial ships the resulting files in the repository.

library(ebvcube)
library(terra)

# --- Inputs and outputs -----------------------------------------------------

# The published netCDF. If it is not present yet, fetch it once with:
#   dir.create("data/ebv", recursive = TRUE, showWarnings = FALSE)
#   ebv_download(id = 1, outputdir = "data/ebv", overwrite = FALSE)
orig <- "data/ebv/martins_comcom_id1_20220208_v1.nc"

out_dir <- "data/tifs"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

stopifnot(file.exists(orig))

# --- Inspect the file -------------------------------------------------------

props    <- ebv_properties(orig, verbose = FALSE)
entities <- props@general$entity_names            # real entity names, in order
n_t      <- length(props@temporal$dates)          # number of time steps
dcs      <- ebv_datacubepaths(orig, verbose = FALSE)$datacubepaths

message(sprintf("Entities (%d): %s", length(entities),
                paste(entities, collapse = ", ")))
message(sprintf("Time steps : %d", n_t))
message("Data cubes :")
print(dcs)

# --- Helper: a filesystem-safe tag for an entity name -----------------------

entity_tag <- function(x) gsub("[^A-Za-z0-9]+", "-", tolower(x))

# --- Extract every (metric, entity) cube to a GeoTIFF -----------------------

for (dc in dcs) {
  # dc looks like "metric_1/ebv_cube"; pull out the metric number.
  m <- as.integer(sub("metric_(\\d+).*", "\\1", dc))

  for (e in seq_along(entities)) {
    # Read the cube for this entity across all time steps as a SpatRaster
    # (time steps come back as bands).
    r <- ebv_read(orig, dc, entity = e, timestep = 1:n_t,
                  type = "r", verbose = FALSE)

    f <- file.path(out_dir,
                   sprintf("metric_%d_%s.tif", m, entity_tag(entities[e])))
    terra::writeRaster(r, f, overwrite = TRUE)
    message("wrote ", f)
  }
}

message("Done. GeoTIFF inputs are in ", normalizePath(out_dir))
