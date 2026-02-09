class wb_driver extends uvm_driver#(wb_tx);
	virtual wb_if vif;
	`uvm_component_utils(wb_driver)
	`NEW_COMP

	function void build();
		if(!uvm_config_db#(virtual wb_if)::get(this, "","vif", vif))
			`uvm_error("INTFERR", "Failed to get vif in driver")
	endfunction

	task run_phase(uvm_phase phase);
		wait (vif.wb_rst_i == 0);
		forever begin
			seq_item_port.get_next_item(req);
			drive_tx(req);
			//req.print();
			seq_item_port.item_done();
		end
	endtask

		task drive_tx(wb_tx tx);
			@(vif.drv_cb);
			vif.drv_cb.wb_addr_i <= tx.addr[2:0];
			vif.drv_cb.wb_we_i  <= tx.wr_rd;
			vif.drv_cb.wb_stb_i <= 1'b1;
			vif.drv_cb.wb_cyc_i <= 1'b1;

			if (tx.wr_rd == 1) vif.drv_cb.wb_dat_i <= tx.data;
			do begin
				@(vif.drv_cb);
			end while (vif.drv_cb.wb_ack_o != 1'b1);
			if(tx.wr_rd == 0 ) tx.data = vif.drv_cb.wb_dat_o;

			@(vif.drv_cb);
			@(vif.drv_cb);
			vif.drv_cb.wb_stb_i <= 0; 
			vif.drv_cb.wb_cyc_i <= 0; 
			vif.drv_cb.wb_addr_i <= 0; 
			vif.drv_cb.wb_dat_i <= 0;
	endtask	
endclass
