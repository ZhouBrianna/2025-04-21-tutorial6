.PHONY: all clean 

all:
	make clean
	make index.html

index.html: data/clean/penguins_clean.csv \
		output/model.RDS \
		output/summary.RDS \
		output/penguin.png \
		data/clean/pengiuns_test.csv \
		data/clean/pengiuns_train.csv \
		output/model_fit.RDS \
		output/prediction.RDS \
		output/confusion_matrix.RDS \
		report/report.html \
		report/report.pdf 
		cp report/report.html docs/index.html


data/clean/penguins_clean.csv: src/01_load_data.R
	Rscript src/01_load_data.R --output_path=data/clean/penguins_clean.csv

output/model.RDS output/summary.RDS output/penguin.png: src/02_methods.R data/clean/penguins_clean.csv
	Rscript src/02_methods.R --file_path=data/clean/penguins_clean.csv --output_path=output/data_model.RDS --output_summary=output/summary.RDS --output_fig=output/penguin.png

data/clean/pengiuns_test.csv data/clean/pengiuns_train.csv output/model_fit.RDS: src/03_model.R output/data_model.RDS
	Rscript src/03_model.R --file_path=output/data_model.RDS --output_test=data/clean/pengiuns_test.csv --output_train=data/clean/pengiuns_train.csv --output_fit=output/model_fit.RDS

output/prediction.RDS output/confusion_matrix.RDS: src/04_results.R data/clean/pengiuns_test.csv 
	Rscript src/04_results.R --file_path=data/clean/pengiuns_test.csv --fit_model=output/model_fit.RDS --output_prediction=output/prediction.RDS --output_conf=output/confusion_matrix.RDS

report/report.html: output report/report.qmd
	quarto render report/report.qmd --to html

report/report.pdf: output report/report.qmd
	quarto render report/report.qmd --to pdf

clean:
	rm -f output/*
	rm -f data/clean/*
	rm -f *.pdf
