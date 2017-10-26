require(shiny)


shinyUI(pageWithSidebar(
  headerPanel(title = 'BoardReader Interactive Query Tool'
           ),
  
  sidebarPanel(
      tabsetPanel(
      id = "tabs",
      tabPanel(
        "Find Mentions",
        helpText("Enter your API key for BoardReader"),
        textInput("apikey", "API Key:", ""),
        helpText("Enter the terms for your search"),
        textInput("searchquery", "Query:", ""),
        radioButtons("searchapi", "Area to search:", c("Boards" = "Boards", "Blogs" = "Blogs", "News" = "News", "Video" = "Video", "Reviews" = "Reviews")),
        actionButton("goButton", "Search", icon = icon("search"))
      ),
      tabPanel(
        "Word count",
        helpText("THIS FEATURE IS CURRENTLY UNAVAILABLE"),
        textInput("wordcountquery", "Terms:", "Enter terms here"),
        helpText("Enter terms to search for"),
        actionButton("countButton", "Search")
        )
    ),
      helpText(""),
      helpText("To download the results as a CSV, click below"),
              downloadLink("downloadData", "Download")
  ),
  
  mainPanel(
    h2("Results"),
    hr(),
    
    uiOutput("table"),
    hr(),
    
    h3("Content Description:"),
    uiOutput("res")
    
  )
))