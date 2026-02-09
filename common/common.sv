`define NEW_COMP \
function new(string name="", uvm_component parent); \
	super.new(name, parent); \
endfunction

`define NEW_OBJ \
function new(string name=""); \
	super.new(name); \
endfunction

`define PRERLo 0
`define PRERHi 1
`define CTR    2
`define TXR    3
`define RXR    3
`define CR 	   4
`define SR 	   4

