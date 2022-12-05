
#pull r-ubuntu from Docker hub
FROM rocker/r-ubuntu
#install needed packages

RUN apt-get update && apt-get -y install pandoc

#create project directory and sed it to working directory
RUN mkdir /project
WORKDIR /project

#CREATE A ENV VARIABLE  set environment variables in image
ENV WHICH_MESSAGE "/"

# create code output directories in container
RUN mkdir code
RUN mkdir output
RUN mkdir report

#copy necessary files to the container directories
COPY COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv .
COPY code code
COPY Makefile .
#Install needed packages by renv snapshot
COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.dcf renv
#Install needed packages manually
RUN apt-get update && apt-get install -y libcurl4-openssl-dev
RUN apt-get update && apt-get install -y libssl-dev
RUN apt-get update && apt-get install -y libfontconfig1-dev
RUN apt-get update && apt-get install -y libcairo2-dev
RUN apt-get update && apt-get install -y libxml2-dev
# install all the packages in the container
RUN Rscript -e "renv::restore(prompt = FALSE)"
COPY report.Rmd .

# mv reort.html from container to local report directory
CMD make && mv report.html report