
`include "uvm_macros.svh"
class i2c_driver extends uvm_driver #(i2c_seq_item);
  virtual i2c_if vif;
  `uvm_component_utils(i2c_driver)
  function new(string name, uvm_component parent); super.new(name, parent); endfunction
  task run_phase(uvm_phase phase);
    // Implement later
  endtask
endclass
