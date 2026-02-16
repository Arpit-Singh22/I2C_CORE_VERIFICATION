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
add wave -noupdate -group REGISTER /top/dut/prer
add wave -noupdate -group REGISTER /top/dut/ctr
add wave -noupdate -group REGISTER /top/dut/txr
add wave -noupdate -group REGISTER /top/dut/rxr
add wave -noupdate -group REGISTER /top/dut/cr
add wave -noupdate -group REGISTER /top/dut/sr
add wave -noupdate -expand -group PHY /top/scl
add wave -noupdate -expand -group PHY /top/sda
add wave -noupdate -expand -group ASSERTIONS /top/dut/i2c_chk/START_COND_ASSERT
add wave -noupdate -expand -group ASSERTIONS /top/dut/i2c_chk/STOP_COND_ASSERT
add wave -noupdate /top/dut/done
add wave -noupdate /top/dut/core_en
add wave -noupdate /top/dut/ien
add wave -noupdate /top/dut/irxack
add wave -noupdate /top/dut/rxack
add wave -noupdate /top/dut/tip
add wave -noupdate /top/dut/irq_flag
add wave -noupdate /top/dut/i2c_busy
add wave -noupdate /top/dut/i2c_al
add wave -noupdate /top/dut/al
add wave -noupdate /top/dut/rst_i
add wave -noupdate /top/dut/wb_wacc
add wave -noupdate /top/dut/sta
add wave -noupdate /top/dut/sto
add wave -noupdate /top/dut/rd
add wave -noupdate /top/dut/wr
add wave -noupdate /top/dut/ack
add wave -noupdate /top/dut/iack
add wave -noupdate /uvm_pkg::uvm_reg_map::do_write/#ublk#215181159#1762/immed__1766
add wave -noupdate /uvm_pkg::uvm_reg_map::do_read/#ublk#215181159#1802/immed__1806
add wave -noupdate /uvm_pkg::uvm_component_name_check_visitor::visit/immed__262
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
WaveRestoreZoom {0 ps} {1903557600 ps}
