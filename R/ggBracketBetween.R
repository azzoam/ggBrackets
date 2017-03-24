#' Draw bracket between samples
#'
#' ggplot2 layer to draw a bracket between two samples in a bargraph.  Used in conjunction with gg_ttest_between().
#' @param data The dataframe used in the plot
#' @param sample_col Column name of the samples in data
#' @param sample1 The first sample to be compared
#' @param sample2 The second sample to be compared
#' @param mean_col Column name of the dependent variable means. Usually the y-axis of the bargraph.
#' @param group_col Optional -- Column name of the sample groups if applicable.  Leave NA if there are no groups.
#' @param group1 Optional -- The group to which the first sample belongs.  Leave NA if there are no groups.
#' @param group2 Optional -- The group to which the second sample belongs.  Leave NA if there are no groups.
#' @param dodge.width Optional -- The width of position_dodge() in the ggplot if groups are present.  Usually 0.9.
#' @param extra_y_space Optional -- Numeric to adjust position of the bracket up or down from its default location.
#' @param ... Additional optional parameters/asthetics.  e.g. color for font color or size for font size.
#' @return ggplot2 annotation layer
#' @export
gg_bracket_between <- function(data, sample_col, sample1, sample2, mean_col, group_col = NA,
                               group1 = NA, group2 = NA, dodge.width = 0.9, extra_y_space = 0,
                               ...)
{
    if(!is.na(group_col))
    {
        n <- length(levels(data[,group_col]))
        dex1 <- match(group1, levels(data[,group_col]))
        dex_sample1 <- match(sample1, levels(data[,sample_col]))
        x_dodge_start <- (((dodge.width - dodge.width*n) / (2*n)) + ((dex1 - 1) * (dodge.width / n))) + dex_sample1
        dex2 <- match(group2, levels(data[,group_col]))
        dex_sample2 <- match(sample2, levels(data[,sample_col]))
        x_dodge_end <- (((dodge.width - dodge.width*n) / (2*n)) + ((dex2 - 1) * (dodge.width / n))) + dex_sample2

        m1 <- data[data[,sample_col] == sample1 & data[,group_col] == group1, mean_col]
        m2 <- data[data[,sample_col] == sample2 & data[,group_col] == group2, mean_col]

        ymax <- max(c(m1, m2))

    } else
    {
        x_dodge_start <- match(sample1, levels(data[,sample_col]))
        x_dodge_end <- match(sample2, levels(data[,sample_col]))

        m1 <- data[data[,sample_col] == sample1, mean_col]
        m2 <- data[data[,sample_col] == sample2, mean_col]

        ymax <- max(c(m1, m2))

    }
    a <- annotate("segment",
                  x=c(x_dodge_start, x_dodge_start, x_dodge_end),
                  xend=c(x_dodge_start, x_dodge_end, x_dodge_end),
                  y= c((ymax*1.15) + extra_y_space, (ymax*1.20) + extra_y_space, (ymax*1.20) + extra_y_space),
                  yend=c((ymax*1.20) + extra_y_space, (ymax*1.20) + extra_y_space,(ymax*1.15) + extra_y_space),
                  ...)
    return(a)
}
