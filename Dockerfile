FROM islasgeci/base:latest
COPY . /workdir

RUN make install
