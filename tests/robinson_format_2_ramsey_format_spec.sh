#shellcheck shell=sh

It "is simple"
  When call Rscript src/robinson_format_2_ramsey_format.R --help
  The output should include "species"
  The status should be success
  The stderr should include "ggplot"
End
