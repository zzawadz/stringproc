#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
longest_common_seq <- function(x, y) {

  res <- stringproc:::longest_common_subseq(x, y)
  res <- strsplit(res, split = "")

  rx <- res[[1]]
  ry  <- res[[2]]

  if(length(rx) > length(ry)) {
    ry <- c(ry, rep("-", length(rx) - length(ry)))
  }

  if(length(rx) < length(ry)) {
    rx <- c(rx, rep("-", length(ry) - length(rx)))
  }


  result <- rep(0, length(ry))

  result[ry == "-"] <- 1
  result[rx == "-"]  <- 2

  result[(rx != ry) & result == 0] <- 3

  meta <- list(
    sx = rx,
    sy = ry,
    codes = result
  )

  lseq <- paste(rx[result == 0], collapse = "")
  attr(lseq, "meta") <- meta
  attr(lseq, "class") <- "longestCommonSeq"
  lseq
}