all: plot_pred_grid_2.png

plot_pred_grid_2.png: data/july_camera_traps.csv src/Robinson_crusoe.R
	Rscript src/Robinson_crusoe.R

data/july_camera_traps.csv: data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv src/get_final_data_structure.R
	Rscript src/get_final_data_structure.R

.PHONY: \
    all \
    check \
    clean \
    coverage \
    format \
    init \
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

init: install tests

install: clean
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check robinson_0.1.0.tar.gz && \
    R CMD INSTALL robinson_0.1.0.tar.gz

tests:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

