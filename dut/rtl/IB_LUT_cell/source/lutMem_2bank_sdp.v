module lutMem_2bank_sdp #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
    parameter BANK_INTERLEAVE = 2,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] read_page_o,
    output wire [QUAN_SIZE-1:0] read_word_o,
 
    input wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] write_addr_i,
    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire [0:0] read_strobe_i,
    input wire we_i,
    input wire read_clk,
    input wire write_clk
);

localparam PAGE_SIZE = (QUAN_SIZE*BANK_INTERLEAVE);
(* ram_style = "distributed" *) reg [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];
wire [PAGE_SIZE-1:0] mem_out;
always @(posedge write_clk) begin
    if(we_i == 1'b1)
        mem[write_addr_i] <= write_data_i[PAGE_SIZE-1:0];
end

assign mem_out[PAGE_SIZE-1:0] = mem[read_addr_i];
assign read_word_o[QUAN_SIZE-1:0] = (read_strobe_i[0]==1'b0) ? mem_out[PAGE_SIZE-1:QUAN_SIZE] : mem_out[QUAN_SIZE-1:0];
assign read_page_o[PAGE_SIZE-1:0] = mem_out[PAGE_SIZE-1:0];
endmodule
