# list of required packages
required_packages <- c(
  "tidyverse", "readr", "ggplot2", "readxl", "lubridate", "lavaan", "tcltk", "ggcorrplot", "corrr", "psych", "blavaan"
)

# Load each package
invisible(lapply(required_packages, function(pkg) {
  library(pkg, character.only = TRUE)
}))


