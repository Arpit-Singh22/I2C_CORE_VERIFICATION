onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut/wb_clk_i
add wave -noupdate /top/dut/wb_rst_i
add wave -noupdate -group WISHBONE /top/dut/arst_i
add wave -noupdate -group WISHBONE /top/dut/wb_adr_i
add wave -noupdate -group WISHBONE /top/dut/wb_dat_i
add wave -noupdate -group WISHBONE /top/dut/wb_dat_o
add wave -noupdate -group WISHBONE /top/dut/wb_we_i
add wave -noupdate -group WISHBONE /top/dut/wb_stb_i
add wave -noupdate -group WISHBONE /top/dut/wb_cyc_i
add wave -noupdate -group WISHBONE /top/dut/wb_ack_o
add wave -noupdate -group WISHBONE /top/dut/wb_inta_o
add wave -noupdate -group WISHBONE /top/dut/scl_pad_i
add wave -noupdate -group WISHBONE /top/dut/scl_pad_o
add wave -noupdate -group WISHBONE /top/dut/scl_padoen_o
add wave -noupdate -group WISHBONE /top/dut/sda_pad_i
add wave -noupdate -group WISHBONE /top/dut/sda_pad_o
add wave -noupdate -group WISHBONE /top/dut/sda_padoen_o
add wave -noupdate -expand -group REGISTER /top/dut/prer
add wave -noupdate -expand -group REGISTER /top/dut/ctr
add wave -noupdate -expand -group REGISTER /top/dut/txr
add wave -noupdate -expand -group REGISTER /top/dut/rxr
add wave -noupdate -expand -group REGISTER /top/dut/cr
add wave -noupdate -expand -group REGISTER /top/dut/sr
add wave -noupdate -expand -group PHY /top/slave_model/scl
add wave -noupdate -expand -group PHY /top/slave_model/sda
add wave -noupdate -group INTERNAL_SIG /top/dut/done
add wave -noupdate -group INTERNAL_SIG /top/dut/core_en
add wave -noupdate -group INTERNAL_SIG /top/dut/ien
add wave -noupdate -group INTERNAL_SIG /top/dut/irxack
add wave -noupdate -group INTERNAL_SIG /top/dut/rxack
add wave -noupdate -group INTERNAL_SIG /top/dut/tip
add wave -noupdate -group INTERNAL_SIG /top/dut/irq_flag
add wave -noupdate -group INTERNAL_SIG /top/dut/i2c_busy
add wave -noupdate -group INTERNAL_SIG /top/dut/i2c_al
add wave -noupdate -group INTERNAL_SIG /top/dut/al
add wave -noupdate -group INTERNAL_SIG /top/dut/rst_i
add wave -noupdate -group INTERNAL_SIG /top/dut/wb_wacc
add wave -noupdate -group INTERNAL_SIG /top/dut/sta
add wave -noupdate -group INTERNAL_SIG /top/dut/sto
add wave -noupdate -group INTERNAL_SIG /top/dut/rd
add wave -noupdate -group INTERNAL_SIG /top/dut/wr
add wave -noupdate -group INTERNAL_SIG /top/dut/ack
add wave -noupdate -group INTERNAL_SIG /top/dut/iack
add wave -noupdate -expand -group ASSERTIONS /top/dut/i2c_chk/START_CONDITION
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {278600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 175
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {220523100 ps}
