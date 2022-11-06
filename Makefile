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

.PHONY: clean
clean: 
	rm -f output/*.rds && rm -f output/*.png && rm -f *.html
	