#' 2-sample t-test
#'
#' Function which performs a 2-sample t-test using sample statistics (mean, sd, n) instead of a lists of observations.  Not recommended for use outside gg_ttest_between().
#' @param mean1 Mean for sample 1
#' @param mean2 Mean for sample 2
#' @param sd1 Standard deviation for sample 1
#' @param sd2 Standard deviation for sample 2
#' @param n1 Number of replicates for sample 1
#' @param n2 Number of replicated for sample 2
#' @param m0 Difference in means to test for.  Default is 0.
#' @param equal.variance Optional -- Boolean for whether variances are equal.  TRUE results in a student's t-test.  FALSE results in a Welch test.  Defaults to TRUE.
#' @return Named list containing "Difference of means", "Std Error", "t", "df", and "p-value"
t_test2 <- function(mean1, mean2, sd1, sd2, n1, n2, m0 = 0, equal.variance = TRUE)
{
    if(equal.variance == FALSE)
    {
        se <- sqrt((sd1^2 / n1) + (sd2^2 / n2))
        # welch-satterthwaite df
        df <- ( ((sd1^2 / n1) + (sd2^2 / n2))^2 ) / ( (sd1^2 / n1)^2 / (n1 - 1) + (sd2^2 / n2)^2 / (n2 - 1) )
    } else
    {
        # pooled standard deviation, scaled by the sample sizes
        se <- sqrt( (1/n1 + 1/n2) * ((n1-1)*sd1^2 + (n2-1)*sd2^2)/(n1+n2-2) )
        df <- n1 + n2 - 2
    }
    t <- (mean1 - mean2 - m0) / se
    dat <- c(mean1 - mean2, se, t, df, 2*pt(-abs(t), df))
    names(dat) <- c("Difference of means", "Std Error", "t", "df", "p-value")
    return(dat)
}


#' Draw p-value between samples
#'
#' ggplot2 layer to perform a 2-sample t-test and plot the p-value between two samples in a bargraph.  Used in conjunction with gg_bracket_between().
#' @param data The dataframe used in the plot
#' @param sample_col Column name of the samples in data
#' @param sample1 The first sample to be compared
#' @param sample2 The second sample to be compared
#' @param mean_col Column name of the means of the observations. Usually the y-axis of the bargraph.
#' @param sd_col Column name for standard deviations of the observations.
#' @param n_col Column name for number of replicates in an observation.
#' @param group_col Optional -- Column name of the sample groups if applicable.  Leave NA if there are no groups.
#' @param group1 Optional -- The group to which the first sample belongs.  Leave NA if there are no groups.
#' @param group2 Optional -- The group to which the second sample belongs.  Leave NA if there are no groups.
#' @param equal.variance Optional -- Boolean for whether variances are equal.  TRUE results in a student's t-test.  FALSE results in a Welch test.  Defaults to TRUE.
#' @param dodge.width Optional -- The width of position_dodge() in the ggplot if groups are present.  Usually 0.9.
#' @param p_value_star Optional -- Boolean for whether to plot stars representing significance levels or actual p-values.  TRUE plots '*'.  FALSE plots p-values.  '*' = p-value < 0.05, '**' = p-value < 0.01, '***' = p-value < 0.001, 'n.s.' = not significant.
#' @param extra_y_space Optional -- Numeric to adjust position of the bracket up or down from its default location.
#' @param ... Additional optional parameters/asthetics.  e.g. color for font color or size for font size.
#' @return ggplot2 annotation layer
#' @export
gg_ttest_between <- function(data, sample_col, sample1, sample2, mean_col, sd_col, n_col, group_col = NA,
                             group1 = NA, group2 = NA, equal.variance = T, dodge.width = 0.9,
                             p_value_star = F, extra_y_space = 0, ...)
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
        sd1 <- data[data[,sample_col] == sample1 & data[,group_col] == group1, sd_col]
        n1 <- data[data[,sample_col] == sample1 & data[,group_col] == group1, n_col]

        m2 <- data[data[,sample_col] == sample2 & data[,group_col] == group2, mean_col]
        sd2 <- data[data[,sample_col] == sample2 & data[,group_col] == group2, sd_col]
        n2 <- data[data[,sample_col] == sample2 & data[,group_col] == group2, n_col]

        ymax <- max(c(m1, m2))

    } else
    {
        x_dodge_start <- match(sample1, levels(data[,sample_col]))
        x_dodge_end <- match(sample2, levels(data[,sample_col]))

        m1 <- data[data[,sample_col] == sample1, mean_col]
        sd1 <- data[data[,sample_col] == sample1, sd_col]
        n1 <- data[data[,sample_col] == sample1, n_col]

        m2 <- data[data[,sample_col] == sample2, mean_col]
        sd2 <- data[data[,sample_col] == sample2, sd_col]
        n2 <- data[data[,sample_col] == sample2, n_col]

        ymax <- max(c(m1, m2))
    }


    p <- t_test2(m1, m2, sd1, sd2, n1, n2, equal.variance = equal.variance)['p-value']
    p <- round(p, 5)
    if(p_value_star == T)
    {
        if(p > 0.05)
        {
            p <- 'n.s.'
        } else
        {
            if(p < 0.01)
            {
                if(p < 0.001)
                {
                    p <- '***'
                } else
                {
                    p <- '**'
                }
            } else
            {
                p <- '*'
            }
        }
    } else
    {
        p <- paste('p =', p, sep = ' ')
    }
    b <- annotate("text", x = mean(c(x_dodge_end, x_dodge_start)), y = (ymax*1.24) + extra_y_space,
                  label = p, ...)
    return(b)
}
