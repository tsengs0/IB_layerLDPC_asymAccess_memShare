// Pseudo/Simple dual-port RAM
// Area-optimal RAM macros of 32wordx4bit
// Technology dependence: Xilinx UltraScale+ Architecture
module lutMem_optimal_32w4b #(
    parameter ASYNC_RD = 1, // 0: synchronous read with "sys_clk", 1: asynchronous read
	parameter QUAN_SIZE = 4, // Don't touch
    parameter PAGE_NUM = 32,
	parameter ADDR_BITWIDTH = 5
) (
    output logic [QUAN_SIZE-1:0] read_page_o,
 
    input logic [QUAN_SIZE-1:0] write_data_i,
    input logic [ADDR_BITWIDTH-1:0] write_addr_i,
    input logic [ADDR_BITWIDTH-1:0] read_addr_i,
    input logic we_i,
    input logic sys_clk
);

logic [1:0] rdata_unit [0:1];
lutMem_1bank_sdp #(
    .QUAN_SIZE(2),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutram_asyncRD_32w2b_unit0 (
    .read_page_o  (rdata_unit[0]),
    .write_data_i (write_data_i[1:0]),
    .write_addr_i (write_addr_i[ADDR_BITWIDTH-1:0]),
    .read_addr_i  (read_addr_i),
    .we_i         (we_i),
    .write_clk    (sys_clk)
);
lutMem_1bank_sdp #(
    .QUAN_SIZE(2),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutram_asyncRD_32w2b_unit1 (
    .read_page_o  (rdata_unit[1]),
    .write_data_i (write_data_i[3:2]),
    .write_addr_i (write_addr_i[ADDR_BITWIDTH-1:0]),
    .read_addr_i  (read_addr_i[ADDR_BITWIDTH-1:0]),
    .we_i         (we_i),
    .write_clk    (sys_clk)
);

genvar i;
generate;
// Sync. or Async read
if(ASYNC_RD==1) begin
    assign read_page_o[1:0] = rdata_unit[0];
    assign read_page_o[3:2] = rdata_unit[1];
end
else begin
    always @(posedge sys_clk) read_page_o[3:0] <= {rdata_unit[1], rdata_unit[0]};
end
endgenerate
endmodule