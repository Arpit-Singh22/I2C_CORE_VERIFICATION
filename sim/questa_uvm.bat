@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

set QUESTAPATH=C:\questasim64_2024.1\win64
set UVM_DPI_PATH=C:\questasim64_2024.1\uvm-1.2\win64

"C:\questasim64_2024.1\win64\vsim.exe" -sv_lib "C:\questasim64_2024.1\uvm-1.2\win64\uvm_dpi"
