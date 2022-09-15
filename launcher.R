# this file should always be called from a subdirectory
setwd("..")


options(
    help_type = "html",
    inzight.disable.bootstraps = TRUE,
    inzight.lock.packages = TRUE,
    inzight.default.dev.features = TRUE,
    inzight.default.multiple_x = TRUE
)

Sys.setenv(
    "R_HOME" = file.path(getwd(), "R"),
    "R_USER_CONFIG_DIR" = file.path(getwd(), ".config"),
    "R_USER_CACHE_DIR" = file.path(getwd(), ".cache"),
    "R_USER_DATA_DIR" = file.path(getwd(), "data"),
    "INZIGHT_MODULES_DIR" = file.path(getwd(), "modules"),
    "R_CACHE_ROOTPATH" = file.path(getwd(), ".cache")
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
.libPaths(file.path(getwd(), "library"))

## ------------------------------------------------------------------------themeing
guinz_palette <- list(
    primary = c("#004775", "#00a9e9", "#39b54a"),
    secondary = c("#6f818e", "#fdb913", "#d2232a")
)

## custom ggplot theme - this will be applied as the 'default'
theme_guinz <- function() {
    ggplot2::theme_classic(
        base_family = "Myriad Pro"
    ) +
        ggplot2::theme(
            legend.position = "bottom",
            axis.line = ggplot2::element_blank(),
            axis.ticks = ggplot2::element_blank(),
            panel.grid.major.x = ggplot2::element_line(
                size = 0.5,
                color = "gray80"
            ),
            panel.background = ggplot2::element_rect(fill = "white")
        )
}
## override the default ggplot2 bar colour - use similar commands to adjust other colours
ggplot2::update_geom_defaults("bar", list(fill = guinz_palette$primary[2]))
ggplot2::theme_set(theme_guinz())

## set default colour palettes for iNZight and ggplot2
cat_pal <- c(guinz_palette$primary[1:2], guinz_palette$secondary, guinz_palette$primary[3])
options(
    inzight.default.palette.cat = cat_pal,
    inzight.default.par = iNZightPlots::inzpar(
        bar.fill = guinz_palette$primary[2]
    ),
    inzight.default.plottypes = list(
        cat = "gg_column",
        catcat = "gg_column",
        num = "gg_density"
    ),
    inzight.default.ggtheme.name = "GUiNZ",
    inzight.default.palette.cat.name = "GUiNZ",
    ggplot2.discrete.fill = cat_pal,
    # if users try plotting a combination of cat/num vars, the numeric ones will be removed from the plot
    inzight.auto.remove.noncatvars = TRUE
)

start_app <- function(app = c("inzight", "vit", "update")) {
    app <- match.arg(app)

    if (app == "update") {
        do_update()
        return()
    }

    # display loading screen
    grDevices::dev.new(width = 5, height = 2)
    grid::grid.newpage()
    # Will try to draw a raster if possible, otherwise an array of pixels

    try(
        {
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
        },
        silent = TRUE
    )

    message("(Dept of Statistics, Uni. of Auckland)")
    message("")
    message(
        sprintf(
            "Please wait while %s loads...",
            switch(app,
                "inzight" = "iNZight",
                "vit" = "VIT"
            )
        )
    )

    # load iNZight/VIT
    suppressMessages(
        suppressWarnings({
            switch(app,
                "inzight" = library(iNZight),
                "vit" = library(vit)
            )
        })
    )

    # Killing the splash screen, assigning to remove print
    tmp <- grDevices::dev.off()
    rm(tmp)

    awin <- NULL
    if (app == "inzight" &&
        utils::packageVersion("iNZight") > numeric_version("4.1.4")) {
        awin <- iNZight:::iNZAboutWidget$new(
            title = "Loading iNZight ..."
        )
    }

    suppressWarnings(
        switch(app,
            "inzight" = iNZight(dispose_fun = q, save = "no"),
            "vit" = iNZightVIT(dispose = TRUE)
        )
    )

    if (!is.null(awin)) dispose(awin$win)
}

do_update <- function() {
    # update the updater if any updates are available
    cat("* Checking if the updater needs updating ...\n")
    current <- utils::packageVersion("iNZightUpdate")
    ap <- utils::available.packages(repos = options()$repos[1])
    if ("iNZightUpdate" %in% rownames(ap)) {
        latest <- ap["iNZightUpdate", "Version"]
        if (current < numeric_version(latest)) {
            utils::install.packages("iNZightUpdate")
        }
    }

    # then run the updater
    iNZightUpdate::update("windows")
}
