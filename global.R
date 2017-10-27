# BoardReader Interactive Tool global


base_url <- "http://api.boardreader.com/v1/"
end_search_url <- "/Search?key="
term_query_prefix <- "&query="

board.reader.result <- function(queryTerm, search_api = "Boards", api_key, days_back = 30, offset = 0) {
	if (queryTerm == "") {
		""
	} else {
    	queryTerm <- URLencode(queryTerm, reserved = TRUE)
    	filter.from <- paste("&filter_date_from=", as.numeric(as.POSIXct(Sys.Date() - days_back)), sep = "")
    	filter.to <- paste("&filter_date_to=", as.numeric(as.POSIXct(Sys.Date())), sep = "")
    	criteria <- paste(filter.from, filter.to, "&limit=100&rt=json&body=full_text&highlight=0&filter_country=us&offset=", offset, sep = "")
    	send.url <- paste(base_url, search_api, end_search_url, api_key, term_query_prefix, queryTerm, criteria, sep = "")
    	response.set <- getURLContent(send.url)
    	response.set <- fromJSON(response.set)
	}

}

result.to.frame <- function(query.results) {

	if (!is.list(query.results)) {
		data.frame(Startup.Message = "Hello! Search using the sidebar, and results will display here.")
	} else {
		query.results <- query.results$response
		query.results <- query.results$Matches$Match
		this.result <- lapply(query.results, function(x) { x[sapply(x, is.null)] <- NA; unlist(x) })
    	as.data.frame(do.call("rbind", this.result), stringsAsFactors = FALSE)
	}

}


format.describe <- function(http.response) {

	if (!is.list(http.response)) {
		"Additional information about your query will appear here, such as remaining queries, date range, and more."
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

getTotal <- function(http.response) {

	if (!is.list(http.response)) {
		"0"
	} else {
		http.response$response$TotalFound
	}

}


gramify <- function(text.source, gramnum = 2) {
    tokenizer <- function(x) { NGramTokenizer(x, Weka_control(min = gramnum, max = gramnum)) }
    text.source <- as.data.frame(sapply(text.source, tolower), stringsAsFactors = FALSE)
    text.source <- as.data.frame(sapply(text.source, removeWords, stopwords("en")), stringsAsFactors = FALSE)
    text.source <- as.data.frame(sapply(text.source, stripWhitespace), stringsAsFactors = FALSE)
    thing.vectorsource <- VectorSource(text.source)
    thing.corpus <- VCorpus(thing.vectorsource)
    thing.dtm <- DocumentTermMatrix(thing.corpus, control = list(tokenize = tokenizer))
    ngram_dtm_m <- as.matrix(thing.dtm)
    freq <- colSums(ngram_dtm_m)
    ngram_words <- names(freq)
    df.words <- as.data.frame(cbind(ngram_words, freq), stringsAsFactors = FALSE)
    names(df.words) <- c("term", "freq")
    df.words$freq <- as.numeric(df.words$freq)
    df.words <- df.words[order(df.words$freq, decreasing = TRUE),]
    rownames(df.words) <- c(1:nrow(df.words))
    df.words
}