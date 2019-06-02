## The windows updater is going to be individual

update_inzight <- function() {
	update.packages(ask = FALSE, type = 'binary')
}

update_inzight()
