//--------------------------------------------------------------------------------------------------------------------
// Asynchronous single-port RAM
// synchronous write and asynchronous read
// Xilinx LUTRAM inferrable by setting the parameter as "XILINX_LUTRAM_INFER=1"
module lutMem_async_1bankX1port_3b #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 32,
	parameter ADDR_BITWIDTH = 5,
    parameter XILINX_LUTRAM_INFER = 1
) (
    output wire [QUAN_SIZE-1:0] read_page_o,

    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire [ADDR_BITWIDTH-1:0] write_data_i,
    input wire [QUAN_SIZE-1:0] write_addr_i,
    input wire we_i,
    input wire write_clk
);

generate
    // The following construction is only for Xilinx FPGA-specific optimality
    if(XILINX_LUTRAM_INFER==1) begin
        (* ram_style="distributed" *) reg [1:0] lut_page_bitData_port0_0 [0:PAGE_NUM-1];
        (* ram_style="distributed" *) reg [0:0] lut_page_bitData_port0_1 [0:PAGE_NUM-1];
        assign read_page_o = {lut_page_bitData_port0_0[ read_addr_i[ADDR_BITWIDTH-1:0] ][1:0], lut_page_bitData_port0_1[ read_addr_i[ADDR_BITWIDTH-1:0] ][0:0]};
        always @(posedge write_clk) begin
         if(we_i == 1'b1)	begin 
             lut_page_bitData_port0_0[ write_data_i[ADDR_BITWIDTH-1:0] ][1:0] <= write_data_i[2:1];
             lut_page_bitData_port0_1[ write_data_i[ADDR_BITWIDTH-1:0] ][0:0] <= write_data_i[0:0];
         end
        end
    end
endgenerate
endmodule
