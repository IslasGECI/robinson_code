library(tidyverse)
library(robinson)
library(optparse)

input_files <- list(Coati="data/Camera-Traps.csv", Cats="data/Camera-Traps-Cats.csv")
output_files <- list(Coati="data/multisession-Camera-Traps.csv", Cats="data/multisession-Camera-Traps-Cats.csv")

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

opciones <- cli_get_ramsey_format()
species <- opciones[["species"]]
camera_sightings <- read_csv(input_files[[species]], show_col_types=FALSE)
ramsey_format <- camera_traps_2_ramsey_format(camera_sightings)
output_path <- output_files[[species]]
write_csv(ramsey_format, output_path)
