
`include "uvm_macros.svh"
class i2c_env extends uvm_env;
  `uvm_component_utils(i2c_env)
  i2c_agent agt;
  function new(string name, uvm_component parent); super.new(name, parent); endfunction
  function void build_phase(uvm_phase phase);
    agt = i2c_agent::type_id::create("agt", this);
  endfunction
endclass
