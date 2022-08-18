FROM islasgeci/base:latest
COPY . /workdir
RUN apt update && apt install --yes \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    netcdf-bin
RUN R -e "install.packages(c('ggspatial','sf','terra'), repos='https://rspatial.r-universe.dev')"

RUN make install
