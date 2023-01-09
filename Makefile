all: plot_pred_grid_2.png \
	data/preds_1km_grid.csv \
	data/preds_1km_grid-cats.csv \
	data/cat_population_estimation.pdf

define checkDirectories
	mkdir --parents $(@D)
endef

define renderLatex
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && bibtex $(subst .tex,,$(<F))
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pdflatex $(<F)
endef



reports/cat_population_estimation.tex: reports/templates/cat_population_estimation.tex \
	predictions_with_count_cells.csv
	$(checkDirectories)
	python src/render.py "cat_population_estimation"

data/cat_population_estimation.pdf: reports/cat_population_estimation.tex plot_pred_grid_2.png
	$(renderLatex)
	cp reports/cat_population_estimation.pdf data/cat_population_estimation.pdf

predictions_with_count_cells.csv: data/preds_1km_grid-cats.csv src/join_predictions_with_count_of_cells_with_data.R
	Rscript src/join_predictions_with_count_of_cells_with_data.R

plot_pred_grid_2.png: data/Camera-Traps.csv src/Robinson_crusoe.R
	Rscript src/Robinson_crusoe.R

final_structures_data = \
	data/Camera-Traps.csv \
	data/Camera-Traps-Cats.csv \
	data/Hunting.csv \
	data/Observation.csv \
	data/Trapping.csv

$(final_structures_data): data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv src/get_final_data_structure.R
	Rscript src/get_final_data_structure.R

data/multisession-Camera-Traps.csv: data/Camera-Traps.csv src/robinson_format_2_ramsey_format.R
	Rscript src/robinson_format_2_ramsey_format.R --species Coati

data/multisession-Camera-Traps-Cats.csv: data/Camera-Traps-Cats.csv src/robinson_format_2_ramsey_format.R
	Rscript src/robinson_format_2_ramsey_format.R --species Cats

data/preds_1km_grid.csv: data/multisession-Camera-Traps.csv src/Robinson_crusoe_mult_sess.R
	Rscript src/Robinson_crusoe_mult_sess.R --species Coati

data/preds_1km_grid-cats.csv: data/multisession-Camera-Traps-Cats.csv src/Robinson_crusoe_mult_sess.R
	Rscript src/Robinson_crusoe_mult_sess.R --species Cats

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
      -e "resumen <- rbind(resumen, style_dir('src'))" \
      -e "resumen <- rbind(resumen, style_dir('tests'))" \
      -e "resumen <- rbind(resumen, style_dir('tests/testthat'))" \
      -e "any(resumen[[2]])" \
      | grep FALSE
	black --check --line-length 100 jinja_render
	black --check --line-length 100 src
	black --check --line-length 100 tests
	flake8 --max-line-length 100 jinja_render
	flake8 --max-line-length 100 src
	flake8 --max-line-length 100 tests
	mypy jinja_render
	mypy src
	mypy tests

clean:
	rm --force *.tar.gz
	rm --force --recursive tests/testthat/_snaps
	rm --force --recursive tests/testthat/data
	rm --force --recursive robinson.Rcheck
	rm --force NAMESPACE
	rm --force --recursive jinja_render/__pycache__
	rm --force --recursive tests/pytest/__pycache__

coverage: install tests
	Rscript tests/testthat/coverage.R

format:
	black --line-length 100 jinja_render
	black --line-length 100 src
	black --line-length 100 tests
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('src')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

init: setup tests

install: install_python install_r

install_python: clean
	pip install --editable .

install_r: clean setup
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check robinson_0.1.0.tar.gz && \
    R CMD INSTALL robinson_0.1.0.tar.gz

setup: clean
	mkdir --parents tests/testthat/data
	shellspec --init

tests: tests_python tests_r tests_spec

tests_python:
	pytest --verbose

tests_r:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

tests_spec:
	shellspec tests
