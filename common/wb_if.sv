interface wb_if(input bit wb_clk_i, input bit wb_rst_i);
	bit        arst_i;       // asynchronous reset
	bit  [2:0] wb_addr_i;     // lower address bits
	bit  [7:0] wb_dat_i;     // databus input
	bit  [7:0] wb_dat_o;     // databus output
	bit        wb_we_i;      // write enable input
	bit        wb_stb_i;     // stobe/core select signal
	bit        wb_cyc_i;     // valid bus cycle input
	bit        wb_ack_o;     // bus cycle acknowledge output
	bit        wb_inta_o;    // interrupt request signal output

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
