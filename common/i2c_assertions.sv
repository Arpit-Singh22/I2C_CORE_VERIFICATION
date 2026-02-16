module i2c_assertions (
    input logic wb_clk_i,
    input logic wb_rst_i,
    input logic tip,
    input logic scl_pad_i,
    input logic sda_pad_i
);
	//to check data is changing only scl is high
	property valid_bus_change;
		@(posedge wb_clk_i)
			(scl_pad_i && $changed(sda_pad_i)) |->
			($fell(sda_pad_i) || $rose(sda_pad_i));
	endproperty
	//VALID_BUS_ASSERT: assert property (valid_bus_change)
	//			else $error("valid bus change is violated");
	//VALID_BUS_COVER: cover property (valid_bus_change);

	//start condition
	property start_cond_prop;
		@(posedge wb_clk_i) (scl_pad_i && $fell(sda_pad_i)) |-> $fell(sda_pad_i);
	endproperty
	
	START_COND_ASSERT: assert property (start_cond_prop)
		else $error("incorrect start condition");

	//stop condition
	property stop_cond_prop;
		@(posedge wb_clk_i) (scl_pad_i && $rose(sda_pad_i)) |-> $rose(sda_pad_i);
	endproperty

	STOP_COND_ASSERT: assert property (stop_cond_prop)
		else $error("incorrect stop condition");
endmodule
