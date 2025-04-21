library(stats)
library(readr)
library(tidymodels)
library(docopt)
library(yardstick)

"Usage: src/04_results.R --file_path=<file_path> --fit_model=<fit_model> --output_prediction=<output_prediction> --output_conf=<output_conf>
" -> doc


# Rscript src/04_results.R --file_path=data/clean/pengiuns_test.csv --fit_model=output/model_fit.RDS --output_prediction=output/prediction.RDS --output_conf=output/confusion_matrix.RDS

opt <- docopt(doc)

test_data <- read_csv(opt$file_path)
penguin_fit <- read_rds(opt$fit_model)

# Predict on test data
predictions <- predict(penguin_fit, test_data, type = "class") %>%
    bind_cols(test_data) %>%
    mutate(
        species = as.factor(species),
        .pred_class = as.factor(.pred_class)
    )

# Confusion matrix
conf_mat <- conf_mat(predictions, truth = species, estimate = .pred_class)

write_rds(predictions, opt$output_prediction)
write_rds(conf_mat, opt$output_conf)
