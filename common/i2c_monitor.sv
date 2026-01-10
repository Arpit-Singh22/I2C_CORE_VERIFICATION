
`include "uvm_macros.svh"
class i2c_monitor extends uvm_monitor;
  virtual i2c_if vif;
  `uvm_component_utils(i2c_monitor)
  uvm_analysis_port#(i2c_seq_item) ap;
  function new(string name, uvm_component parent); super.new(name, parent); ap = new("ap", this); endfunction
endclass
