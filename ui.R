require(shiny)


shinyUI(pageWithSidebar(
  headerPanel(title = 'BoardReader Interactive Query Tool'
           ),
  
  sidebarPanel(
      tabsetPanel(
      id = "tabs",
      tabPanel(
        "Find Mentions",
        textInput("apikey", "API Key:", ""),
        textInput("searchquery", "Query:", ""),
        helpText("Enter a search term, and choose what channel to search"),
        actionButton("goButton", "Search")
      ),
      tabPanel(
        "Word count",
        textInput("wordcountquery", "Terms:", "Enter terms here"),
        helpText("Enter terms to search for"),
        actionButton("countButton", "Search")
        )
    ),
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