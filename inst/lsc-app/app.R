library(shiny)
library(dplyr)

ui <- fluidPage(
  # Custom CSS for modern UI
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

      body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px 0;
      }

      .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
      }

      .app-header {
        background: white;
        border-radius: 16px;
        padding: 30px;
        margin-bottom: 25px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
      }

      .app-title {
        font-size: 2.5rem;
        font-weight: 700;
        color: #2d3748;
        margin: 0 0 10px 0;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }

      .app-subtitle {
        font-size: 1.1rem;
        color: #718096;
        margin: 0;
        font-weight: 400;
      }

      .legend-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
      }

      .legend-title {
        font-size: 1rem;
        font-weight: 600;
        color: #2d3748;
        margin: 0 0 15px 0;
      }

      .legend-items {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
      }

      .legend-item {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 0.9rem;
        color: #4a5568;
      }

      .legend-color {
        width: 24px;
        height: 24px;
        border-radius: 6px;
        border: 2px solid #e2e8f0;
      }

      .input-card {
        background: white;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        height: 100%;
      }

      .card-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: #2d3748;
        margin: 0 0 15px 0;
      }

      .shiny-input-container:not(.shiny-input-container-inline) {
        width: 100%;
      }

      .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        font-family: 'Courier New', monospace;
        font-size: 0.95rem;
        transition: border-color 0.2s;
      }

      .form-control:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      }

      .checkbox {
        margin-bottom: 20px;
      }

      .checkbox label {
        font-weight: 500;
        color: #4a5568;
        cursor: pointer;
      }

      .result-container {
        background: #f7fafc;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        padding: 15px;
        margin-top: 20px;
        min-height: 100px;
        font-family: 'Courier New', monospace;
        font-size: 1.1rem;
        line-height: 1.8;
        word-break: break-all;
      }

      .result-char {
        display: inline-block;
        padding: 2px 4px;
        margin: 1px;
        border-radius: 3px;
        transition: transform 0.1s;
      }

      .result-char:hover {
        transform: scale(1.15);
        z-index: 10;
        position: relative;
      }

      .lcs-result-card {
        background: white;
        border-radius: 12px;
        padding: 25px;
        margin-top: 25px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
      }

      .lcs-title {
        font-size: 1.3rem;
        font-weight: 600;
        color: #2d3748;
        margin: 0 0 15px 0;
      }

      .lcs-content {
        background: #f7fafc;
        border: 2px solid #667eea;
        border-radius: 8px;
        padding: 15px;
        font-family: 'Courier New', monospace;
        font-size: 1.2rem;
        color: #2d3748;
        font-weight: 500;
        min-height: 50px;
      }

      .stats-container {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
        flex-wrap: wrap;
      }

      .stat-box {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 8px;
        padding: 15px 20px;
        color: white;
        flex: 1;
        min-width: 150px;
      }

      .stat-label {
        font-size: 0.85rem;
        opacity: 0.9;
        margin-bottom: 5px;
      }

      .stat-value {
        font-size: 1.8rem;
        font-weight: 700;
      }

      @media (max-width: 768px) {
        .app-title {
          font-size: 1.8rem;
        }

        .legend-items {
          flex-direction: column;
        }

        .stats-container {
          flex-direction: column;
        }
      }
    "))
  ),

  # Header
  div(class = "app-header",
    h1(class = "app-title", "String Comparison with Longest Common Subsequence"),
    p(class = "app-subtitle", "Visualize and analyze the differences between two strings using the LCS algorithm")
  ),

  # Legend
  div(class = "legend-card",
    h4(class = "legend-title", "Color Legend"),
    div(class = "legend-items",
      div(class = "legend-item",
        span(class = "legend-color", style = "background-color: #c8e6c9;"),
        span("Matching characters")
      ),
      div(class = "legend-item",
        span(class = "legend-color", style = "background-color: #fff59d;"),
        span("Only in Text B")
      ),
      div(class = "legend-item",
        span(class = "legend-color", style = "background-color: #90caf9;"),
        span("Only in Text A")
      ),
      div(class = "legend-item",
        span(class = "legend-color", style = "background-color: #ef9a9a;"),
        span("Non-matching characters")
      )
    )
  ),

  # Options
  div(class = "legend-card",
    checkboxInput("caseSens", label = "Ignore case sensitivity", value = TRUE)
  ),

  # Input columns
  fluidRow(
    column(6,
      div(class = "input-card",
        h4(class = "card-title", "Text A"),
        textAreaInput(inputId = "textA", label = NULL, rows = 10,
                     value = "The quick brown fox jumps over the lazy dog",
                     width = "100%",
                     placeholder = "Enter first text here..."),
        div(class = "result-container",
          htmlOutput("resultA")
        )
      )
    ),
    column(6,
      div(class = "input-card",
        h4(class = "card-title", "Text B"),
        textAreaInput(inputId = "textB", label = NULL, rows = 10,
                     value = "The quick brown fox jumped over a lazy dog",
                     width = "100%",
                     placeholder = "Enter second text here..."),
        div(class = "result-container",
          htmlOutput("resultB")
        )
      )
    )
  ),

  # Results
  div(class = "lcs-result-card",
    h3(class = "lcs-title", "Analysis Results"),
    div(class = "stats-container",
      uiOutput("statsBoxes")
    ),
    h4(style = "margin-top: 20px; margin-bottom: 10px; color: #4a5568; font-size: 1rem;",
       "Longest Common Subsequence:"),
    div(class = "lcs-content",
      verbatimTextOutput("lcs")
    )
  )
)

# Define server logic
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
    result <- attr(lcsResult(), "meta")[["codes"]]
    colors <- case_when(
      result == 0 ~ "#c8e6c9",  # Softer green for matching
      result == 1 ~ "#fff59d",  # Softer yellow
      result == 2 ~ "#90caf9",  # Softer blue
      result == 3 ~ "#ef9a9a"   # Softer red
    )
    colors
  })

  output$statsBoxes <- renderUI({
    req(lcsResult())

    lcs_length <- nchar(as.character(lcsResult()))
    text_a_length <- nchar(input$textA)
    text_b_length <- nchar(input$textB)

    # Calculate similarity percentage
    max_length <- max(text_a_length, text_b_length)
    similarity <- if(max_length > 0) round((lcs_length / max_length) * 100, 1) else 0

    tagList(
      div(class = "stat-box",
        div(class = "stat-label", "LCS Length"),
        div(class = "stat-value", lcs_length)
      ),
      div(class = "stat-box",
        div(class = "stat-label", "Similarity"),
        div(class = "stat-value", paste0(similarity, "%"))
      ),
      div(class = "stat-box",
        div(class = "stat-label", "Text A Length"),
        div(class = "stat-value", text_a_length)
      ),
      div(class = "stat-box",
        div(class = "stat-label", "Text B Length"),
        div(class = "stat-value", text_b_length)
      )
    )
  })

  output$resultA <- renderUI({
    req(lcsResult())
    target <- attr(lcsResult(), "meta")[["sx"]]

    targetHtml <- sapply(
      seq_along(target),
      function(i) {
        char <- target[[i]]
        # Handle special characters for HTML
        char <- gsub(" ", "&nbsp;", char)
        char <- gsub("\n", "<br>", char)

        as.character(
          tags$span(
            class = "result-char",
            style = paste0("background-color:", colors()[[i]], ";"),
            HTML(char)
          )
        )
      }
    ) |> paste(collapse = "")

    HTML(targetHtml)
  })

  output$resultB <- renderUI({
    req(lcsResult())
    target <- attr(lcsResult(), "meta")[["sy"]]

    userValueHtml <- sapply(
      seq_along(target),
      function(i) {
        char <- target[[i]]
        # Handle special characters for HTML
        char <- gsub(" ", "&nbsp;", char)
        char <- gsub("\n", "<br>", char)

        as.character(
          tags$span(
            class = "result-char",
            style = paste0("background-color:", colors()[[i]], ";"),
            HTML(char)
          )
        )
      }
    ) |> paste(collapse = "")

    HTML(userValueHtml)
  })

  output$lcs <- renderText({
    req(lcsResult())
    as.character(lcsResult())
  })
}

# Run the application
shinyApp(ui = ui, server = server)
