library(shiny)
library(magrittr)
library(dplyr)

ui <- fluidPage(
  h3("Compare strings using longest common subsequence."),

  tags$style(HTML("
    .shiny-input-container:not(.shiny-input-container-inline) {
      width: 100%;
  }")),

   checkboxInput("caseSens", label = "Ignore case?", value = TRUE),
   fluidRow(
     column(6,
        textAreaInput(inputId = "textA", label = "Text A", rows = 10, value = "Lorem ipsum", width = "100%"),
        htmlOutput("resultA")
     ),
     column(6,
        textAreaInput(inputId = "textB", label = "Text B", rows = 10, value = "Lore ipsum", width = "100%"),
        htmlOutput("resultB")
     )
   ),
   verbatimTextOutput("lcs")

)

# Define server logic required to draw a histogram
server <- function(input, output) {

  lcsResult <- reactive({
    req(nchar(input$textA) > 0)
    req(nchar(input$textB) > 0)

    ta <- input$textA
    tb <- input$textB

    if(input$caseSens) {
      ta <- tolower(ta)
      tb <- tolower(tb)
    }
    longest_common_seq(ta, tb)

  })

  colors <- reactive({
    req(lcsResult())
    result <-  attr(lcsResult(), "meta")[["codes"]]
    colors <- case_when(
      result == 0 ~ "#e0e0d1",
      result == 1 ~ "#ffff99",
      result == 2 ~ "#99bbff",
      result == 3 ~ "#ff9999")
    colors
  })


  output$resultA <- renderUI({
    req(lcsResult())
    target <- attr(lcsResult(), "meta")[["sx"]]

    targetHtml <- sapply(
      seq_along(target),
      function(i) as.character(
        h3(
          style = paste(
            paste0(
              "background-color:",
              colors()[[i]],
              ";display:inline;overflow:hidden;padding: 0px; margin: 0px;")),
          target[[i]]))
    ) %>% paste(collapse = "")

    HTML(targetHtml)
  })



  output$resultB <- renderUI({
    req(lcsResult())
    target <- attr(lcsResult(), "meta")[["sy"]]
    userValueHtml <- sapply(
      seq_along(target),
      function(i) as.character(
        h3(
          style = paste(
            paste0(
              "background-color:",
              colors()[[i]],
              ";display:inline;overflow:hidden;padding: 0px; margin: 0px;")),
          target[[i]]))
    ) %>% paste(collapse = "")
    HTML(userValueHtml)
  })

  output$lcs <- renderText({
    req(lcsResult())
    as.character(lcsResult())
  })

}

# Run the application
shinyApp(ui = ui, server = server)

