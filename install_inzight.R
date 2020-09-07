options(
  repos = c(
    inzight = "https://r.docker.stat.auckland.ac.nz",
    CRAN = "https://cloud.r-project.org"
  )
)

inz_pkgs <- c(
  'iNZight',
  'iNZightPlots',
  'iNZightMR',
  'iNZightTS',
  'iNZightTools',
  'iNZightRegression',
  'vit',
  'FutureLearnData',
  'iNZightUpdate'
)

# install iNZight packages (except iNZightModules)
install.packages(
  inz_pkgs
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
