# BoardReader Interactive Tool global


base_url <- "http://api.boardreader.com/v1/"
search_api <- "Boards"
end_search_url <- "/Search?key="
term_query_prefix <- "&query="
#criteria <- "&rt=json&body=full_text&highlight=0&limit=500"
criteria <- "&limit=500&rt=json&body=full_text&highlight=0&filter_country=us&offset=0"

board.reader.result <- function(queryTerm, search_api = "Boards", api_key) {
	if (queryTerm == "") {
		""
	} else {
    	queryTerm <- URLencode(queryTerm, reserved = TRUE)
    	send.url <- paste(base_url, search_api, end_search_url, api_key, term_query_prefix, queryTerm, criteria, sep = "")
    	response.set <- getURLContent(send.url)
    	response.set <- fromJSON(response.set)
	}

}

result.to.frame <- function(query.results) {

	if (!is.list(query.results)) {
		""
	} else {
		query.results <- query.results$response
		query.results <- query.results$Matches$Match
		this.result <- lapply(query.results, function(x) { x[sapply(x, is.null)] <- NA; unlist(x) })
    	as.data.frame(do.call("rbind", this.result), stringsAsFactors = FALSE)
	}

}


format.describe <- function(http.response) {

	if (!is.list(http.response)) {
		""
	} else {
		queries.used <- as.numeric(http.response$response$RequestsUsed)
		remaining.queries <- as.numeric(http.response$response$RequestsLimit)-queries.used
		avg.rating <- ""
		date.from <- as.numeric(http.response$response$Request$Actual$filter_date_from)
		date.from <- as.POSIXct(date.from, origin = "1970-01-01", tz = "GMT")
		date.to <- as.numeric(http.response$response$Request$Actual$filter_date_to)
		date.to <- as.POSIXct(date.to, origin = "1970-01-01", tz = "GMT")
		language <- http.response$response$Request$Actual$filter_language
		search.time <- http.response$response$SearchTime
		total.found <- http.response$response$TotalFound

		break.line <- "<br />"
		description <- paste("<b>Total Results: </b>", total.found, break.line, "<b>Queries Used: </b>", queries.used, break.line, "<b>Remaining Queries: </b>", remaining.queries, break.line, "<b>Average Rating: </b>", avg.rating, break.line, "<b>Date Range: </b>", date.from, " to ", date.to, break.line, "<b>Language: </b>", language, break.line, "<b>Time to search: </b>", search.time, break.line, sep = "")
	}

}


# Word Count function

get.freq.text <- function(text.source) {

    text.source <- tolower(text.source)
    words.list <- strsplit(text.source, "\\W+", perl = TRUE)
    words.vector <- unlist(words.list)
    freq.list <- table(words.vector)
    sorted.freq.list <- sort(freq.list, decreasing = TRUE)
    sorted.freq.list <- sorted.freq.list[!(names(sorted.freq.list) %in% stopwords.list$words)]

    # Pretty it up a little - I prefer vertical format
    df.freq <- as.data.frame(cbind(names(sorted.freq.list), sorted.freq.list), row.names = "", stringsAsFactors = FALSE)
    names(df.freq) <- c("word", "frequency")
    df.freq$frequency <- as.numeric(df.freq$frequency)
    df.freq <- df.freq[grep("^[a-z0-9]*$", df.freq$word, perl = TRUE),]
    df.freq

}