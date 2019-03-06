#' Make a new block
#'
#' @param type either 'brick' or 'plate' for now
#' @param length length of block
#' @param width width of block
#'
#' @return a new block
#' @export
#'
new_block <- function(type = c('brick', 'plate'),
                      length,
                      width) {
  type <- match.arg(arg = type)
  switch(EXPR = type,
         'brick' = new_brick(length = length,
                             width = width),
         'plate' = new_plate(length = length,
                             width = width))
}

new_brick <- function(length, width) {
  return(list(length = length,
              width = width,
              height = 1))
}

new_plate <- function(length, width) {
  stop("'new_plate' not yet implemented")
}

