vlog list.svh +acc +incdir+C:/uvm-1.2/src 
#vsim -voptargs="+acc" top \
vsim -novopt -suppress 12110 top \
-sv_lib C:/questasim64_2024.1/uvm-1.2/win64/uvm_dpi
#add wave -r sim:top/*
#do wave.do
run -all
