class i2c_env extends uvm_env;
  `uvm_component_utils(i2c_env)
  `NEW_COMP
  wb_agent agt;

  function void build_phase(uvm_phase phase);
    agt = wb_agent::type_id::create("wb_agent", this);
  endfunction
endclass
