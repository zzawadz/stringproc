#' Find longest common subsequence between two strings.
#'
#' @param x character string
#' @param y character string
#'
#' @return
#'
#' A longestCommonSeq object.
#'
#' @export
#'
#' @examples
#'
#' longest_common_seq(
#'   "Lorem dolor sit amet, consectetur adipiscing elit.",
#'   "Lorem ipsum dolor sit amet, eu erat sed felis pharetra.")
#'
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
    x = x,
    y = y,
    sx = rx,
    sy = ry,
    codes = result
  )

  lseq <- paste(rx[result == 0], collapse = "")
  attr(lseq, "meta") <- meta
  attr(lseq, "class") <- "longestCommonSeq"
  lseq
}

#' Print longestCommonSeq object
#'
#' @param x longestCommonSeq pbject
#'
#' @export
#'
#' @examples
#'
#' lcs <- longest_common_seq(
#'   "Lorem dolor sit amet, consectetur adipiscing elit.",
#'   "Lorem ipsum dolor sit amet, eu erat sed felis pharetra.")
#'
#' print(lcs)
#'
print.longestCommonSeq <- function(x) {
  cat("x:", attr(x, "meta")[["x"]], "\n")
  cat("y:", attr(x, "meta")[["y"]], "\n")
  cat("Longest Common Seq:", x, "\n")

  cat("Compare:\n")
  cat("  x:", paste(attr(x, "meta")[["sx"]], collapse = ""), "\n")
  cat("  y:", paste(attr(x, "meta")[["sy"]], collapse = ""), "\n")
  invisible(x)

}
