# Board reader query tool - Shiny App:
# loading necessary libraries
library(RCurl)
library(stringi)
library(stringr)
library(rjson)
#library(qdap)
#library(tm)
#library(RWeka)

shinyServer(function(input, output) {

br.response <- ""
table.result <- ""

  output$table <- renderTable({

    input$goButton | input$goButtonFull
    br.response <<- isolate(board.reader.result(queryTerm = input$searchquery, search_api = input$searchapi, api_key = input$apikey, days_back = input$daysbackslider, offset = 0))
    table.result <- result.to.frame(br.response)

    })

  output$res <- renderText({

    input$goButton | input$goButtonFull
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

  output$topStats <- renderTable({

    input$goButton | input$goButtonFull
    as.character(paste("There are", getTotal(br.response), "total results."))

    })
  
})