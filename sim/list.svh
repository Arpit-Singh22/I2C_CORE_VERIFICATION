`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "../rtl/i2c_master_top.v"

`include "../common/common.sv"
`include "../common/wb_if.sv"
`include "../common/i2c_if.sv"

`include "../master/wb_seq_item.sv"
`include "../master/wb_seq.sv"
`include "../master/wb_sqr.sv"
`include "../master/wb_driver.sv"
//`include "../common/wb_monitor.sv"
`include "../master/wb_agent.sv"

`include "../top/i2c_env.sv"
`include "../top/i2c_test.sv"
`include "../top/top.sv"
