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

class config_clock_400KHZ_seq extends base_seq_lib;
	`uvm_object_utils(config_clock_400KHZ_seq)
	`NEW_OBJ

	task body();
	//initialize core
		//clk = 50 MHz
		//SCL = 100KHz 
		//PRER = (WB_CLK /(5*SCL))-1 =
		//PRE = 24 = 18(hex)
		//disable core
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERLo; req.data==8'h18;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERHi; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'hC0;});
	endtask
endclass

class config_clock_300HZ_seq extends base_seq_lib;
	`uvm_object_utils(config_clock_300HZ_seq)
	`NEW_OBJ

	task body();
	//initialize core
		//clk = 50 MHz
		//SCL = 300Hz 
		//PRER = (WB_CLK /(5*SCL))-1 =
		//PRE = 33332 = 8234(hex)
		//disable core
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CTR; req.data==8'h00;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERLo; req.data==8'h34;});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`PRERHi; req.data==8'h82;});
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
	write_seq		 write_seq_inst;

	task body();
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

class nack_seq extends base_seq_lib;
	`uvm_object_utils(nack_seq)
	`NEW_OBJ

	config_clock_seq clock_seq;

	task body();
		`uvm_do(clock_seq)
        
        //Slave Address + Write
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h70,1'b0};});
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;}); 
        wait_for_tip();

        //Invalid Memory Address 0x05
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'h05;});
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;}); 
        wait_for_tip();

        //CHECK FOR NACK (Bit 7 of SR)
        if(rsp.data[7] == 1'b1) 
            `uvm_info("NACK_RXD", "SUCCESS: Correctly received NACK for invalid address", UVM_LOW)
        else
            `uvm_error("NACK_ERR", "FAILURE: Master received ACK for invalid address 0x05!")

        //STOP
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h50;}); 
		//ack interrupt
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h01;}); 
        wait_for_tip();
	endtask
endclass


class burst_write_read_seq extends base_seq_lib;
	`uvm_object_utils(burst_write_read_seq)
	`NEW_OBJ
	int burst_len = 4;

	config_clock_400KHZ_seq clock_400_seq;
	task body();
		`uvm_do(clock_400_seq)
		
		//------------------------------------------------------
		//WRITE ADDRESS TO SLAVE
		//------------------------------------------------------
		//load slave address + W bit
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});
		//start + write
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});

		wait_for_tip();

		//------------------------------------------------------
		//SET MEMORY ADDRESS POINTER
		//------------------------------------------------------
		//valid memory pointer from 0-15
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'h00;});
		//write only
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});
		wait_for_tip();
	
		//------------------------------------------------------
		//LOAD DATA
		//------------------------------------------------------
		for (int i=0; i<burst_len; i++) begin
			`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'hA5+i;});
			if (i == burst_len -1) begin 
				//send stop
				`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h50;});
			end else 
				`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h10;});
			wait_for_tip();
		end
		
		//RESET ADDRESS POINTER TO 0X00
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data=={7'h10,1'b0};});
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h90;});
		wait_for_tip();

		//Memory address (0x00) - this resets the pointer
		`uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'h00;});
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

		//read byte from slave
		for (int i=0; i<burst_len; i++) begin
			if (i == burst_len -1) begin
				//STO + RD + NACK
				`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h68;});
			end else
				//read + ack
				`uvm_do_with(req, {req.wr_rd==1; req.addr==`CR; req.data==8'h20;});
			wait_for_tip();
			
			//fetch data
			`uvm_do_with(req, {req.wr_rd==0; req.addr==`RXR;});
			get_response(rsp);

			if(rsp.data==8'hA5+i)
				`uvm_info("RD_DATA", $sformatf("Index %0d: Read 0x%0h Match",i,rsp.data), UVM_LOW)
			else
				`uvm_error("RD_DATA_ERR", $sformatf("Index %0d: Expected 0x%0h got 0x%0h",i,(8'hA5+i),rsp.data))
		end
	endtask
endclass

class write_low_freq_seq extends base_seq_lib;
	`uvm_object_utils(write_low_freq_seq)
	`NEW_OBJ
	config_clock_300HZ_seq clock_300_seq;
	task body();
		`uvm_do(clock_300_seq)

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

class reset_during_xfer_seq extends base_seq_lib;
	`uvm_object_utils(reset_during_xfer_seq)
	`NEW_OBJ
	config_clock_400KHZ_seq clock_seq;

	task body();
		`uvm_do(clock_seq)

        `uvm_do_with(req, {req.wr_rd==1; req.addr==`TXR; req.data==8'hAA;});
        `uvm_do_with(req, {req.wr_rd==1; req.addr==`CR;  req.data==8'h90;}); // START + WR

		wait_for_tip();

        //TRIGGER THE RESET
        fork
            begin
                #10; 
                force top.rst_n= 1'b1; 
                #500ns;
                release top.rst_n;
                force top.rst_n = 1'b0;
            end
        join_none

        //Core should have dropped everything
        #1;
        `uvm_do_with(req, {req.wr_rd==0; req.addr==`SR;});
        get_response(rsp);

        // After reset, TIP should be 0 and the FSM should be in IDLE
        if(rsp.data[1] == 1'b0) begin
            `uvm_info("RST", "SUCCESS: Master returned to IDLE after reset.", UVM_LOW)
        end else begin
            `uvm_error("RST", "FAILURE: Master still shows TIP=1 after reset!")
        end
	endtask
endclass
