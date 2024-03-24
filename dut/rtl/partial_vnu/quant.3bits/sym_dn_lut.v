`include "mem_config.vh"
`include "define.vh"

module sym_dn_lut (
    output wire lut_data0,
    output wire lut_data1,
 
    input wire lut_in_replicate_0, // written data
    input wire [4:0] write_addr_replicate_0,

    input wire lut_in_replicate_1, // written data
    input wire [4:0] write_addr_replicate_1,        

    input wire [4:0] read_addr0,
    input wire [4:0] read_addr1,
    
    input wire we,
    input wire write_clk
 );

`ifdef LUTRAM_INFER
		// Port 0
		(* ram_style="distributed" *) reg [0:0] lut_page_bitData_port0 [0:`DN_LOAD_CYCLE-1];
		always @(posedge write_clk) begin
			if(we == 1'b1)	lut_page_bitData_port0[ write_addr_replicate_0[4:0] ][0:0] <= lut_in_replicate_0;
		end	
		assign lut_data0 = lut_page_bitData_port0[ read_addr0[4:0] ][0:0];

		// Port 1
		(* ram_style="distributed" *) reg [0:0] lut_page_bitData_port1 [0:`DN_LOAD_CYCLE-1];
		always @(posedge write_clk) begin
			if(we == 1'b1)	lut_page_bitData_port1[ write_addr_replicate_1[4:0] ][0:0] <= lut_in_replicate_1;
		end	
		assign lut_data1 = lut_page_bitData_port1[ read_addr1[4:0] ][0:0];
`else

`endif
endmodule