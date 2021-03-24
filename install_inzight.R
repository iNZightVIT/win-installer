options(
  repos = c(
    inzight = "https://r.docker.stat.auckland.ac.nz",
    CRAN = "https://cloud.r-project.org"
  )
)

# install iNZight packages (except iNZightModules)
install.packages(
  c(
    'iNZight',
    'iNZightPlots',
    'iNZightMR',
    'iNZightTS',
    'iNZightTools',
    'iNZightRegression',
    'vit',
    'FutureLearnData',
    'iNZightUpdate'
   ),
   dependencies = TRUE,
   type = "binary"
)

# install iNZightModules, and manually some of the dependencies
# (basically, ensuring iNZightMaps and sf aren't installed)
install.packages(
  c(
    'iNZightModules',
    'rgl',
    'mgcv'
  ),
  type = "binary"
)

# create directories
dir.create(file.path(".cache", "R", "iNZight"), recursive = TRUE)
dir.create(file.path(".config", "R", "iNZight"), recursive = TRUE)
writeLines("list()\n", file.path(".config", "R", "iNZight", "preferences.R"))
