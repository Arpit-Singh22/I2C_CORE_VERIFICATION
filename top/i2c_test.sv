
`include "uvm_macros.svh"
class i2c_test extends uvm_test;
  `uvm_component_utils(i2c_test)
  i2c_env env;
  function new(string name, uvm_component parent); super.new(name, parent); endfunction
  function void build_phase(uvm_phase phase);
    env = i2c_env::type_id::create("env", this);
  endfunction
endclass
