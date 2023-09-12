all: data/cat_population_estimation.pdf \
	data/coati_population_estimation.pdf

define checkDirectories
	mkdir --parents $(@D)
endef

define renderLatex
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && bibtex $(subst .tex,,$(<F))
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pdflatex $(<F)
endef

data/coati_population_estimation.pdf: reports/coati_population_estimation.tex \
	data/plot_cameras_for_month.png
	$(renderLatex)
	cp reports/coati_population_estimation.pdf data/coati_population_estimation.pdf

reports/coati_population_estimation.tex: reports/templates/coati_population_estimation.tex \
	data/coati_results.json \
	data/count_of_sessions_per_grid.csv
	$(checkDirectories)
	typer jinja_render run \
	--report-name coati_population_estimation \
	--summary-path data/coati_results.json

data/coati_results.json: prediction_with_count_cells_coatis.csv \
	src/summary_for_coatis.R
	Rscript src/summary_for_coatis.R

prediction_with_count_cells_coatis.csv: data/preds_1km_grid.csv src/join_predictions_with_count_of_cells_with_data.R
	Rscript src/join_predictions_with_count_of_cells_with_data.R --species Coatis

data/count_of_sessions_per_grid.csv: data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv
	Rscript -e "robinson::write_session_per_grid()"

data/cat_population_estimation.pdf: reports/cat_population_estimation.tex \
	data/plot_cameras_for_month.png
	$(renderLatex)
	cp reports/cat_population_estimation.pdf data/cat_population_estimation.pdf

reports/cat_population_estimation.tex: reports/templates/cat_population_estimation.tex \
	data/cat_results.json
	$(checkDirectories)
	typer jinja_render run \
	--report-name cat_population_estimation \
	--summary-path data/cat_results.json

data/cat_results.json: prediction_with_count_cells.csv src/summary_for_cats.R
	Rscript src/summary_for_cats.R

prediction_with_count_cells.csv: data/preds_1km_grid-cats.csv src/join_predictions_with_count_of_cells_with_data.R
	Rscript src/join_predictions_with_count_of_cells_with_data.R --species Cats

data/plot_cameras_for_month.png: data/Camera-Traps.csv src/Robinson_crusoe.R
	Rscript src/Robinson_crusoe.R --month 2022-11

plot_predictions_single_session_months: data/Camera-Traps.csv
	Rscript src/plot_pred_grid_months.R --initial_date 2022-1 --final_date 2022-11

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
	black --check --line-length 100 src
	flake8 --max-line-length 100 src
	mypy src

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
	black --line-length 100 src
	R -e "library(styler)" \
      -e "style_dir('R')" \
      -e "style_dir('src')" \
      -e "style_dir('tests')" \
      -e "style_dir('tests/testthat')"

init: setup tests
	git config --global --add safe.directory /workdir
	git config --global user.name "Ciencia de Datos • GECI"
	git config --global user.email "ciencia.datos@islas.org.mx"

install: install_r

install_r: clean setup
	R -e "devtools::document()" && \
    R CMD build . && \
    R CMD check robinson_1.0.0.tar.gz && \
    R CMD INSTALL robinson_1.0.0.tar.gz

setup: clean
	mkdir --parents tests/testthat/data
	shellspec --init

red: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& git restore . \
	|| (git add tests/testthat/*.R && git commit -m "🛑🧪 Fail tests")
	chmod g+w -R .

green: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/*.R && git commit -m "✅ Pass tests") \
	|| git restore .
	chmod g+w -R .

refactor: format
	Rscript -e "devtools::test(stop_on_failure = TRUE)" \
	&& (git add R/*.R tests/testthat/*.R && git commit -m "♻️  Refactor") \
	|| git restore .
	chmod g+w -R .

tests: tests_r tests_spec

tests_r:
	Rscript -e "devtools::test(stop_on_failure = TRUE)"

tests_spec:
	shellspec tests
