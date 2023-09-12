FROM islasgeci/base:1.0.0
COPY . /workdir
RUN apt update && apt install --yes \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    netcdf-bin
RUN R -e "install.packages(c('ggspatial', 'sf'))"
RUN R -e "remotes::install_version('terra', '1.7-3', repos = c('https://rspatial.r-universe.dev', 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('eradicate-dev/eradicate', build_vignettes=FALSE, upgrade = 'always')"
RUN R -e "install.packages(c('optparse', 'plyr', 'rjson'), repos='http://cran.rstudio.com')"
RUN R -e "remotes::install_github('IslasGECI/optparse', build_vignettes=FALSE, upgrade = 'always')"
RUN R -e "remotes::install_github('IslasGECI/testtools', build_vignettes=FALSE, upgrade = 'always')"
RUN pip install --upgrade \
    black \
    flake8 \
    jinja-render \
    mypy \
    typer-cli
RUN make install
