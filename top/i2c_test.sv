class test_lib extends uvm_test;
	`uvm_component_utils(test_lib)
	`NEW_COMP
	virtual wb_if vif;

	i2c_env env;
	function void build_phase(uvm_phase phase);
	  env = i2c_env::type_id::create("env", this);
	  uvm_config_db#(virtual wb_if)::get(this, "*","vif", vif);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass

`define I2C_TEST(TESTNAME, SEQ) \
class TESTNAME extends test_lib; \
	`uvm_component_utils(TESTNAME)\
	`NEW_COMP \
\
	task run_phase(uvm_phase phase);\
		SEQ seq = SEQ::type_id::create($sformatf(SEQ));\
		super.run_phase(phase);\
		seq.set_starting_phase(phase);\
		seq.start(env.agt.sqr);\
	endtask\
endclass


`I2C_TEST(config_clock_test, config_clock_seq)
`I2C_TEST(config_clock_400KHZ_test, config_clock_400KHZ_seq)
`I2C_TEST(write_test, write_seq)
`I2C_TEST(write_low_freq_test, write_low_freq_seq)
`I2C_TEST(write_read_test, write_read_seq)
`I2C_TEST(burst_write_read_test, burst_write_read_seq)
`I2C_TEST(nack_test, nack_seq)
`I2C_TEST(reset_during_xfer_test, reset_during_xfer_seq)
