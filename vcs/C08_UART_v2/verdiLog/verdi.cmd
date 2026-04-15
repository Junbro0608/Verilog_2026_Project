verdiSetActWin -dock widgetDock_<Watch>
simSetSimulator "-vcssv" -exec "simv" -args \
           "+ntb_random_seed=random -cm line+cond+fsm+tgl+branch+assert -cm_dir coverage.vdb -cm_name sim1"
debImport "-dbdir" "simv.daidir"
debLoadSimResult \
           /home/hedu22/PROJECT/Verilog_2026_Project/vcs/C08_UART_v2/novas.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1156" "306" "1271" "826"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("DUT" 0)}
wvRenameGroup -win $_nWave2 {G1} {DUT}
wvAddSignal -win $_nWave2 "/tb_uart/DUT/clk" "/tb_uart/DUT/rst" \
           "/tb_uart/DUT/tx_data\[7:0\]" "/tb_uart/DUT/tx_start" \
           "/tb_uart/DUT/tx" "/tb_uart/DUT/tx_busy" "/tb_uart/DUT/rx" \
           "/tb_uart/DUT/rx_data\[7:0\]" "/tb_uart/DUT/rx_valid"
wvSetPosition -win $_nWave2 {("DUT" 0)}
wvSetPosition -win $_nWave2 {("DUT" 9)}
wvSetPosition -win $_nWave2 {("DUT" 9)}
verdiSetActWin -win $_nWave2
wvSetWindowTimeUnit -win $_nWave2 1.000000 ns
wvZoomAll -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 2268899.396544 -snap {("DUT" 5)}
wvSetCursor -win $_nWave2 963522.763312 -snap {("DUT" 8)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 2031650.864617 -snap {("DUT" 9)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 963522.763312 -snap {("DUT" 9)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 1041477.589690 -snap {("DUT" 4)}
wvSetCursor -win $_nWave2 993501.122371 -snap {("DUT" 8)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
debExit
