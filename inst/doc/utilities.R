## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mintyr)

## ----example-get_path_info----------------------------------------------------
paths <- c("C:/Users/foo/Documents/report.xlsx",
           "/home/user/.bashrc",
           "relative/path/to/data.csv",
           ".hidden.tar.gz",
           NA_character_)

# Mode B: filename only, extension stripped (default)
get_path_info(paths)

# Mode B: filename only, extension preserved
get_path_info(paths, rm_extension = FALSE)

# Mode B: full normalised path, extension stripped
get_path_info(paths, rm_path = FALSE)

# Mode A: extract the 2nd path segment
get_path_info(paths, n = 2)

# Mode A: extract the last segment with extension stripped (n = -1 linkage)
get_path_info(paths, n = -1, rm_extension = TRUE)

# Mode A: range extraction
get_path_info(paths, n = c(2, 3))

## ----example-mintyr_example---------------------------------------------------
# Get path to an example file
mintyr_example("csv_test1.csv")

## ----example-mintyr_examples--------------------------------------------------
# List all example files
mintyr_examples()

