library(optparse)

#' @export
cli_for_plot <- function() {
  listaOpciones <- list(
    optparse::make_option(
      c("-m", "--month"),
      default = "2022-7",
      help = "",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- optparse::OptionParser(option_list = listaOpciones)
  opciones <- optparse::parse_args(opt_parser)
  return(opciones)
}
