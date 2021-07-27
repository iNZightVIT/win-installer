# this file should always be called from a subdirectory
setwd('..')


options(
	repos = c(
		inzight = 'https://r.docker.stat.auckland.ac.nz',
		CRAN = 'https://cran.r-project.org'
	),
	help_type = 'html'
)

Sys.setenv(
	'R_HOME' = file.path(getwd(), 'R'),
	'R_USER_CONFIG_DIR' = file.path(getwd(), ".config"),
	'R_USER_CACHE_DIR' = file.path(getwd(), ".cache"),
	'R_USER_DATA_DIR' = file.path(getwd(), "data"),
	'INZIGHT_MODULES_DIR' = file.path(getwd(), "modules")
)

## Create directories if they don't already exist:
create_dir <- function(dir) if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
create_dir(tools::R_user_dir("iNZight", "config"))
create_dir(tools::R_user_dir("iNZight", "cache"))
create_dir(tools::R_user_dir("iNZight", "data"))

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

	awin <- NULL
	if (app == "inzight" &&
		utils::packageVersion("iNZight") > numeric_version('4.1.3')) {

		awin <- iNZight:::iNZAboutWidget$new(
			title = "Loading iNZight ..."
		)

	}

	suppressWarnings(
		switch(app,
			'inzight' = iNZight(dispose_fun = q, save = "no"),
			'vit' = iNZightVIT(dispose = TRUE)
		)
	)

	if (!is.null(awin)) dispose(awin$win)
}

do_update <- function() {
	# update the updater if any updates are available
	cat("* Checking if the updater needs updating ...\n")
	utils::update.packages("iNZightUpdate", ask = FALSE)

	# then run the updater
	iNZightUpdate::update("windows")
}
