`include "mem_config.vh"
`include "define.vh"

module sym_vn_lut (
    output wire [2:0] lut_data0,
    output wire [2:0] lut_data1,

    input wire [2:0] lut_in_replicate_0,
    input wire [4:0] write_addr_replicate_0,

    input wire [2:0] lut_in_replicate_1,
    input wire [4:0] write_addr_replicate_1,
        
    input wire [4:0] read_addr0,
    input wire [4:0] read_addr1,
    
    input wire we,
    input wire write_clk
 );

`ifdef LUTRAM_INFER
	// Port 0
   	(* ram_style="distributed" *) reg [1:0] lut_page_bitData_port0_0 [0:`VN_LOAD_CYCLE-1];
   	(* ram_style="distributed" *) reg [0:0] lut_page_bitData_port0_1 [0:`VN_LOAD_CYCLE-1];
	assign lut_data0 = {lut_page_bitData_port0_0[ read_addr0[4:0] ][1:0], lut_page_bitData_port0_1[ read_addr0[4:0] ][0:0]};
	always @(posedge write_clk) begin
		if(we == 1'b1)	begin 
			lut_page_bitData_port0_0[ write_addr_replicate_0[4:0] ][1:0] <= lut_in_replicate_0[2:1];
			lut_page_bitData_port0_1[ write_addr_replicate_0[4:0] ][0:0] <= lut_in_replicate_0[0:0];
		end
	end

    // Port 1
    (* ram_style="distributed" *) reg [1:0] lut_page_bitData_port1_0 [0:`VN_LOAD_CYCLE-1];
    (* ram_style="distributed" *) reg [0:0] lut_page_bitData_port1_1 [0:`VN_LOAD_CYCLE-1];
    assign lut_data1 = {lut_page_bitData_port1_0[ read_addr1[4:0] ][1:0], lut_page_bitData_port1_1[ read_addr1[4:0] ][0:0]};
    always @(posedge write_clk) begin
        if(we == 1'b1)  begin 
            lut_page_bitData_port1_0[ write_addr_replicate_1[4:0] ][1:0] <= lut_in_replicate_1[2:1];
            lut_page_bitData_port1_1[ write_addr_replicate_1[4:0] ][0:0] <= lut_in_replicate_1[0:0];
        end
    end 
`else
`endif
endmodule