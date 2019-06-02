options(
  repos = c(
    inzight = 'https://r.docker.stat.auckland.ac.nz',
    CRAN = 'https://cran.rstudio.com'
  )
)

install.packages(
  c(
    'iNZight',
    'iNZightModules',
    'iNZightPlots',
    'iNZightMR',
    'iNZightTS',
    'iNZightTools',
    'iNZightRegression',
    'vit',
    'FutureLearnData'
   ),
   dependencies = TRUE,
   type = "binary"
)
