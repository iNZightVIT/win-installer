repo <- "https://r.docker.stat.auckland.ac.nz"

# update the updater if any updates are available
cat("* Checking if the updater needs updating ...\n")
utils::update.packages("iNZightUpdate", repos = repo)

# then run the updater
iNZightUpdate::update("windows")
