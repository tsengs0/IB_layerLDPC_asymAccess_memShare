// Pseudo/Simple dual-port RAM
module lutMem_1bank_sdp #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [QUAN_SIZE-1:0] read_page_o,
 
    input wire [QUAN_SIZE-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] write_addr_i,
    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire we_i,
    input wire read_clk,
    input wire write_clk
);

(* ram_style = "distributed" *) reg [QUAN_SIZE-1:0] mem [0:PAGE_NUM-1];
wire [QUAN_SIZE-1:0] mem_out;
always @(posedge write_clk) begin
    if(we_i == 1'b1)
        mem[write_addr_i] <= write_data_i[QUAN_SIZE-1:0]; 
end
assign mem_out[QUAN_SIZE-1:0] = mem[read_addr_i];
assign read_page_o[QUAN_SIZE-1:0] = mem_out[QUAN_SIZE-1:0];
endmodule