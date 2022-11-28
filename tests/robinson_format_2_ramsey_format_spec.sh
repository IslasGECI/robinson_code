#shellcheck shell=sh

It "Cli for robinson_format_2_ramsey_format"
  When call Rscript src/robinson_format_2_ramsey_format.R --help
  The output should include "species"
  The status should be success
  The stderr should include "ggplot"
End
