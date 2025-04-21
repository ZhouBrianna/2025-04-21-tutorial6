library(parsnip)
library(readr)
library(rsample)
library(workflows)
library(docopt)

"Usage: src/03_model.R --file_path=<file_path> --output_test=<output_test> --output_train=<output_train> --output_fit=<output_fit>
" -> doc

# Rscript src/03_model.R --file_path=output/data_model.RDS --output_test=data/clean/pengiuns_test.csv --output_train=data/clean/pengiuns_train.csv --output_fit=output/model_fit.RDS

opt <- docopt(doc)

data <- read_rds(opt$file_path)

# Split data
set.seed(123)
data_split <- initial_split(data, strata = species)
train_data <- training(data_split)
test_data <- testing(data_split)

# Define model
penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
    set_engine("kknn")

# Create workflow
penguin_workflow <- workflow() %>%
    add_model(penguin_model) %>%
    add_formula(species ~ .)

# Fit model
penguin_fit <- penguin_workflow %>%
    fit(data = train_data)

write_csv(test_data, opt$output_test)
write_csv(train_data, opt$output_train)
write_rds(penguin_fit, opt$output_fit)
