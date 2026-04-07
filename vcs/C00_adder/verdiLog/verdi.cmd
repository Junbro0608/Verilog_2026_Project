simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/hedu22/PROJECT/0402_adder/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1330" "373" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_adder"
wvGetSignalSetScope -win $_nWave2 "/tb_adder/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_adder"
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_adder/dut/a\[7:0\]} \
{/tb_adder/dut/b\[7:0\]} \
{/tb_adder/dut/y\[7:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 )} 
wvSetPosition -win $_nWave2 {("G1" 3)}
wvZoomAll -win $_nWave2
srcHBSelect "tb_adder.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcSetScope "tb_adder.dut" -delim "." -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
srcSetScope "tb_adder" -delim "." -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcSetScope "tb_adder.dut" -delim "." -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
srcSetScope "tb_adder" -delim "." -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcSetScope "tb_adder.dut" -delim "." -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcSetScope "tb_adder.dut" -delim "." -win $_nTrace1
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
srcSetScope "tb_adder" -delim "." -win $_nTrace1
srcHBSelect "tb_adder" -win $_nTrace1
wvCreateWindow
verdiSetActWin -win $_nWave3
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_adder"
verdiSetActWin -win $_nSchema_4
verdiSetActWin -win $_nWave3
wvSetPosition -win $_nWave3 {("G1" 0)}
wvOpenFile -win $_nWave3 {/home/hedu22/PROJECT/0402_adder/wave.fsdb}
verdiWindowResize -win $_Verdi_1 "1432" "215" "1086" "814"
wvGetSignalOpen -win $_nWave3
wvGetSignalSetScope -win $_nWave3 "/tb_adder"
wvSetPosition -win $_nWave3 {("G1" 6)}
wvSetPosition -win $_nWave3 {("G1" 6)}
wvAddSignal -win $_nWave3 -clear
wvAddSignal -win $_nWave3 -group {"G1" \
{/tb_adder/a\[7:0\]} \
{/tb_adder/b\[7:0\]} \
{/tb_adder/y\[7:0\]} \
{/LOGIC_LOW} \
{/LOGIC_HIGH} \
{/BLANK} \
}
wvAddSignal -win $_nWave3 -group {"G2" \
}
wvSelectSignal -win $_nWave3 {( "G1" 1 2 3 4 5 6 )} 
wvSetPosition -win $_nWave3 {("G1" 6)}
wvZoom -win $_nWave3 0.524959 3.819917
wvZoom -win $_nWave3 0.695326 1.764647
wvZoom -win $_nWave3 0.695326 0.989418
wvSelectSignal -win $_nWave3 {( "G1" 5 )} 
wvSelectSignal -win $_nWave3 {( "G1" 6 )} 
wvSelectSignal -win $_nWave3 {( "G1" 5 6 )} 
wvSelectSignal -win $_nWave3 {( "G1" 4 5 6 )} 
wvCut -win $_nWave3
wvSetPosition -win $_nWave3 {("G1" 3)}
wvZoomAll -win $_nWave3
srcHBSelect "tb_adder.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
schSelect -win $_nSchema4 -inst "dut"
schPushViewIn -win $_nSchema4
verdiSetActWin -win $_nSchema_4
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_adder"
verdiSetActWin -win $_nSchema_5
srcTBInvokeSim
verdiSetActWin -win $_InteractiveConsole_6
verdiSetActWin -dock widgetDock_<Member>
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock widgetDock_<Local>
verdiSetActWin -dock widgetDock_<Local>
verdiDockWidgetSetCurTab -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_<Member>
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
verdiSetActWin -dock widgetDock_<Inst._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Object._Tree>
verdiSetActWin -dock widgetDock_<Object._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcTBRunSim
wvZoomAll -win $_nWave2
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_6
verdiSetActWin -win $_InteractiveConsole_6
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_nWave_3
verdiSetActWin -win $_nWave3
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_nWave_3
verdiSetActWin -win $_nWave3
wvCloseGetStreamsDialog -win $_nWave3
wvAttrOrderConfigDlg -win $_nWave3 -close
wvCloseDetailsViewDlg -win $_nWave3
wvCloseDetailsViewDlg -win $_nWave3 -streamLevel
wvCloseFilterColorizeDlg -win $_nWave3
wvGetSignalClose -win $_nWave3
wvCloseWindow -win $_nWave3
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1371" "131" "1086" "923"
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvPrevView -win $_nWave2
wvPrevView -win $_nWave2
wvPrevView -win $_nWave2
wvZoom -win $_nWave2 33.007024 44.059150
wvZoom -win $_nWave2 35.683232 38.931454
wvPrevView -win $_nWave2
wvNextView -win $_nWave2
wvZoom -win $_nWave2 36.475774 37.448439
wvZoomIn -win $_nWave2
wvZoom -win $_nWave2 36.797401 36.995183
wvPrevView -win $_nWave2
wvZoomAll -win $_nWave2
wvPrevView -win $_nWave2
wvNextView -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_nSchema_4
verdiSetActWin -win $_nSchema_4
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiDockWidgetSetCurTab -dock windowDock_nSchema_4
verdiSetActWin -win $_nSchema_4
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -signal "a" -line 3 -pos 1 -win $_nTrace1
srcTBInsertDataTree -win $_nTrace1 -tab 1 -tree "tb_adder.a\[7:0\]"
srcDeselectAll -win $_nTrace1
srcSelect -signal "b" -line 4 -pos 1 -win $_nTrace1
srcTBInsertDataTree -win $_nTrace1 -tab 1 -tree "tb_adder.b\[7:0\]"
srcDeselectAll -win $_nTrace1
srcSelect -signal "y" -line 5 -pos 1 -win $_nTrace1
srcTBInsertDataTree -win $_nTrace1 -tab 1 -tree "tb_adder.y\[7:0\]"
verdiWindowResize -win $_Verdi_1 "1316" "131" "1141" "923"
verdiSetActWin -dock widgetDock_<Watch>
wvSetCursor -win $_nWave2 30.614533 -snap {("G1" 3)}
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 33.550173 -snap {("G1" 3)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "a" -line 16 -pos 1 -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcSelect -win $_nTrace1 -range {16 16 1 8 1 1}
srcTBAddBrkPnt -line 16 -file /home/hedu22/PROJECT/0402_adder/tb_adder.sv
srcTBSimReset
verdiSetActWin -win $_nWave2
srcTBRunSim
verdiSetActWin -dock widgetDock_<Watch>
srcTBStepNext
srcTBStepNext
srcTBStepNext
verdiSetActWin -win $_nWave2
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
wvZoomAll -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
srcTBStepNext
wvZoomAll -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_6
verdiSetActWin -win $_InteractiveConsole_6
debExit
