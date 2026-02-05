class base_seq_lib extends uvm_sequence#(wb_tx);
	`uvm_object_utils(base_seq_lib)
	`NEW_OBJ

	task body();
		`uvm_do_with(req, {req.addr==2; req.data[7]==1'b0;});
		`uvm_do_with(req, {req.addr==0; req.data==8'h3F;});
		`uvm_do_with(req, {req.addr==1; req.data==8'h00;});
	endtask
endclass
