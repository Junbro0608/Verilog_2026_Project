verdiWindowResize -win $_vdCoverage_1 "830" "370" "900" "700"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
verdiSetFont  -font  {DejaVu Sans}  -size  11
verdiSetFont -font "DejaVu Sans" -size "11"
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
verdiSetActWin -dock widgetDock_Message
gui_open_cov  -hier coverage.vdb -testdir {} -test {coverage/sim1} -merge MergedTest -db_max_tests 10 -sdc_level 1 -fsm transition
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1015" "709"
gui_list_sort -id  CovDetail.1   -list {line} {Coverage}
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CoverageTable.1 -list covtblInstancesList { uvm_pkg   }
verdiSetActWin -dock widgetDock_<Summary>
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} uvm_pkg  -column {} 
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1409" "709"
gui_open_source -id CovSrc.1  -active  uvm_pkg  -activate  -matrix  DesignAssert
gui_open_source -id CovSrc.1  -active  uvm_pkg  -activate  -matrix  DesignAssert
gui_covtable_show -show  { Design Hierarchy } -id  CoverageTable.1  -test  MergedTest
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} uvm_pkg  -column {} 
verdiSetActWin -dock widgetDock_<Summary>
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} uvm_pkg  -column {Assert} 
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_list_expand -id  CoverageTable.1   -list {covtblStatModuleList} Assert
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Total
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Total
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblAssertList_flat { {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}   }
gui_list_action -id  CoverageTable.1 -list {covtblAssertList_flat} {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}  -column {Assert} 
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CoverageTable.1 -list covtblAssertList_flat { {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}  {/uvm_pkg.\uvm_reg_map::do_read .unnamed$$_0.unnamed$$_1}   }
gui_list_action -id  CoverageTable.1 -list {covtblAssertList_flat} {/uvm_pkg.\uvm_reg_map::do_read .unnamed$$_0.unnamed$$_1}  -column {Assert} 
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CoverageTable.1 -list covtblAssertList_flat { {/uvm_pkg.\uvm_reg_map::do_read .unnamed$$_0.unnamed$$_1}  {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}   }
gui_list_action -id  CoverageTable.1 -list {covtblAssertList_flat} {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}  -column {Assert} 
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::VGA_coverage::VGA_cg}   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} {/$unit::VGA_coverage::VGA_cg}
gui_list_expand -id CoverageTable.1   {/$unit::VGA_coverage::VGA_cg}
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} {/$unit::VGA_coverage::VGA_cg}  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::VGA_coverage::VGA_cg}  {$unit::VGA_coverage::VGA_cg.cp_i2c_result}   }
gui_reload_cov 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { {/$unit::VGA_coverage::VGA_cg}   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} {/$unit::VGA_coverage::VGA_cg}
gui_list_expand -id CoverageTable.1   {/$unit::VGA_coverage::VGA_cg}
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} {/$unit::VGA_coverage::VGA_cg}  -column {} 
