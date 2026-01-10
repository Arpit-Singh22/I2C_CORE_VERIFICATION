module top;
	bit clk = 0, rst_n = 0;
	always #5 clk = ~clk;
	initial begin
	  rst_n = 0; #20; rst_n = 1;
	end
	i2c_if pif(clk, rst_n);
	
	i2c_master_top dut(
		.wb_clk_i(pif.wb_clk_i), 
		.wb_rst_i(pif.wb_rst_i), 
		.arst_i(pif.arst_i), 
		.wb_adr_i(pif.wb_adr_i), 
		.wb_dat_i(pif.wb_dat_i), 
		.wb_dat_o(pif.wb_dat_o), 
		.wb_we_i(pif.wb_we_i), 
		.wb_stb_i(pif.wb_stb_i), 
		.wb_cyc_i(pif.wb_cyc_i), 
		.wb_ack_o(pif.wb_ack_o), 
		.wb_inta_o(pif.wb_inta_o),	
	 	.wb_dat_(pif.wb_dat_),
	 	.wb_ack_(pif.wb_ack_),
		.wb_inta(pif.wb_inta_),
		.scl_pad_i(pif.scl_pad_i), 
		.scl_pad_o(pif.scl_pad_o), 
		.scl_padoen_o(pif.scl_padoen_o),
		.sda_pad_i(pif.sda_pad_i), 
		.sda_pad_o(pif.sda_pad_o), 
		.sda_padoen_o(pif.sda_padoen_o) 
);
	
	initial begin
	  uvm_config_db#(virtual i2c_if)::set(null, "*", "vif", pif);
	  run_test("i2c_test");
	end
endmodule
