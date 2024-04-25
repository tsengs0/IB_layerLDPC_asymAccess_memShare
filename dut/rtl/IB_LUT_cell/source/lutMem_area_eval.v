/*
two column banks inside one memory cell
two/one interleaving banks inside one memory cell

Total amount of compression pattens in one column bank: ${2^{2W-1}} \over {2^{W-1}} = 2^W$.
Size of one compression pattern: W bits.
____________________________________________________________________________________________________________________________________
| Type ID | Bank interleaving | W [bit] | Configuration                 | memory bit | Preload cycle [cc] | LUTRAM | Logic LUT | FF |
|_________|___________________|_________|_______________________________|____________|____________________|________|___________|____|
| 1       | single bank       | 3       | 16 pages x 3 bits             | 48         | 16                 | 2      | 1         | 3  |                 
|------------------------------------------------------------------------------------------------------------------|-----------|----|
| 2       | two bank          | 3       | (8 pages x 3 bits) x 2 banks  | 48         | 8                  | 3      | 3         | 12 |                 
|------------------------------------------------------------------------------------------------------------------|-----------|----|
| 3       | single bank       | 4       | 32 pages x 4 bits             | 128        | 32                 | 2      | 1         | 4  |                 
|------------------------------------------------------------------------------------------------------------------------------|----|
| 4       | two bank          | 4       | (16 pages x 4 bits) x 2 banks | 128        | 16                 | 4      | 3         | 16 |                 
|_________|___________________|_________|_______________________________|____________|____________________|________|___________|____|
*/
module lutMem_area_eval (
output wire [3-1:0] read_page_u0,
input wire [3-1:0] write_data_u0,
input wire [4-1:0] access_addr_u0,
input wire we_u0,
input wire sys_clk_u0,

output wire [(3*2)-1:0] read_page_u1,
output wire [3-1:0] read_word_u1,
input wire [(3*2)-1:0] write_data_u1,
input wire [3-1:0] access_addr_u1,
input wire [0:0] read_strobe_u1,
input wire we_u1,
input wire sys_clk_u1,

output wire [4-1:0] read_page_u2,
input wire [4-1:0] write_data_u2,
input wire [5-1:0] access_addr_u2,
input wire we_u2,
input wire sys_clk_u2,

output wire [(4*2)-1:0] read_page_u3,
output wire [4-1:0] read_word_u3,
input wire [(4*2)-1:0] write_data_u3,
input wire [4-1:0] access_addr_u3,
input wire [0:0] read_strobe_u3,
input wire we_u3,
input wire sys_clk_u3,
//---------------------------------------
output wire [3-1:0] read_page_u4,
input wire [3-1:0] write_data_u4,
input wire [4-1:0] write_addr_u4,
input wire [4-1:0] read_addr_u4,
input wire we_u4,
input wire write_clk_u4,
input wire read_clk_u4,

output wire [(3*2)-1:0] read_page_u5,
output wire [3-1:0] read_word_u5,
input wire [(3*2)-1:0] write_data_u5,
input wire [3-1:0] write_addr_u5,
input wire [3-1:0] read_addr_u5,
input wire [0:0] read_strobe_u5,
input wire we_u5,
input wire write_clk_u5,
input wire read_clk_u5,

output wire [4-1:0] read_page_u6,
input wire [4-1:0] write_data_u6,
input wire [5-1:0] write_addr_u6,
input wire [5-1:0] read_addr_u6,
input wire we_u6,
input wire write_clk_u6,
input wire read_clk_u6,

output wire [(4*2)-1:0] read_page_u7,
output wire [4-1:0] read_word_u7,
input wire [(4*2)-1:0] write_data_u7,
input wire [4-1:0] write_addr_u7,
input wire [4-1:0] read_addr_u7,
input wire [0:0] read_strobe_u7,
input wire we_u7,
input wire write_clk_u7,
input wire read_clk_u7
);
//---------------------------------------------
// Instantiation of single-port RAM
//---------------------------------------------
lutMem_1bankX1port #(
    .QUAN_SIZE(3),
    .PAGE_NUM(16),
    .ADDR_BITWIDTH(4)
) lutMem_1bankX1port_3b (
    .read_page_o   (read_page_u0),
    .write_data_i  (write_data_u0),
    .access_addr_i (access_addr_u0),
    .we_i          (we_u0),
    .sys_clk       (sys_clk_u0)
);
//-----------------------------------
lutMem_2bankX1port #(
    .QUAN_SIZE(3),
    .PAGE_NUM(8),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(3)
) lutMem_2bankX1port_3b (
    .read_page_o   (read_page_u1),
    .read_word_o   (read_word_u1),
    .write_data_i  (write_data_u1),
    .access_addr_i (access_addr_u1),
    .read_strobe_i (read_strobe_u1),
    .we_i          (we_u1),
    .sys_clk       (sys_clk_u1)
);
//-----------------------------------
lutMem_1bankX1port #(
    .QUAN_SIZE(4),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutMem_1bankX1port_4b (
    .read_page_o   (read_page_u2),
    .write_data_i  (write_data_u2),
    .access_addr_i (access_addr_u2),
    .we_i          (we_u2),
    .sys_clk       (sys_clk_u2)
);
//-----------------------------------
lutMem_2bankX1port #(
    .QUAN_SIZE(4),
    .PAGE_NUM(16),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(4)
) lutMem_2bankX1port_4b (
    .read_page_o   (read_page_u3),
    .read_word_o   (read_word_u3),
    .write_data_i  (write_data_u3),
    .access_addr_i (access_addr_u3),
    .read_strobe_i (read_strobe_u3),
    .we_i          (we_u3),
    .sys_clk       (sys_clk_u3)
);

//---------------------------------------------
// Instantiation of pseudo/simple dual-port RAM
//---------------------------------------------
lutMem_1bank_sdp #(
    .QUAN_SIZE(3),
    .PAGE_NUM(16),
    .ADDR_BITWIDTH(4)
) lutMem_1bank_sdp_3b (
    .read_page_o   (read_page_u4),
    .write_data_i  (write_data_u4),
    .write_addr_i (write_addr_u4),
    .read_addr_i (read_addr_u4),
    .we_i          (we_u4),
    .write_clk       (write_clk_u4),
    .read_clk       (read_clk_u4)
);
//-----------------------------------
lutMem_2bank_sdp #(
    .QUAN_SIZE(3),
    .PAGE_NUM(8),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(3)
) lutMem_2bank_sdp_3b (
    .read_page_o   (read_page_u5),
    .read_word_o   (read_word_u5),
    .write_data_i  (write_data_u5),
    .write_addr_i (write_addr_u5),
    .read_addr_i (read_addr_u5),
    .read_strobe_i (read_strobe_u5),
    .we_i          (we_u5),
    .write_clk       (write_clk_u5),
    .read_clk       (read_clk_u5)
);
//-----------------------------------
lutMem_1bank_sdp #(
    .QUAN_SIZE(4),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutMem_1bank_sdp_4b (
    .read_page_o   (read_page_u6),
    .write_data_i  (write_data_u6),
    .write_addr_i (write_addr_u6),
    .read_addr_i (read_addr_u6),
    .we_i          (we_u6),
    .write_clk       (write_clk_u6),
    .read_clk       (read_clk_u6)
);
//-----------------------------------
lutMem_2bank_sdp #(
    .QUAN_SIZE(4),
    .PAGE_NUM(16),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(4)
) lutMem_2bank_sdp_4b (
    .read_page_o   (read_page_u7),
    .read_word_o   (read_word_u7),
    .write_data_i  (write_data_u7),
    .write_addr_i (write_addr_u7),
    .read_addr_i (read_addr_u7),
    .read_strobe_i (read_strobe_u7),
    .we_i          (we_u7),
    .write_clk       (write_clk_u7),
    .read_clk       (read_clk_u7)
);
endmodule
