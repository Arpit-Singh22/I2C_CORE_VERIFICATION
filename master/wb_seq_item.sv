class wb_tx extends uvm_sequence_item;
	rand bit [2:0] addr;
	rand bit [7:0] data;
	rand bit [3:0] sel;
	rand bit wr_rd;

	`uvm_object_utils_begin(wb_tx)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(sel, UVM_ALL_ON)
		`uvm_field_int(wr_rd, UVM_ALL_ON)
	`uvm_object_utils_end
	`NEW_OBJ
endclass
