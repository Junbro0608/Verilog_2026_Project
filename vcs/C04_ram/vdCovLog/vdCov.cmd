verdiWindowResize -win $_vdCoverage_1 "8" "31" "2560" "1369"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
verdiSetFont  -font  {DejaVu Sans}  -size  11
verdiSetFont -font "DejaVu Sans" -size "11"
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
gui_open_cov  -hier coverage.vdb -testdir {} -test {coverage/sim1} -merge MergedTest -db_max_tests 10 -sdc_level 1 -fsm transition
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_<Summary>
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::ram_coverage::ram_cg}   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}
gui_list_expand -id CoverageTable.1   {/$unit::ram_coverage::ram_cg}
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} {/$unit::ram_coverage::ram_cg}  -column {Group} 
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_addr}   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_addr}   } -type { {Cover Group}  }
verdiWindowResize -win $_vdCoverage_1 "636" "392" "2075" "1217"
verdiWindowResize -win $_vdCoverage_1 "1626" "848" "960" "555"
verdiWindowResize -win $_vdCoverage_1 "913" "469" "1236" "697"
verdiWindowResize -win $_vdCoverage_1 "913" "469" "1406" "794"
verdiSetActWin -dock widgetDock_<Summary>
verdiSetActWin -dock widgetDock_Message
verdiWindowResize -win $_vdCoverage_1 "913" "469" "1604" "794"
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_addr}  {$unit::ram_coverage::ram_cg.cp_rdata}   } -type { {Cover Group} {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_rdata}  {$unit::ram_coverage::ram_cg.cp_wdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_wdata}  {$unit::ram_coverage::ram_cg.cp_write}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cp_write}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_rdata}  {$unit::ram_coverage::ram_cg.cx_addr_wdata}   } -type { {Cover Group} {Cover Group}  }
verdiWindowResize -win $_vdCoverage_1 "913" "31" "1604" "1360"
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_wdata}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_rdata}  {$unit::ram_coverage::ram_cg.cx_addr_wdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_wdata}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_rdata}  {$unit::ram_coverage::ram_cg.cx_addr_wdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_wdata}  {$unit::ram_coverage::ram_cg.cx_addr_rdata}   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { {$unit::ram_coverage::ram_cg.cx_addr_rdata}  {$unit::ram_coverage::ram_cg.cx_addr_wdata}   } -type { {Cover Group} {Cover Group}  }
vdCovExit -noprompt
