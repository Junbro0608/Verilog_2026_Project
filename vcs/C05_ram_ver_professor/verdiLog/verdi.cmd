verdiSetActWin -dock widgetDock_<Watch>
simSetSimulator "-vcssv" -exec "simv" -args \
           "+UVM_TESTNAME=ram_write_read_test +UVM_VERBOSITY=UVM_DEBUG +ntb_random_seed=random -cm line+cond+fsm+tgl+branch+assert -cm_dir coverage.vdb -cm_name sim1"
debImport "-dbdir" "simv.daidir"
debLoadSimResult \
           /home/hedu22/PROJECT/Verilog_2026_Project/vcs/C05_ram_ver_professor/novas.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "353" "205" "1984" "1139"
verdiWindowResize -win $_Verdi_1 "353" "205" "1984" "1139"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_ram.r_if.mon_cb" -win $_nTrace1
srcHBSelect "tb_ram.DUT" -win $_nTrace1
srcHBSelect "tb_ram.DUT" -win $_nTrace1
srcHBSelect "tb_ram.DUT.ram_ff" -win $_nTrace1
srcHBSelect "tb_ram.r_if" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 0)}
wvRenameGroup -win $_nWave2 {G1} {r_if(ram_if)}
wvAddSignal -win $_nWave2 "/tb_ram/r_if/clk" "/tb_ram/r_if/write" \
           "/tb_ram/r_if/addr\[7:0\]" "/tb_ram/r_if/wdata\[15:0\]" \
           "/tb_ram/r_if/rdata\[15:0\]"
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 0)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvSetPosition -win $_nWave2 {("G2" 0)}
srcHBSelect "tb_ram.r_if.drv_cb" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 2)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 3)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 4)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)/drv_cb" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {drv_cb}
srcHBSelect "tb_ram.r_if.mon_cb" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 3)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 4)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)/drv_cb" 0)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)/drv_cb" 0)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)/drv_cb/mon_cb" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {mon_cb}
wvSelectGroup -win $_nWave2 {r_if(ram_if)/drv_cb/mon_cb}
verdiSetActWin -win $_nWave2
wvSelectGroup -win $_nWave2 {r_if(ram_if)/drv_cb/mon_cb}
wvSelectGroup -win $_nWave2 {r_if(ram_if)/drv_cb}
wvSelectGroup -win $_nWave2 {r_if(ram_if)/drv_cb/mon_cb}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)/drv_cb" 0)}
wvSelectGroup -win $_nWave2 {r_if(ram_if)/drv_cb}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 5)}
wvZoomAll -win $_nWave2
srcHBSelect "tb_ram.r_if" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_ram"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_ram/DUT"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/DUT"
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 4 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 4 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 3 4 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 2 3 4 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 1 2 3 4 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 1 2 3 4 5 )} 
wvSelectSignal -win $_nWave2 {( "r_if(ram_if)" 1 2 3 4 5 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("r_if(ram_if)" 0)}
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if/mon_cb"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if/drv_cb"
wvGetSignalSetScope -win $_nWave2 "/tb_ram/r_if/mon_cb"
wvSetPosition -win $_nWave2 {("G4" 4)}
wvSetPosition -win $_nWave2 {("G4" 4)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G2" \
{/tb_ram/DUT/addr\[7:0\]} \
{/tb_ram/DUT/clk} \
{/tb_ram/DUT/rdata\[15:0\]} \
{/tb_ram/DUT/wdata\[15:0\]} \
{/tb_ram/DUT/write} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
{/tb_ram/r_if/mon_cb/addr\[7:0\]} \
{/tb_ram/r_if/mon_cb/rdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/wdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G5" \
}
wvSelectSignal -win $_nWave2 {( "G4" 1 2 3 4 )} 
wvSetPosition -win $_nWave2 {("G4" 4)}
wvSetCursor -win $_nWave2 1054149.242424 -snap {("G3" 2)}
wvGetSignalSetOptions -win $_nWave2 -input on
wvGetSignalSetSignalFilter -win $_nWave2 "*"
wvGetSignalSetOptions -win $_nWave2 -all on
wvGetSignalSetSignalFilter -win $_nWave2 "*"
wvGetSignalSetOptions -win $_nWave2 -output on
wvGetSignalSetSignalFilter -win $_nWave2 "*"
wvGetSignalSetOptions -win $_nWave2 -all on
wvGetSignalSetSignalFilter -win $_nWave2 "*"
wvSetPosition -win $_nWave2 {("G4" 4)}
wvSetPosition -win $_nWave2 {("G4" 4)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G2" \
{/tb_ram/DUT/addr\[7:0\]} \
{/tb_ram/DUT/clk} \
{/tb_ram/DUT/rdata\[15:0\]} \
{/tb_ram/DUT/wdata\[15:0\]} \
{/tb_ram/DUT/write} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
{/tb_ram/r_if/mon_cb/addr\[7:0\]} \
{/tb_ram/r_if/mon_cb/rdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/wdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G5" \
}
wvSelectSignal -win $_nWave2 {( "G4" 1 2 3 4 )} 
wvSetPosition -win $_nWave2 {("G4" 4)}
wvSetPosition -win $_nWave2 {("G4" 4)}
wvSetPosition -win $_nWave2 {("G4" 4)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G2" \
{/tb_ram/DUT/addr\[7:0\]} \
{/tb_ram/DUT/clk} \
{/tb_ram/DUT/rdata\[15:0\]} \
{/tb_ram/DUT/wdata\[15:0\]} \
{/tb_ram/DUT/write} \
}
wvAddSignal -win $_nWave2 -group {"G3" \
{/tb_ram/r_if/drv_cb/addr\[7:0\]} \
{/tb_ram/r_if/drv_cb/wdata\[15:0\]} \
{/tb_ram/r_if/drv_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
{/tb_ram/r_if/mon_cb/addr\[7:0\]} \
{/tb_ram/r_if/mon_cb/rdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/wdata\[15:0\]} \
{/tb_ram/r_if/mon_cb/write} \
}
wvAddSignal -win $_nWave2 -group {"G5" \
}
wvSelectSignal -win $_nWave2 {( "G4" 1 2 3 4 )} 
wvSetPosition -win $_nWave2 {("G4" 4)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 28016.268429 -snap {("G2" 5)}
wvSetOptions -win $_nWave2 -signalType off
wvSetOptions -win $_nWave2 -hiSig off
wvSetOptions -win $_nWave2 -hiSig on
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 1 )} 
wvSelectSignal -win $_nWave2 {( "G3" 2 )} 
wvSelectSignal -win $_nWave2 {( "G3" 3 )} 
wvSelectSignal -win $_nWave2 {( "G4" 3 )} 
wvSelectSignal -win $_nWave2 {( "G4" 4 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 )} {( "G4" 4 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 )} {( "G3" 1 2 3 )} {( "G4" 1 2 \
           )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 )} {( "G3" 1 2 3 )} {( "G4" 1 2 \
           3 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 )} {( "G3" 1 2 3 )} {( "G4" 1 2 \
           3 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 )} {( "G3" 1 2 3 )} {( "G4" 1 2 \
           3 4 )} 
wvSelectGroup -win $_nWave2 {G2}
wvRenameGroup -win $_nWave2 {G2} {DUT}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvRenameGroup -win $_nWave2 {G3} {Drv_cb}
wvSelectGroup -win $_nWave2 {G4}
wvRenameGroup -win $_nWave2 {G4} {Mon_cb}
wvSetCursor -win $_nWave2 34853.636551 -snap {("Mon_cb" 4)}
wvSetCursor -win $_nWave2 65037.886386 -snap {("Mon_cb" 4)}
wvSetPosition -win $_nWave2 {("Mon_cb" 0)}
wvSetCursor -win $_nWave2 64537.594953 -snap {("Mon_cb" 4)}
wvSetCursor -win $_nWave2 74376.659816 -snap {("Mon_cb" 4)}
wvSetCursor -win $_nWave2 65371.414009 -snap {("Mon_cb" 4)}
wvSetCursor -win $_nWave2 64037.303519 -snap {("Mon_cb" 4)}
wvSetCursor -win $_nWave2 49862.379563 -snap {("Mon_cb" 2)}
wvSetCursor -win $_nWave2 48528.269073 -snap {("Mon_cb" 1)}
wvSelectGroup -win $_nWave2 {Mon_cb}
wvSelectSignal -win $_nWave2 {( "Drv_cb" 3 )} 
wvSelectGroup -win $_nWave2 {Mon_cb}
wvSetCursor -win $_nWave2 66038.469254 -snap {("Mon_cb" 4)}
wvCenterCursor -win $_nWave2
wvSetCursor -win $_nWave2 65000.000000
wvSetCursor -win $_nWave2 5002.914337 -snap {("DUT" 1)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 10506.120109 -snap {("DUT" 2)}
wvSetCursor -win $_nWave2 5002.914337 -snap {("DUT" 2)}
wvSelectGroup -win $_nWave2 {Drv_cb}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 34770.254645 -snap {("Mon_cb" 1)}
wvSetCursor -win $_nWave2 15175.506824 -snap {("Mon_cb" 1)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 24514.280253 -snap {("Drv_cb" 2)}
wvSelectSignal -win $_nWave2 {( "DUT" 2 )} 
wvSetPosition -win $_nWave2 {("DUT" 1)}
wvSetPosition -win $_nWave2 {("DUT" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("DUT" 0)}
wvSetPosition -win $_nWave2 {("DUT" 1)}
wvSelectSignal -win $_nWave2 {( "DUT" 4 )} 
wvSetPosition -win $_nWave2 {("DUT" 3)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("DUT" 3)}
wvSetPosition -win $_nWave2 {("DUT" 4)}
wvSelectSignal -win $_nWave2 {( "DUT" 2 3 )} 
wvSelectSignal -win $_nWave2 {( "DUT" 3 )} 
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("DUT" 4)}
wvSelectSignal -win $_nWave2 {( "DUT" 2 3 4 5 )} 
wvSelectSignal -win $_nWave2 {( "DUT" 5 )} 
wvSetPosition -win $_nWave2 {("DUT" 3)}
wvSetPosition -win $_nWave2 {("DUT" 2)}
wvSetPosition -win $_nWave2 {("DUT" 1)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("DUT" 1)}
wvSetPosition -win $_nWave2 {("DUT" 2)}
wvSelectSignal -win $_nWave2 {( "Drv_cb" 3 )} 
wvSetPosition -win $_nWave2 {("Drv_cb" 2)}
wvSetPosition -win $_nWave2 {("Drv_cb" 1)}
wvSetPosition -win $_nWave2 {("Drv_cb" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("Drv_cb" 0)}
wvSetPosition -win $_nWave2 {("Drv_cb" 1)}
wvSelectSignal -win $_nWave2 {( "Mon_cb" 4 )} 
wvSetPosition -win $_nWave2 {("Mon_cb" 3)}
wvSetPosition -win $_nWave2 {("Mon_cb" 2)}
wvSetPosition -win $_nWave2 {("Mon_cb" 1)}
wvSetPosition -win $_nWave2 {("Mon_cb" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("Mon_cb" 0)}
wvSetPosition -win $_nWave2 {("Mon_cb" 1)}
wvSelectSignal -win $_nWave2 {( "Mon_cb" 3 4 )} 
wvSelectSignal -win $_nWave2 {( "Mon_cb" 4 )} 
wvSetPosition -win $_nWave2 {("Mon_cb" 3)}
wvSetPosition -win $_nWave2 {("Mon_cb" 2)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("Mon_cb" 2)}
wvSetPosition -win $_nWave2 {("Mon_cb" 3)}
wvSetCursor -win $_nWave2 25181.335498 -snap {("Drv_cb" 1)}
wvSetCursor -win $_nWave2 24597.662159 -snap {("Drv_cb" 1)}
wvSelectGroup -win $_nWave2 {G5}
verdiInvokeApp -vdCov
verdiSetActWin -dock widgetDock_<Inst._Tree>
debReload
srcTBInvokeSim
verdiSetActWin -win $_InteractiveConsole_3
srcTBRunSim
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 251392.302452 -snap {("Drv_cb" 1)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 926869.904979 -snap {("DUT" 4)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 5409.055688 -snap {("DUT" 1)}
verdiInvokeApp -vdCov
