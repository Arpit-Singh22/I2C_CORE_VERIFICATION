module i2c_assertions (
    input logic wb_clk_i,
    input logic wb_rst_i,
    input logic tip,
    input logic scl_pad_i,
    input logic sda_pad_i
);
	//SDA must go from High to Low while SCL is High
	property start_condition;
		@(posedge scl_pad_i) disable iff(wb_rst_i) ($fell(sda_pad_i) && scl_pad_i==1'b	1);
	endproperty
	//START_CONDITION: assert property (start_condition);
endmodule
