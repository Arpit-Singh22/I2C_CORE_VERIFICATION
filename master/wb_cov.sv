class wb_cov extends uvm_subscriber#(wb_tx);
	`uvm_component_utils(wb_cov)
	wb_tx tx;

	covergroup wb_cg;
		coverpoint tx.addr{
			option.auto_bin_max addr =  8; 
		}
	endgroup

	function new(string name="", uvm_component parent=null);
		super.new(name,parent);
		wb_cg = new();
	endfunction

	function void write(wb_cg t);
		$cast(tx, t);
		wb_cg.sample();
	endfunction
endclass
