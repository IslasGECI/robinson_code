FROM islasgeci/base:latest
COPY . /workdir
RUN Rscript -e "install.packages(c('covr', 'devtools', 'DT', 'lintr', 'roxygen2', 'styler', 'testthat', 'vdiffr'), repos='http://cran.rstudio.com')"

