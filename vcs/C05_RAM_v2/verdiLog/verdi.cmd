simSetSimulator "-vcssv" -exec "simv" -args \
           "+UVM_TESTNAME=ram_random_test +UVM_VERBOSITY=UVM_DEBUG +ntb_random_seed=random -cm line+cond+fsm+tgl+branch+assert -cm_dir coverage.vdb -cm_name sim1 -cov -covdir coverage.vdb"
debImport "-dbdir" "simv.daidir"
debLoadSimResult \
           /home/hedu22/PROJECT/Verilog_2026_Project/vcs/C05_RAM_ver_professor/novas.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "tb_ram.r_if" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_ram"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/DUT"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/DUT/ram_ff"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if"
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/r_if/addr\[7:0\]} \
{/tb_ram/r_if/clk} \
{/tb_ram/r_if/rdata\[15:0\]} \
{/tb_ram/r_if/wdata\[15:0\]} \
{/tb_ram/r_if/write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/r_if/addr\[7:0\]} \
{/tb_ram/r_if/clk} \
{/tb_ram/r_if/rdata\[15:0\]} \
{/tb_ram/r_if/wdata\[15:0\]} \
{/tb_ram/r_if/write} \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 6 7 8 )} 
wvSetPosition -win $_nWave2 {("G1" 8)}
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if/mon_cb"
wvSetPosition -win $_nWave2 {("G2" 7)}
wvSetPosition -win $_nWave2 {("G2" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/r_if/addr\[7:0\]} \
{/tb_ram/r_if/clk} \
{/tb_ram/r_if/rdata\[15:0\]} \
{/tb_ram/r_if/wdata\[15:0\]} \
{/tb_ram/r_if/write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
{/tb_ram/r_if/mon_cb/addr\[7:0\]} \
{/tb_ram/r_if/mon_cb/rdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/wdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
}
wvSelectSignal -win $_nWave2 {( "G2" 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("G2" 7)}
wvSetPosition -win $_nWave2 {("G3" 4)}
wvSetPosition -win $_nWave2 {("G3" 4)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/r_if/addr\[7:0\]} \
{/tb_ram/r_if/clk} \
{/tb_ram/r_if/rdata\[15:0\]} \
{/tb_ram/r_if/wdata\[15:0\]} \
{/tb_ram/r_if/write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
{/tb_ram/r_if/mon_cb/addr\[7:0\]} \
{/tb_ram/r_if/mon_cb/rdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/wdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "G3" 1 2 3 4 )} 
wvSetPosition -win $_nWave2 {("G3" 4)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 61409.366019 -snap {("G2" 3)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetWindowTimeUnit -win $_nWave2 1.000000 ns
wvSetCursor -win $_nWave2 48.695708 -snap {("G3" 4)}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSetCursor -win $_nWave2 34.942569 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 44.697703 -snap {("G3" 0)}
wvSetCursor -win $_nWave2 45.017543 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 55.292417 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 44.937583 -snap {("G3" 1)}
wvSetCursor -win $_nWave2 54.972577 -snap {("G3" 3)}
srcSelect -win $_nTrace1 -range {29 29 1 4 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 29 -file \
           /home/hedu22/PROJECT/Verilog_2026_Project/vcs/C05_RAM_ver_professor/tb/tb_ram.sv
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcTBInvokeSim
verdiSetActWin -win $_InteractiveConsole_3
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
debReload
srcTBInvokeSim
wvSetCursor -win $_nWave2 44.897603 -snap {("G2" 2)}
debExit
