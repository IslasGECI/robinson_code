init: install tests

.PHONY: \
    check \
    clean \
    coverage \
    format \
    install \
    tests

check:
	R -e "library(styler)" \
      -e "resumen <- style_dir('R')" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE

clean:
	rm --force *.tar.gz
	rm --force --recursive tests/testthat/_snaps
	rm --force NAMESPACE

coverage: install
	Rscript tests/testthat/coverage.R

format:
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

install: clean
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check robinson_0.1.0.tar.gz && \
    R CMD INSTALL robinson_0.1.0.tar.gz

tests:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"
