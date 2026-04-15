# ===== UVM Testbench Makefile =====
#vcs -full64 -sverilog -debug_access+all -ntb_opts uvm-1.2 -timescale=1ns/1ps -kdb -lca -o simv ./rtl/adder.sv ./tb/tb_adder.sv

#-------------------value---------------------
NAME		:= ram
TOP 		:= tb_top
TEST 		:= $(NAME)_test
VERBOSITY 	:= UVM_DEBUG
SEED 		:= random

#-------------------file_name---------------------
INCLUDE := "\`include \"uvm_macros.svh\"\nimport uvm_pkg::*;\n"
SEQ     := "\`include \"tb_seq.svh\"\n"

FILE_LIST  	:= filelist.f
RTL_FILE 	:= $(NAME).sv
TB_FILE	 	:= tb_$(NAME).sv
SEQ_FILE 	:= tb_$(NAME)_seq.svh
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
			-cm_name sim1

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
	./simv $(SIM_OPTS)
	@echo "로그 파일 저장 완료: logs/$(LOG_FILE)"
	@echo "의존타겟 [$<] 완료"
	@echo "타겟 [$@] 완료"

simlog:
	./simv $(SIM_OPTS) | tee logs/$(LOG_FILE)
	@echo "로그 파일 저장 완료: logs/$(LOG_FILE)"
	@echo "의존타겟 [$<] 완료"
	@echo "타겟 [$@] 완료"

verdi_c:
	verdi -cov -covdir coverage.vdb

clean:
	rm -rf simv* csrc *.log *.vpd *.fsdb *.key *.h DVE*
	@echo "삭제 완료"


.PHONY: comp run clean init