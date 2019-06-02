# this file should always be called from a subdirectory
setwd('..')


options(
	repos = c(
		inzight = 'https://r.docker.stat.auckland.ac.nz',
		CRAN = 'https://cran.rstudio.com'
	),
	help_type = 'html'
)

# is this really necessary ???
Sys.setenv(
	'R_HOME' = file.path(getwd(), 'R')
)

# set library path
.libPaths(file.path(getwd(), 'library'))


start_app <- function(app = c('inzight', 'vit', 'update')) {
	app = match.arg(app)

	if (app == 'update') {
		do_update()
		return()
	}

	# display loading screen
	grDevices::dev.new(width = 5, height = 2)
	grid::grid.newpage()
	# Will try to draw a raster if possible, otherwise an array of pixels

	try({
		suppressWarnings({
			splashImg <- png::readPNG(
				file.path(
					getwd(), 
					"inst", 
					"inzight-banner.png"
				),
			    exists("rasterImage")
			)
		})
		grid::grid.raster(splashImg)
	}, silent = TRUE)

	message("(Dept of Statistics, Uni. of Auckland)")
	message("")
	message(
		sprintf("Please wait while %s loads...",
			switch(app, 'inzight' = 'iNZight', 'vit' = 'VIT')
		)
	)

	# load iNZight/VIT
	suppressMessages(
		suppressWarnings({
			switch(app,
	  			'inzight' = library(iNZight),
	  			'vit' = library(vit)
			)
		})
	)

	# Killing the splash screen, assigning to remove print
	tmp <- grDevices::dev.off()
	rm(tmp)

	suppressWarnings(
		switch(app,
			'inzight' = iNZight(disposeR = TRUE),
			'vit' = iNZightVIT(disposeR = TRUE)
		)
	)
}

do_update <- function() {
	source(
		'https://raw.githubusercontent.com/iNZightVIT/win-installer/master/update.R'
	)
}