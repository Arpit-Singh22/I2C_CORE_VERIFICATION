vlog list.svh +acc +incdir+C:/uvm-1.2/src 
#vsim -voptargs="+acc" top
vsim -novopt -suppress 12110 top \
-sv_lib C:/questasim64_2024.1/uvm-1.2/win64/uvm_dpi -debugDB\
+UVM_OBJECTION_TRACE
add wave -position insertpoint sim:top/dut/*
#do wave.do
run -all
