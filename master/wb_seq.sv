class base_seq_lib extends uvm_sequence#(wb_tx);
	`uvm_object_utils(base_seq_lib)
	`NEW_OBJ

	task pre_body();
		starting_phase = get_starting_phase();
		if(starting_phase != null)
			starting_phase.raise_objection(this);
	endtask

	task post_body();
		if(starting_phase != null)
			starting_phase.phase_done.set_drain_time(this,2000);
			starting_phase.drop_objection(this);
	endtask

	task wait_for_tip();
		do begin
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
			get_response(rsp);
		end while (rsp.data[1] == 1'b1); // Wait for TIP to clear
	endtask
endclass

class config_clock_seq extends base_seq_lib;
	`uvm_object_utils(config_clock_seq)
	`NEW_OBJ

	task body();
	//initialize core
		//clk = 50 MHz
		//SCL = 40KHz 
		//PRER = (WB_CLK /(5*SCL))-1 =
		//PRE = 249 = F9(hex)
		//disable core
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERLo; req.data==8'hF9;});
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

		//------------------------------------------------------
		//WRITE ADDRESS TO SLAVE
		//------------------------------------------------------
		//load slave address + W bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});
		//start + write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});

		wait_for_tip();

		//read RxACK bit
		if(rsp.data[7]==1'b1) begin
			`uvm_error("STATUS_ERR", "Slave NaCK the address")
			return;
		end
		else `uvm_info("SR","slave ack the address", UVM_LOW)

		//------------------------------------------------------
		//SET MEMORY ADDRESS POINTER
		//------------------------------------------------------
		//valid memory pointer from 0-15
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'h01;});
		//write only
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});
		wait_for_tip();
	
		//------------------------------------------------------
		//LOAD DATA
		//------------------------------------------------------
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'hA5;});
		//set STO + WR
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h50;});

		wait_for_tip();

		//read RxACK bit
		if(rsp.data[7]==1'b1) begin
			`uvm_error("STATUS_ERR", "Slave NaCK the data")
			return;
		end
		else `uvm_info("SR","slave ack the data", UVM_LOW)
	endtask
endclass

class write_read_seq extends base_seq_lib;
	`uvm_object_utils(write_read_seq)
	`NEW_OBJ
	config_clock_seq clock_seq;
	write_seq		 write_seq_inst;

	task body();
		`uvm_do(clock_seq)
		`uvm_do(write_seq_inst)
		
		//RESET ADDRESS POINTER TO 0X05
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});
		wait_for_tip();

		//Memory address (0x05) - this resets the pointer
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'h01;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});
		wait_for_tip();


		//-------------------------------------------------
		//read phase
		//-------------------------------------------------
		//write slave address + read bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b1};});
		//repeated start + write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});

		wait_for_tip();

		//STO + RD + NACK
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h68;});

		wait_for_tip();

		//read byte from slave
		`uvm_do_with(req, {req.wr_rd==0; req.addr==`RXR;});
		get_response(rsp);

		if(rsp.data==8'hA5)
			`uvm_info("RD_DATA", "Read back 0xA5", UVM_LOW)
		else
			`uvm_error("RD_ERR", $sformatf("Mismatch! Expected 0xA5, got 0x%0h",rsp.data))
	endtask
endclass

