class base_seq_lib extends uvm_sequence#(wb_tx);
	`uvm_object_utils(base_seq_lib)
	`NEW_OBJ

endclass

class config_clock_seq extends base_seq_lib;
	`uvm_object_utils(config_clock_seq)
	`NEW_OBJ

	task body();
	//initialize core
		//clk = 50 MHz
		//SCL = 50KHz 
		//PRE = 1000 = 0110_1000 = 3E8 
		//clk = 25 MHz
		//SCL = 100KHz 
		//PRE = 49 = 31(hex)
		//disable core
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERLo; req.data==8'h31;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERHi; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'hC0;});
	endtask
endclass

class write_seq extends base_seq_lib;
	`uvm_object_utils(write_seq)
	`NEW_OBJ
	config_clock_seq clock_seq;

	task body();
		`uvm_do(clock_seq)

		//start write transfer 
		//start + write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});
		//load slave address + W bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});


		//wait for completion (TIP to clear)
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
		end while (req.data[1] == 1'b1);

		//Load data
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={8'hAC};});

		//write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});

		//wait for completion (TIP to clear)
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
		end while (req.data[1] == 1'b1);

		//Stop
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h40;});
		//disable core
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
	endtask
endclass

class write_read_seq extends base_seq_lib;
	`uvm_object_utils(write_read_seq)
	`NEW_OBJ
	config_clock_seq clock_seq;

	task body();
		`uvm_do(clock_seq)
		
		//----------------------------------------------
		//write phase
		//------------------------------------------------
		//load slave address + W bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});
		//start + write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});

		//wait for completion (TIP to clear)
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
		end while (req.data[1] == 1'b1);

		//Load data byte
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={8'h04};});

		//write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});

		//wait for completion (TIP to clear)
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
		end while (req.data[1] == 1'b1);

		//-------------------------------------------------
		//receive phase
		//-------------------------------------------------
		//write slave address + read bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b1};});

		//repeated start + read
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'hA0;});


		//wait for completion (TIP to clear)
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
		end while (req.data[1] == 1'b1);
		
		//read byte from slave
		`uvm_do_with(req, {req.wr_rd==0; req.addr==`RXR;});

		//NACK + Stop
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h68;});

		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
	endtask
endclass
