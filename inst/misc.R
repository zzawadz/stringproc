res <- reactive({ longest_common_subseq(y(), x()) })
resSplit <- reactive({
  req(res())
  strsplit(res(), split = "")
})

result <- reactive({

  target <- resSplit()[[1]]
  userValue  <- resSplit()[[2]]
  result <- rep(0, length(target))

  result[target == "-"] <- 1
  result[userValue == "-"]  <- 2

  result[(target != userValue) & result == 0] <- 3
  result
})

colors <- reactive({
  req(result())
  result <-  result()
  colors <- case_when(
    result == 0 ~ "#e0e0d1",
    result == 1 ~ "#ffff99",
    result == 2 ~ "#99bbff",
    result == 3 ~ "#ff9999")
  colors
})

output$resultTarget <- renderUI({
  req(result())
  target <- resSplit()[[1]]

  targetHtml <- sapply(
    seq_along(result()),
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



output$resultInput <- renderUI({
  req(result())
  userValue  <- resSplit()[[2]]
  userValueHtml <- sapply(
    seq_along(result()),
    function(i) as.character(
      h3(
        style = paste(
          paste0(
            "background-color:",
            colors()[[i]],
            ";display:inline;overflow:hidden;padding: 0px; margin: 0px;")),
        userValue[[i]]))
  ) %>% paste(collapse = "")
  HTML(userValueHtml)
})
