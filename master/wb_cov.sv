class wb_cov extends uvm_subscriber#(wb_tx);
	`uvm_component_utils(wb_cov)
	wb_tx tx;

	covergroup wb_cg;
		option.name = "I2C Covergroup";
		WR_RD:coverpoint tx.addr{
			bins READ = {0};
			bins WRITE= {0};
		}
		REGISTER_ACCESS_WR:coverpoint tx.addr{
			bins PRER_LO = {0};
			bins PRER_HI = {1};
			bins CTR = {2};
			bins TXR_RXR = {3};
			bins CR_SR = {4};
		}
		REGISTER_ACCESS_RD:coverpoint tx.addr iff (tx.wr_rd==0){
			bins RXR = {3};
			bins SR = {4};
		}
		CTR:coverpoint tx.data[7:6] iff(tx.addr==2 && tx.wr_rd){
			bins core_off = {2'b00};
			bins en_ien = {2'b11};
		}
		CR:coverpoint tx.data iff(tx.addr==4 && tx.wr_rd){
			bins START_WRITE = {8'h90};
			bins STOP = {8'h40};
			bins START_REAE = {8'hA0};
			bins ACK = {8'h08};
		}
		//cross tx.addr, tx.data iff (tx.addr ==4 && tx.wr_rd);
	endgroup

	function new(string name="", uvm_component parent=null);
		super.new(name,parent);
		wb_cg = new();
	endfunction

	function void write(wb_tx t);
		$cast(tx, t);
		wb_cg.sample();
	endfunction
endclass
