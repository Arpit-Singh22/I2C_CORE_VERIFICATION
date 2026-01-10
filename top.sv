module top;
  bit clk = 0, rst_n = 0;
  always #5 clk = ~clk;
  initial begin
    rst_n = 0; #20; rst_n = 1;
  end
  i2c_if vif(clk, rst_n);
  initial begin
    uvm_config_db#(virtual i2c_if)::set(null, "*", "vif", vif);
    run_test("i2c_test");
  end
endmodule
