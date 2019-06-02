# update R GUI setting
conf_file <- file.path('R', 'etc', 'Rconsole')
conf <- readLines(conf_file)


# --- turn off MDI
## comment MDI = yes
conf[grep('MDI = yes', conf)] <- '# MDI = yes'

## uncomment MDI = no
conf[grep('MDI = no', conf)] <- '  MDI = no'


# --- write settings 
writeLines(conf, conf_file)




# --- prettier GTK theme engine
gtk_file <- file.path('library', 'RGtk2', 'gtk', 'i386', 'etc', 'gtk-2.0', 'gtkrc')
writeLines('gtk-theme-name = "MS-Windows"', gtk_file)
