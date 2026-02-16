interface wb_if(input bit wb_clk_i, input bit wb_rst_i);
	logic        arst_i;       // asynchronous reset
	logic  [2:0] wb_addr_i;     // lower address bits
	logic  [7:0] wb_dat_i;     // databus input
	logic  [7:0] wb_dat_o;     // databus output
	logic        wb_we_i;      // write enable input
	logic        wb_stb_i;     // stobe/core select signal
	logic        wb_cyc_i;     // valid bus cycle input
	logic        wb_ack_o;     // bus cycle acknowledge output
	logic        wb_inta_o;    // interrupt request signal output

	clocking drv_cb @(posedge wb_clk_i);
		default input #1 output #0;
		output wb_addr_i, wb_dat_i, wb_we_i, wb_stb_i, wb_cyc_i;
		input wb_rst_i, wb_dat_o, wb_ack_o, wb_inta_o;
	endclocking
	clocking mon_cb @(posedge wb_clk_i);
		default input #0;
		input wb_addr_i, wb_dat_i, wb_we_i, wb_stb_i, wb_cyc_i;
		input wb_rst_i, wb_dat_o, wb_ack_o, wb_inta_o;
	endclocking
endinterface
