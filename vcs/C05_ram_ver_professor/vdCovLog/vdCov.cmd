verdiWindowResize -win $_vdCoverage_1 "619" "289" "1870" "973"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
verdiSetFont  -font  {DejaVu Sans}  -size  11
verdiSetFont -font "DejaVu Sans" -size "11"
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
verdiSetActWin -dock widgetDock_<CovDetail>
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1
verdiSetActWin -dock widgetDock_<Summary>
gui_open_cov  -hier simv.vdb -testdir  {simv.vdb} -test { simv/test } -merge MergedTest -db_max_tests 10 -sdc_level 1 -fsm transition
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::ram_coverage::ram_cg}   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}
gui_list_expand -id CoverageTable.1   {/$unit::ram_coverage::ram_cg}
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::ram_coverage::ram_cg}  {$unit::ram_coverage::ram_cg.cp_rdata}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_rdata}  {$unit::ram_coverage::ram_cg.cp_addr}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_addr}  {$unit::ram_coverage::ram_cg.cp_wdata}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_wdata}  {$unit::ram_coverage::ram_cg.cp_write}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_write}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   }
gui_reload_cov 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::ram_coverage::ram_cg}   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}
gui_list_expand -id CoverageTable.1   {/$unit::ram_coverage::ram_cg}
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::ram_coverage::ram_cg}  {$unit::ram_coverage::ram_cg.cp_addr}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_addr}  {$unit::ram_coverage::ram_cg.cp_rdata}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_rdata}  {$unit::ram_coverage::ram_cg.cp_write}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_write}  {$unit::ram_coverage::ram_cg.cx_addr_wdata}   }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_addr}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   } -type { {Cover Group} {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cx_addr_wdata}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   }
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cx_addr_rdata}  {$unit::ram_coverage::ram_cg.cp_wdata}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {$unit::ram_coverage::ram_cg.cp_wdata}  {$unit::ram_coverage::ram_cg.cp_write}   }
vdCovExit -noprompt
