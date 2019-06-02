# update R GUI setting
conf_file <- file.path('R', 'etc', 'Rconsole')
conf <- readLines(conf_file)


# --- turn off MDI
## comment MDI = yes
conf <- conf[!grepl('# MDI = no', conf)]
conf[grep('MDI = yes', conf)] <- '# MDI = yes'

## uncomment MDI = no
conf[grep('MDI = no', conf)] <- '  MDI = no'


# --- write settings 
writeLines(conf, conf_file)
