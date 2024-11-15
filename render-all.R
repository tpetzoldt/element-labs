#library(future)
library(future.apply)
plan(multisession, workers=16)

index <- dir(pattern=".*[.]qmd")
qmd <- dir(path="qmd", pattern=".*[.]qmd")


system(paste0("quarto render ", index), wait = FALSE)

compile <- function(file) {
  #system(paste0("quarto render ", file), wait=FALSE)
  shell(paste0("quarto render ", file), intern=TRUE)
}

#future_lapply(paste0("qmd/", qmd), print)

ret <- future_lapply(paste0("qmd/", qmd), compile)
