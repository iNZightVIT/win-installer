# this file should always be called from a subdirectory
setwd('..')


options(
	help_type = 'html',
	inzight.disable.bootstraps = TRUE,
	inzight.lock.packages = TRUE,
	inzight.default.dev.features = TRUE,
	inzight.default.multiple_x = TRUE
)

Sys.setenv(
	'R_HOME' = file.path(getwd(), 'R'),
	'R_USER_CONFIG_DIR' = file.path(getwd(), ".config"),
	'R_USER_CACHE_DIR' = file.path(getwd(), ".cache"),
	'R_USER_DATA_DIR' = file.path(getwd(), "data"),
	'INZIGHT_MODULES_DIR' = file.path(getwd(), "modules"),
	'R_CACHE_ROOTPATH' = file.path(getwd(), ".cache")
)

#### Notes
# * datalab wont allow installing packages ... will need to modify everywhere (e.g., modules)
#   that tries to do so.
#

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
					"inzight-banner_guinz.png"
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
		utils::packageVersion("iNZight") > numeric_version('4.1.4')) {

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
	current <- utils::packageVersion('iNZightUpdate')
	ap <- utils::available.packages(repos = options()$repos[1])
	if ("iNZightUpdate" %in% rownames(ap)) {
		latest <- ap['iNZightUpdate', 'Version']
		if (current < numeric_version(latest))
			utils::install.packages('iNZightUpdate')
	}

	# then run the updater
	iNZightUpdate::update("windows")
}
