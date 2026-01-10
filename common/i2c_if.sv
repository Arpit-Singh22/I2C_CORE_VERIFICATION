interface i2c_if (input bit clk, input bit rst_n);
	logic        wb_clk_i;     // master clock input
	logic        wb_rst_i;     // synchronous active high reset
	logic        arst_i;       // asynchronous reset
	logic  [2:0] wb_adr_i;     // lower address bits
	logic  [7:0] wb_dat_i;     // databus input
	logic  [7:0] wb_dat_o;     // databus output
	logic        wb_we_i;      // write enable input
	logic        wb_stb_i;     // stobe/core select signal
	logic        wb_cyc_i;     // valid bus cycle input
	logic        wb_ack_o;     // bus cycle acknowledge output
	logic        wb_inta_o;    // interrupt request signal output

	// I2C signals
	// i2c clock line
	logic scl_pad_i;       // SCL-line input
	logic scl_pad_o;       // SCL-line output (always 1'b0)
	logic scl_padoen_o;    // SCL-line output enable (active low)

	// i2c data line
	logic sda_pad_i;       // SDA-line input
	logic sda_pad_o;       // SDA-line output (always 1'b0)
	logic sda_padoen_o; 

endinterface
