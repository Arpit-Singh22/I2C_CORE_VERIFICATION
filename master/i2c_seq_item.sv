
`include "uvm_macros.svh"
class i2c_seq_item extends uvm_sequence_item;
  rand bit dummy;
  `uvm_object_utils(i2c_seq_item)
  function new(string name="i2c_seq_item"); super.new(name); endfunction
endclass
