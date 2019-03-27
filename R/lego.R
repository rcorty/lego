#' Start a lego build
#'
#' @param length length of the build space, in studs
#' @param width width of the build space, in studs
#' @param height height of the build space, in studs
#'
#' @return a new [build] object
#' @export
#'
new_build <- function(length,
                      width,
                      height)
{
    return(
        list(grid = array(data = 0,
                          dim = c(length, width, height),
                          dimnames = c('length', 'width', 'height')),
             blocks = NULL)
    )
}

# better
new_build <-
    function(
        space = new_space(),
        blockset = new_blockset()
    )
    {
        list(
            space = space,
            blocks = blocks,
            valid_flag = TRUE
        )
    }

new_space <-
    function(
        width = 10,
        depth = 10,
        height = 10
    )
    {
        list(
            xmin = 0,
            width = width,
            xmax = width,
            ymin = 0,
            depth = depth,
            ymax = depth,
            zmin = 0,
            height = height,
            zmax = height
        )
    }

new_blockset <-
    function(
        name = 'classic_bucket'
    )
    {
        readr::read_csv(
            file = list.files(
                pattern = name,
                recursive = TRUE
            ),
            col_types = 'cciccccci'
        ) %>%
            dplyr::select(partID = PartID,
                          quantity = Quantity,
                          color = Colour,
                          designID = DesignID,
                          part_name = PartName)
    }

check_build <-
    function(
        build
    )
    {
        check_blocks_sufficient(build = build)
        check_for_collisions(build = build)
        check_for_unsupported_blocks(build = build)
        check_within_bounds(build = build)
        return(build)
    }


within_space <-
    function(
        block,
        space
    )
    {
        all(
            space$xmin < block$xmin,
            block$xmax < space$xmax,
            space$ymin < block$ymin,
            block$ymax < space$ymax,
            space$zmin < block$zmin,
            block$zmax < space$zmax
        )
    }

supports <-
    function(
        a,
        b
    )
    {
        # a and b must overlap in x and y plane
        # and the top of a must touch the bottom of b
        all(
            purrr::map_lgl(
                .x = c('x', 'y'),
                .f = overlaps,
                a = a,
                b = b
            ),
            a$zmax == b$zmin
        )
    }


collides_with <-
    function(
        a,
        b
    )
    {
        all(
            purrr::map_lgl(
                .x = c('x', 'y', 'z'),
                .f = overlaps,
                a = a,
                b = b
            )
        )
    }

overlaps <-
    function(
        a,
        b,
        dimension
    )
    {
        stopifnot(all(is_block(a), is_block(b)))

        switch(
            EXPR = dimension,
            x = max(a$xmin, b$xmin) < min(a$xmax, b$xmax),
            y = max(a$ymin, b$ymin) < min(a$ymax, b$ymax),
            z = max(a$zmin, b$zmin) < min(a$zmax, b$zmax)
        )
    }




#' Add a block to a build
#'
#' @param build the build to which the block will be added
#' @param block the block to add
#' @param where the [location] of the left, front, bottom
#'     corner of the block.  Must be a list of length 3 with
#'     names 'l', 'w', and 'h' and values between [0, 0, 0]
#'     and [length, width, height] of the build space.
#'
#' @return
#' @export
#'
#' @examples
add_block <- function(build,
                      block,
                      where)
{

    stopifnot(fits(block = block, build = build, where))

    new_block_id <- length(build$blocks) +1

    new_grid <- build$grid
    new_grid[where$l + block$length,
             where$w + block$width,
             where$h + block$height] <- new_block_id

    return(list(grid = new_grid,
                blocks = c(build$blocks, block)))
}



#' Add a wall to a build
#'
#' @param build the build to which the wall will be added
#' @param main_block the block to use for the most part
#'     (other blocks usually needed to fill in the edges)
#' @param offset how many studs forward to skip at each level
#' @param where_start location (list with elements 'l', 'w', 'h')
#'     where the wall starts
#' @param where_stop location (list with elements 'l', 'w', 'h')
#'     where the wall stops
#'
#' @return
#'
#' @importFrom dplyr %>%
#' @export
#'
add_wall <- function(build,
                     where_start,
                     where_stop,
                     main_block = new_block(type = 'brick',
                                            length = 4,
                                            width = 2),
                     offset = 2)
{

    if (grid_colinear(x = where_start, y = where_stop)) {
        stop('The start and stop location for this wall are colinear.')
    }
    if (!grid_coplanar(x = where_start, y = where_stop)) {
        stop('The start and stop location for this wall are not coplanar.')
    }
    current_where <- where_start

    # while loop
}



grid_colinear <- function(x, y) {
    sum(purrr::map2_int(x, y, `==`) == 2)
}
grid_coplanar <- function(x, y)
{
    sum(purrr::map2_int(x, y, `==`) == 1)
}