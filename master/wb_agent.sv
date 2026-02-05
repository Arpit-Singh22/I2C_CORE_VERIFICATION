class wb_agent extends uvm_agent;
	`uvm_component_utils(wb_agent)
	`NEW_COMP
	wb_sqr sqr;
	wb_driver drv;
	//wb_monitor mon;
	function void build_phase(uvm_phase phase);
	  sqr = wb_sqr::type_id::create("sqr", this);
	  drv = wb_driver::type_id::create("drv", this);
	  //mon = wb_monitor::type_id::create("mon", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass
