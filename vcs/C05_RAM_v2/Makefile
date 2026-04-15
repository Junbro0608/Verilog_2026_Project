# ===== UVM Testbench Makefile =====
#vcs -full64 -sverilog -debug_access+all -ntb_opts uvm-1.2 -timescale=1ns/1ps -kdb -lca -o simv ./rtl/adder.sv ./tb/tb_adder.sv

#-------------------value---------------------
NAME		:= ram
TOP 		:= tb_top
TEST 		:= ram_random_test
VERBOSITY 	:= UVM_DEBUG
SEED 		:= random

#-------------------file_name---------------------
DATE    := $(shell date +%y%m%d_%H%M%S)
INCLUDE := "\`include \"uvm_macros.svh\"\nimport uvm_pkg::*;\n"
SEQ     := "\`include \"tb_seq.svh\"\n"

FILE_LIST  	:= filelist.f
RTL_FILE 	:= $(NAME).sv
TB_FILE	 	:= tb_$(NAME).sv
SEQ_FILE 	:= tb_$(NAME)_seq.svh
LOG_DIR 	:= ./logs
LOG_FILE 	:= sim_$(TEST).log


#-------------------macro---------------------
COMP_OPTS := -full64 -sverilog -debug_access+all -kdb -lca -ntb_opts uvm-1.2 \
			-timescale=1ns/1ps \
			+incdir+./rtl \
			+incdir+./tb \
			-cm line+cond+fsm+tgl+branch+assert



SIM_OPTS := +UVM_TESTNAME=$(TEST) \
			+UVM_VERBOSITY=$(VERBOSITY)	\
			+ntb_random_seed=$(SEED) \
			-cm line+cond+fsm+tgl+branch+assert \
			-cm_dir coverage.vdb \
			-cm_name sim1 \
			-cov -covdir coverage.vdb

VERDI_OPTS := -dbdir simv.daidir -ssf novas.fsdb

init:
	mkdir -p rtl tb logs
	touch ./rtl/$(RTL_FILE)
	@printf "#RTL\n./rtl/$(NAME).sv\n\n#Testbench\n./tb/tb_$(NAME).sv\n" > $(FILE_LIST)
	@test -s ./tb/$(TB_FILE)  || printf $(INCLUDE) > ./tb/$(TB_FILE) 
	@test -s ./tb/$(SEQ_FILE) || { printf $(INCLUDE)$(SEQ) > ./tb/$(SEQ_FILE); }
	@echo "초기셋팅완료"

comp:
	vcs $(COMP_OPTS) -f filelist.f -o simv
	@echo "타겟 컴파일 완료"
	
sim: comp
	@mkdir -p $(LOG_DIR)
	./simv $(SIM_OPTS) -l $(LOG_DIR)/$(TEST)_$(DATE).log
	@ln -sf $$PWD/$(LOG_DIR)/$(TEST)_$(DATE).log $(LOG_DIR)/latest.log
	@echo "로그 파일 저장 완료: $(LOG_DIR)/$(TEST)_$(DATE).log"
	@echo "최신 로그 연결: $(LOG_DIR)/latest.log"

verdi: sim
	verdi $(VERDI_OPTS)

verdi_c:
	verdi -cov -covdir coverage.vdb

clean:
	rm -rf simv* csrc *.log *.vpd *.fsdb *.key *.h DVE* *.fsdb navas* *.conf *LOG
	@echo "삭제 완료"


.PHONY: comp run clean init
