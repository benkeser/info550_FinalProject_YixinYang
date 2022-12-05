report.html: code/03_render_report.R \
  report.Rmd output/table.rds output/plot.png
	Rscript code/03_render_report.R

output/table.rds: code/01_make_table1.R COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv
	Rscript code/01_make_table1.R

output/plot.png: code/02_make_plot.R COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv
	Rscript code/02_make_plot.R
	
.PHONY: install
install: 
	Rscript -e "renv::restore(prompt = FALSE)"
	
	
# docker-associated rules
PROJECTFILES = report.Rmd code/01_make_table1.R code/02_make_plot.R code/03_render_report.R Makefile COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv 
RENVFILERS = renv.lock renv/activate.R renv/settings.dcf
 #rules to build image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILERS)
	docker build -t project_image .
	touch $@

# rule to buld the report automatically 
report/report.html: project_image
	docker run -v "${WHICH_MESSAGE}$$(pwd)/report":/project/report project_image


.PHONY: clean
clean: 
	rm -f output/*.rds && rm -f output/*.png && rm -f *.html
	