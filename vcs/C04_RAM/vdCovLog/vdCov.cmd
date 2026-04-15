verdiWindowResize -win $_vdCoverage_1 "913" "31" "1604" "1360"
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
vdCovExit -noprompt
