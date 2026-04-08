verdiWindowResize -win $_vdCoverage_1 "446" "629" "1961" "777"
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
gui_set_pref_value -category {ColumnCfg} -key {covtblAssertList_Assert} -value {true}
gui_set_pref_value -category {ColumnCfg} -key {covtblAssertList_Match} -value {false}
gui_set_pref_value -category {ColumnCfg} -key {covtblAssertList_Success} -value {false}
verdiSetActWin -dock widgetDock_<CovDetail>
vdCovExit -noprompt
