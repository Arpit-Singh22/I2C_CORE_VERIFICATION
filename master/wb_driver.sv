class wb_driver extends uvm_driver#(wb_tx);
	virtual wb_if vif;
	`uvm_component_utils(wb_driver)
	`NEW_COMP
	wb_tx rsp;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual wb_if)::get(this, "","vif", vif))
			`uvm_error("INTFERR", "Failed to get vif in driver")
	endfunction

	task run_phase(uvm_phase phase);
		wait (vif.wb_rst_i == 0);
		forever begin
			seq_item_port.get_next_item(req);
			drive_tx(req);
			if(req.wr_rd==0) begin
				$cast(rsp, req);
				rsp.set_id_info(req);
				seq_item_port.item_done(rsp);
			end
			else seq_item_port.item_done();
		end
	endtask

		task drive_tx(wb_tx tx);
            @(vif.drv_cb);
            vif.drv_cb.wb_addr_i <= tx.addr[2:0];
            vif.drv_cb.wb_we_i   <= tx.wr_rd;
            vif.drv_cb.wb_stb_i  <= 1'b1;
            vif.drv_cb.wb_cyc_i  <= 1'b1;

            if (tx.wr_rd == 1) vif.drv_cb.wb_dat_i <= tx.data;
            
            // Wait for ACK
            do begin
                @(vif.drv_cb);
            end while (vif.drv_cb.wb_ack_o !== 1'b1); 

            if(tx.wr_rd == 0 ) tx.data = vif.drv_cb.wb_dat_o;

            @(vif.drv_cb); 
            vif.drv_cb.wb_stb_i  <= 0; 
            vif.drv_cb.wb_cyc_i  <= 0; 
            vif.drv_cb.wb_addr_i <= 0; 
            vif.drv_cb.wb_dat_i  <= 0;
            vif.drv_cb.wb_we_i   <= 0;
            
    endtask
endclass
