vlog list.svh +incdir+C:/uvm-1.2/src 
vsim -voptargs="+acc" -debugDB top \
-sv_lib C:/questasim64_2024.1/uvm-1.2/win64/uvm_dpi\
-assertdebug +notimingchecks
#add wave -position insertpoint sim:top/dut/*
#add wave -position insertpoint sim:top/scl
#add wave -position insertpoint sim:top/sda
do wave.do
run -all
