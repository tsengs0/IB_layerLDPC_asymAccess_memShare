// Synchronous write and read
module lutMem_1bankX1port #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [QUAN_SIZE-1:0] read_page_o,
 
    input wire [QUAN_SIZE-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] access_addr_i,
    input wire we_i,
    input wire sys_clk
);

(* ram_style = "distributed" *) reg [QUAN_SIZE-1:0] mem [0:PAGE_NUM-1];
reg [QUAN_SIZE-1:0] mem_out;
always @(posedge sys_clk) begin
    if(we_i == 1'b1)
        mem[access_addr_i] <= write_data_i[QUAN_SIZE-1:0];
    else 
        mem_out[QUAN_SIZE-1:0] <= mem[access_addr_i];
end
assign read_page_o[QUAN_SIZE-1:0] = mem_out[QUAN_SIZE-1:0];
endmodule
