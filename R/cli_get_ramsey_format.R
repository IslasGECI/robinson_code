library(optparse)

#' @export
input_files <- list(Coati = "data/Camera-Traps.csv", Cats = "data/Camera-Traps-Cats.csv")

#' @export
output_files <- list(Coati = "data/multisession-Camera-Traps.csv", Cats = "data/multisession-Camera-Traps-Cats.csv")

#' @export
cli_get_ramsey_format <- function() {
  listaOpciones <- list(
    optparse::make_option(
      c("-s", "--species"),
      default = "Coati",
      help = "",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- optparse::OptionParser(option_list = listaOpciones)
  opciones <- optparse::parse_args(opt_parser)
  return(opciones)
}

#' @export
input_multisession <- list(Coati = "data/multisession-Camera-Traps.csv", Cats = "data/multisession-Camera-Traps-Cats.csv")
#' @export
output_prediction <- list(Coati = c("preds_1km_grid.csv", "preds_0.5km_grid.csv"), Cats = c("preds_1km_grid-cats.csv", "preds_0.5km_grid-cats.csv"))

#' @export
cli_get_multisession_predictions <- function() {
  listaOpciones <- list(
    optparse::make_option(
      c("-s", "--species"),
      default = "Coati",
      help = "",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- optparse::OptionParser(option_list = listaOpciones)
  opciones <- optparse::parse_args(opt_parser)
  return(opciones)
}
