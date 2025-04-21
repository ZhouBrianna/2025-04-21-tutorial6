library(tidyverse)
library(ggplot2)
library(palmerpenguins)
library(docopt)

"
Usage: src/02_methods.R --file_path=<file_path> --output_path=<output_path> --output_summary=<output_summary> --output_fig=<output_fig>
" -> doc

# Rscript src/02_methods.R --file_path=data/clean/penguins_clean.csv --output_path=output/data_model.RDS --output_summary=output/summary.RDS --output_fig=output/penguin.png
opt <- docopt(doc)

data <- read_csv(opt$file_path)

# Summary statistics
glimpse(data)
summary <- summarise(data, mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm))

# Visualizations
ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
    geom_boxplot() +
    theme_minimal()

# Prepare data for modeling
data <- data %>%
    select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
    mutate(species = as.factor(species))

write_rds(data, opt$output_path)
write_rds(summary, opt$output_summary)
ggsave(opt$output_fig)
