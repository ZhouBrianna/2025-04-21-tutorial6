library(tidyverse)
library(palmerpenguins)
library(docopt)

"This script loads, cleans, saves titanic data

Usage: 01_load_data.R --output_path=<output_path>
" -> doc

# Rscript src/01_load_data.R --output_path=data/clean/penguins_clean.csv
opt <- docopt(doc)

data <- palmerpenguins::penguins

data <- data %>% drop_na()

write_csv(data, opt$output_path)
