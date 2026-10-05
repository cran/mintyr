## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----setup--------------------------------------------------------------------
library(mintyr)
library(data.table)

## -----------------------------------------------------------------------------
files <- mintyr_example(mintyr_examples("xlsx_test"))
raw <- import_xlsx(files)
head(raw)

## -----------------------------------------------------------------------------
desc_stats(mtcars, cols = c("mpg", "hp", "wt"), by = "cyl",
           fmt = "{mean} ± {sd}", total = TRUE, shape = "wide")

## -----------------------------------------------------------------------------
nested <- w2l_nest(mtcars, cols = c("mpg", "qsec"), by = "am")
nested

## -----------------------------------------------------------------------------
cv <- nest_cv(nested, v = 4, seed = 2026)
cv[, r := mapply(function(tr, va) {
  fit <- lm(value ~ wt + hp, data = tr)
  cor(predict(fit, va), va$value)
}, train, validate)]
cv[, .(mean_r = round(mean(r), 3)), by = .(name, am)]

## -----------------------------------------------------------------------------
out <- file.path(tempdir(), "by_trait")
files <- export_nest(nested, path = out)
basename(dirname(files))
unlink(out, recursive = TRUE)

