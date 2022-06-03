FROM islasgeci/base:0.7.0
COPY . /workdir
RUN apt update && apt install --yes \
    gnuplot
RUN pip install --upgrade pip && pip install \
    black \
    codecov \
    flake8 \
    mutmut \
    mypy \
    pylint \
    pytest \
    pytest-cov \
    sklearn \
    tensorflow
RUN Rscript -e "install.packages(c('covr', 'devtools', 'DT', 'lintr', 'roxygen2', 'styler', 'testthat', 'vdiffr'), repos='http://cran.rstudio.com')"

