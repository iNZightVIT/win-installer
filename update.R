## The windows updater is going to be individual

update_inzight <- function() {
	if (VERSION < 1.3) {
		## not sure how you got here ... uh oh!

		return()
	}

	update.packages(ask = FALSE, type = 'binary')
}

update_inzight()
