# Board reader query tool - Shiny App:
# loading necessary libraries
library(RCurl)
library(stringi)
library(stringr)
library(rjson)

shinyServer(function(input, output) {

br.response <- ""

  output$table <- renderTable({

    input$goButton
    br.response <<- isolate(board.reader.result(queryTerm = input$searchquery, search_api = "Reviews", api_key = input$apikey))
    table.result <- result.to.frame(br.response)

    })

  output$res <- renderText({

    input$goButton
    format.describe(br.response)

    })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(result.to.frame(br.response), file)
    }
  )
  
})