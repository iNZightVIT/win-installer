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

	libname <- pkgname <- app
	if (app == "inzight") libname <- pkgname <- "iNZight"
	if (app == "vit") pkgname <- "VIT"

	version <- packageVersion(libname)
	date <- as.Date(packageDescription(libname)$Date)

	tt <- tcltk::tktoplevel(
		background = "white"
	)
	tcltk::tkwm.title(tt, glue::glue("{pkgname} {version}"))

	# logo
	tcltk::tcl("image", "create", "photo", "inzlogo",
		file = file.path(getwd(), "inst", "inzight_logo.png"))
	l <- tcltk::ttklabel(tt,
		image = "inzlogo",
		compound = "image",
		background = "white"
	)
	tcltk::tkpack(l, padx = 100, pady = c(50, 10))

	# version info
	v <- tcltk::tklabel(tt,
		text = glue::glue(
			"Version {version} - Released {format(date, '%e %b, %Y')}"
		),
		background = "white"
	)
	tcltk::tkpack(v)

	# R info
	rv <- tcltk::tklabel(tt,
		text = glue::glue(
			"Running on R version {getRversion()}"
		),
		background = "white"
	)
	tcltk::tkpack(rv, pady = c(0, 10))

	# sponsors
	sp <- tcltk::tklabel(tt,
		text = "Sponsored by: ",
		background = "white",
		anchor = "w"
	)
	tcltk::tkpack(sp,
		padx = 10, pady = c(0, 10),
		fill = "x", expand = TRUE)

	sponsors <- readLines(file.path(getwd(), "inst", "sponsors.txt"))
	sp_list <- list()
	sf <- tcltk::tkframe(tt, background = "white")

	for (i in seq_along(sponsors)) {
		sponsor <- sponsors[[i]]
		if (sponsor == "") {
			tcltk::tkpack(sf)
			sf <- tcltk::tkframe(tt, background = "white")
			next()
		}

		tcltk::tcl("image", "create", "photo", sponsor,
			file = file.path(getwd(), "inst", "sponsors", sponsor))
		sp_list[[i]] <- tcltk::ttklabel(sf,
			image = sponsor,
			compound = "image",
			background = "white"
		)
		tcltk::tkpack(sp_list[[i]], side = "left",
			padx = 5, pady = 5)
	}
	tcltk::tkpack(sf)

	stat <- tcltk::tklabel(tt,
		text = "Loading ...",
		background = "#cccccc"
	)
	tcltk::tkpack(stat,
		pady = c(20, 0),
		expand = TRUE, fill = "x"
	)

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

	tcltk::tkconfigure(stat, text = "Starting ...")

	suppressWarnings(
		switch(app,
			'inzight' = iNZight(dispose_fun = q, save = "no"),
			'vit' = iNZightVIT(dispose = TRUE)
		)
	)

	# Killing the splash screen, assigning to remove print
	# on.exit(tcltk::tkdestroy(tt))

}

do_update <- function() {
	# update the updater if any updates are available
	cat("* Checking if the updater needs updating ...\n")
	utils::update.packages("iNZightUpdate", ask = FALSE)

	# then run the updater
	iNZightUpdate::update("windows")
}
