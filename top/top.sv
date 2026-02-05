module top;
	reg clk;
	logic rst_n;

	logic scl_pad_i;
    logic scl_pad_o;
    logic scl_padoen_o;
    logic sda_pad_i;
    logic sda_pad_o;
    logic sda_padoen_o;
	
	wb_if pif(clk, rst_n);
	i2c_if i2c_bus();

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
		.scl_pad_i		(scl_pad_i), 
		.scl_pad_o		(scl_pad_o), 
		.scl_padoen_o	(scl_padoen_o),
		.sda_pad_i		(sda_pad_i), 
		.sda_pad_o		(sda_pad_o), 
		.sda_padoen_o	(sda_padoen_o) 
);
	always #5 clk = ~clk;
	initial begin
		clk = 0;
		rst_n = 0;
		repeat(3) @(posedge clk);
		rst_n = 1;
	end
	
	assign i2c_bus.scl = scl_padoen_o ? 1'bz : scl_pad_o;
	assign i2c_bus.sda = sda_padoen_o ? 1'bz : sda_pad_o;

	assign scl_pad_i = i2c_bus.scl;
	assign sda_pad_i = i2c_bus.sda;
	
	initial begin
	  uvm_config_db#(virtual wb_if)::set(null, "*", "vif", pif);
	  uvm_config_db#(virtual i2c_if)::set(null, "*", "i2c_bus", i2c_bus);
	  run_test("base_test");
	end
endmodule
