options(
  repos = c(
    inzight = "https://r.docker.stat.auckland.ac.nz",
    CRAN = "https://cloud.r-project.org"
  )
)

inz_pkgs <- c(
  "iNZight",
  "iNZightPlots",
  "iNZightMR",
  "iNZightTS",
  "iNZightTools",
  "iNZightRegression",
  "vit",
  "FutureLearnData",
  "iNZightUpdate"
)

if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak", type = "source")
}

# install iNZight packages (except iNZightModules)
pak::pak(inz_pkgs)
# install.packages(
#   inz_pkgs,
#   dependencies = TRUE,
#   type = "binary"
# )

if (!requireNamespace("iNZight")) {
  stop("iNZight not installed")
}

# install iNZightModules, and manually some of the dependencies
# (basically, ensuring iNZightMaps and sf aren't installed)
pak::pak(c("iNZightModules", "rgl", "mgcv"))
# install.packages(
#   c(
#     "iNZightModules",
#     "rgl",
#     "mgcv"
#   ),
#   type = "binary"
# )

# create directories
# dir.create(file.path(".cache", "R", "iNZight"), recursive = TRUE)
# dir.create(file.path(".config", "R", "iNZight"), recursive = TRUE)
# writeLines("list()\n", file.path(".config", "R", "iNZight", "preferences.R"))
