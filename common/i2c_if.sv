interface i2c_if;
	tri scl;
	tri sda;

	//master side signals
	logic scl_pad_o;
	logic scl_padoen_o;
	logic scl_pad_i;

	logic sda_pad_o;
	logic sda_padoen_o;
	logic sda_pad_i;

	modport phy_mp(
		input scl,
		input sda
	);
endinterface
