class test_lib extends uvm_test;
	`uvm_component_utils(test_lib)
	`NEW_COMP

	i2c_env env;
	function void build_phase(uvm_phase phase);
	  env = i2c_env::type_id::create("env", this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass

class base_test extends test_lib;
	`uvm_component_utils(base_test)
	`NEW_COMP

	task run_phase(uvm_phase phase);
		base_seq_lib seq = base_seq_lib::type_id::create("seq");
		phase.raise_objection(this);
		super.run_phase(phase);
		seq.start(env.agt.sqr);
		phase.phase_done.set_drain_time(this, 100);
		phase.drop_objection(this);
	endtask
endclass
