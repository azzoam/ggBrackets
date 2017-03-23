# ggBrackets
A ggplot2 layer for drawing brackets annotated with p-values between barplot samples.

## What is it

**ggBrackets** is a very small R package which allows the adding of
brackets and significance testing between samples/observations in
ggplot2, a simple goal which I found difficult to accomplish natively
in ggplot.  ggBrackets was specifically written for use with geom_bar()
and has not been tested thoroughly with other geometries yet.  

## Features

The two primary functions in **ggBrackets** are:

1. `gg_bracket_between()` - draws the bracket between two samples  
2. `gg_ttest_between()` - peforms a 2-sample t-test and displays the
resulting p-value on the plot

Some features of the package are:

- Support for grouped or non grouped bargraphs natively  
- Option to display either p-values or several levels of stars
to indicate significance  
- Easy `extra_y_space` parameter to fine tune the vertical location of
the brackets/p-values  
- Utilizes its own `t_test2` function which allows summary statistics
(mean, sd, n) in the dataframe to be used instead of sample vectors  
- Support for both equal (Student's) and unequal variance (Welch) t-test  
That's about it!

## Installation

The best way to install **ggBrackets** right now is by first installing
the `devtools` R package.

```r
install.packages('devtools')
library(devtools)
```

And then install the latest version from the Github repository using
`install_github`.

```r
install_github('azzoam/ggBrackets')
```
