

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


#
Sys.sleep(5)

tcltk::tkconfigure(stat, text = "Starting ...")
