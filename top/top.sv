module top;
	reg clk;
	logic rst_n;
	
	tri scl;
	tri sda;

	
	wb_if pif(clk, rst_n);
	i2c_if i2c_bus();
	bind i2c_master_top i2c_assertions i2c_chk(
		.wb_clk_i	(wb_clk_i),
		.wb_rst_i	(wb_rst_i),
		.tip		(tip),
		.scl_pad_i	(scl_pad_i),
		.sda_pad_i	(sda_pad_i)
	);
	i2c_slave_model slave_model(.scl(scl), .sda(sda));

	i2c_master_top dut(
		.wb_clk_i		(pif.wb_clk_i), 
		.wb_rst_i		(pif.wb_rst_i), 
		.arst_i			(1'b1), 
		.wb_adr_i		(pif.wb_addr_i), 
		.wb_dat_i		(pif.wb_dat_i), 
		.wb_dat_o		(pif.wb_dat_o), 
		.wb_we_i		(pif.wb_we_i), 
		.wb_stb_i		(pif.wb_stb_i), 
		.wb_cyc_i		(pif.wb_cyc_i), 
		.wb_ack_o		(pif.wb_ack_o), 
		.wb_inta_o		(pif.wb_inta_o),	
		.scl_pad_i		(i2c_bus.scl_pad_i), 
		.scl_pad_o		(i2c_bus.scl_pad_o), 
		.scl_padoen_o	(i2c_bus.scl_padoen_o),
		.sda_pad_i		(i2c_bus.sda_pad_i), 
		.sda_pad_o		(i2c_bus.sda_pad_o), 
		.sda_padoen_o	(i2c_bus.sda_padoen_o) 
);
	always #10 clk = ~clk;	//50Mhz
	initial begin
		clk = 0;
		rst_n = 1;
		repeat(3) @(posedge clk);
		rst_n = 0;
	end
	
	assign scl = (i2c_bus.scl_padoen_o) ? 1'bz : i2c_bus.scl_pad_o;
	pullup(scl);
	assign sda = (i2c_bus.sda_padoen_o) ? 1'bz : i2c_bus.sda_pad_o;
	pullup(sda);

	assign i2c_bus.scl_pad_i = scl;
	assign i2c_bus.sda_pad_i = sda;
	
	initial begin
	  uvm_config_db#(virtual wb_if)::set(null, "*", "vif", pif);
	  uvm_config_db#(virtual i2c_if)::set(null, "*", "i2c_bus", i2c_bus);
	  //run_test("config_clock_test");
	  //run_test("write_test");
	  run_test("write_read_test");
	end
endmodule
