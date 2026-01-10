vlog list.svh +incdir+/home/jedi/Downloads/uvm-1.2/src +define+TX_COMPARE\
-assertdebug
vsim -novopt -suppress 12110 top \
-sv_lib /usr/local/questasim/uvm-1.2/linux_x86_64/uvm_dpi
#add wave -position insertpoint sim:/top/pif/*
do wave.do
run -all 
