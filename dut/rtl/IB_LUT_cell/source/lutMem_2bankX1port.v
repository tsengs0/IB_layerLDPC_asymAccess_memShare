module lutMem_2bankX1port #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
    parameter BANK_INTERLEAVE = 2,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] read_page_o,
    output wire [QUAN_SIZE-1:0] read_word_o,
 
    input wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] access_addr_i,
    input wire [0:0] read_strobe_i,
    input wire we_i,
    input wire sys_clk
);

localparam PAGE_SIZE = (QUAN_SIZE*BANK_INTERLEAVE);
(* ram_style = "distributed" *) reg [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];
reg [PAGE_SIZE-1:0] mem_out;
always @(posedge sys_clk) begin
    if(we_i == 1'b1)
        mem[access_addr_i] <= write_data_i[PAGE_SIZE-1:0];
    else 
        mem_out[PAGE_SIZE-1:0] <= mem[access_addr_i];
end

assign read_word_o[QUAN_SIZE-1:0] = (read_strobe_i[0]==1'b0) ? mem_out[PAGE_SIZE-1:QUAN_SIZE] : mem_out[QUAN_SIZE-1:0];
assign read_page_o[PAGE_SIZE-1:0] = mem_out[PAGE_SIZE-1:0];
endmodule
