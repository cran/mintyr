## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mintyr)

## ----example-split_cv---------------------------------------------------------
# Prepare example data: Convert first 3 columns of iris dataset to long format and split
dt_split <- w2l_split(data = iris, cols = 1:3)
# dt_split is now a list containing 3 data tables for Sepal.Length, Sepal.Width, and Petal.Length

# Example 1: Single cross-validation (no repeats)
split_cv(
  data = dt_split,      # Input list of split data
  v = 3,                # Set 3-fold cross-validation
  repeats = 1,          # Perform cross-validation once (no repeats)
  seed = 123            # Reproducible folds
)
# Returns a list where each element contains:
# - id: fold labels (Fold1, Fold2, Fold3)
# - train_idx / validate_idx: row indices of each fold
# - train / validate: training and validation subsets

# Example 2: Repeated cross-validation
split_cv(
  data = dt_split,      # Input list of split data
  v = 3,                # Set 3-fold cross-validation
  repeats = 2,          # Perform cross-validation twice
  seed = 123
)
# Returns a list where each element contains:
# - id: repeat labels (Repeat1, Repeat2)
# - id2: fold labels (Fold1, Fold2, Fold3)
# - train_idx / validate_idx, train / validate

# Example 3: Stratified CV, indices only (memory friendly)
res <- split_cv(dt_split, v = 5, strata = "Species", seed = 1,
                materialize = FALSE)
# Rebuild the training set of fold 1 of the first dataset when needed
head(dt_split[[1]][res[[1]]$train_idx[[1]], ])

## ----example-nest_cv----------------------------------------------------------
# Example: Cross-validation for nested data.table demonstrations

# Setup test data
dt_nest <- w2l_nest(
  data = iris,                   # Input dataset
  cols = 1:2                     # Nest first 2 columns
)

# Example 1: Basic 2-fold cross-validation (reproducible)
nest_cv(
  data = dt_nest,                # Input nested data.table
  v = 2,                         # Number of folds (2-fold CV)
  seed = 123                     # Reproducible folds
)

# Example 2: Repeated 2-fold CV, keeping only the split objects
nest_cv(
  data = dt_nest,                # Input nested data.table
  v = 2,                         # Number of folds (2-fold CV)
  repeats = 2,                   # Number of repetitions
  seed = 123,
  materialize = FALSE            # No train/validate copies (saves memory)
)

# Example 3: data.frame subsets, ready for ASReml-R / lm() / glm()
cv_df <- nest_cv(dt_nest, v = 2, seed = 123, out_type = "df")
class(cv_df$train[[1]])        # "data.frame"

# Example 4: masking-style CV (keep all rows, hide validation phenotypes)
cv_idx <- nest_cv(dt_nest, v = 2, seed = 123, materialize = FALSE)
cv_idx[dt_nest, on = "name", full := i.data]   # attach the full nested table
masked <- as.data.frame(cv_idx$full[[1]])      # a copy: dt_nest stays intact
masked$value[cv_idx$validate_idx[[1]]] <- NA
sum(is.na(masked$value))       # validation records to be predicted

