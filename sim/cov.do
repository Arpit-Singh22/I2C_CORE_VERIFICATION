# 1. Compile
vlog list.svh +incdir+C:/uvm-1.2/src 

# 2. Optimize (Creates 'design.bin' for Visualizer)
vopt work.top -debug -designfile design.bin +cover=fcbest -o write_read_test 

# 3. Run Simulation & Record Database
# Note: "run -all; quit" is now INSIDE the quotes!
vsim -c -visualizer write_read_test \
  -voptargs="+acc" \
  -sv_lib C:/questasim64_2024.1/uvm-1.2/win64/uvm_dpi \
  +UVM_TESTNAME=write_read_test \
  -do "qwavedb +signal+memory+transaction+class+uvm_schematic; run -all; quit"
