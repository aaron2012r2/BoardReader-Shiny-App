require(shiny)


shinyUI(pageWithSidebar(
  headerPanel(title = 'BoardReader Interactive Query Tool'
           ),
  
  sidebarPanel(
      tabsetPanel(
      id = "tabs",
      tabPanel(
        "Find Mentions",
        helpText(""),
        helpText("Enter your API key for BoardReader"),
        textInput("apikey", "API Key:", ""),
        helpText("Enter the terms for your search"),
        textInput("searchquery", "Query:", ""),
        helpText("Choose how many days back to search"),
        sliderInput("daysbackslider", label = "Days Back", min = 30, 
        max = 90, value = 30),
        radioButtons("searchapi", "Area to search:", c("Boards" = "Boards", "Blogs" = "Blogs", "News" = "News", "Video" = "Video", "Reviews" = "Reviews")),
        helpText("Quick search for the first 100 results"),
        actionButton("goButton", "Quick Search", icon = icon("search")),
        helpText(""),
        helpText(""),
        helpText("To obtain all results, run a full search below"),
        actionButton("goButtonFull", "Full Search", icon = icon("search"))
      )
    ),
      helpText(""),
      helpText("To download the results as a CSV, click below"),
              downloadLink("downloadData", "Download")
  ),
  
  mainPanel(
    h2("Results"),
    hr(),

    uiOutput("topStats"),
    hr(),
    
    uiOutput("table"),
    hr(),
    
    h3("Query and Debug Information:"),
    uiOutput("res")
    
  )
))