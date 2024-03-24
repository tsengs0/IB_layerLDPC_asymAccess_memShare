/**
* Latest date: 25th March, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_mmu
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
    This module is a Memory-Mapping Unit (MMU) for tranlation of request flags into a regFile read address.

* # Dependencies
* 	None
*
* # Remark
*	3 bits:
*		LUT: 
*		FF: 
*
*	4 bits:
*		LUT:
*		FF:
**/
module memShare_mmu #(
    parameter MODE_BITWIDTH = 2, //! Bit width of "mode set signals"
    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
    parameter TYPE0_ADDR_BITWIDTH = MODE_BITWIDTH+SHARED_BANK_NUM//! page number: 127
) (
    output wire [TYPE0_ADDR_BITWIDTH-1:0] raddr_o,
    input wire [MODE_BITWIDTH-1:0] isEnd_feedback_i,
    input wire [MODE_BITWIDTH-1:0] modeSet_i, // clamped to macro END_CODE
    input wire [SHARED_BANK_NUM-1:0] share_rqstFlag_i,

    input wire cen,
    input wire sys_clk,
    input wire rstn
);

//--------------------------------------
// Local end flag tracking L1PA progress
//--------------------------------------
reg [MODE_BITWIDTH-1:0] l1pa_progress; initial l1pa_progress <= 0;
wire isEnd;
always @(posedge sys_clk) begin
    if(rstn == 1'b1)
        l1pa_progress <= 0;
    else if(cen == 1'b1) begin
        if(isEnd == 1'b1)
            l1pa_progress <= 0;
        else
            l1pa-progress <= l1pa_progress+1;
    end
end
assign isEnd = &(isEnd_feedback_i[MODE_BITWIDTH-1:0] & modeSet_i[MODE_BITWIDTH-1:0]);
//--------------------------------------
// Update of regFile read address
//--------------------------------------
assign raddr_o[TYPE0_ADDR_BITWIDTH-1:0] = {l1pa_progress[MODE_BITWIDTH-1:0], share_rqstFlag_i[SHARED_BANK_NUM-1:0]};
endmodule
// /*Address: 6'd0 */5'b00000: read_addr = {1'd1, 6'd0}; // 
// /*Address: 6'd1 */5'b10000: read_addr = {1'd1, 6'd4}; // 
// /*Address: 6'd2 */5'b01000: read_addr = {1'd1, 6'd3}; // 
// /*Address: 6'd3 */5'b00100: read_addr = {1'd1, 6'd2}; // 
// /*Address: 6'd4 */5'b00010: read_addr = {1'd1, 6'd4}; // 
// /*Address: 6'd5 */5'b00001: read_addr = {1'd1, 6'd3}; // 
// /*Address: 6'd6 */5'b11000: read_addr = {1'd0, 6'd1}; //
// /*Address: 6'd7 */5'b11000: read_addr = {1'd1, 6'd2};
// /*Address: 6'd8 */5'b10100: read_addr = {1'd1, 6'd2};//
// /*Address: 6'd9 */5'b10010: read_addr = {1'd1, 6'd4};//
// /*Address: 6'd10*/5'b10001: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd11*/5'b10001: read_addr = {1'd1, 6'd2};
// /*Address: 6'd12*/5'b01100: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd13*/5'b01100: read_addr = {1'd1, 6'd1};
// /*Address: 6'd14*/5'b01010: read_addr = {1'd1, 6'd1};//
// /*Address: 6'd15*/5'b01001: read_addr = {1'd1, 6'd3};//
// /*Address: 6'd16*/5'b00110: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd17*/5'b00110: read_addr = {1'd1, 6'd1};
// /*Address: 6'd18*/5'b00101: read_addr = {1'd1, 6'd0};//
// /*Address: 6'd19*/5'b00011: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd20*/5'b00011: read_addr = {1'd1, 6'd1};
// /*Address: 6'd21*/5'b11100: read_addr = {1'd0, 6'd1};//
// /*Address: 6'd22*/5'b11100: read_addr = {1'd1, 6'd2};
// /*Address: 6'd23*/5'b11010: read_addr = {1'd0, 6'd1};//
// /*Address: 6'd24*/5'b11010: read_addr = {1'd1, 6'd2};
// /*Address: 6'd25*/5'b11001: read_addr = {1'd0, 6'd2};//
// /*Address: 6'd26*/5'b11001: read_addr = {1'd1, 6'd3};
// /*Address: 6'd27*/5'b10110: read_addr = {1'd0, 6'd1};//
// /*Address: 6'd28*/5'b10110: read_addr = {1'd1, 6'd2};
// /*Address: 6'd29*/5'b10101: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd30*/5'b10101: read_addr = {1'd1, 6'd2};
// /*Address: 6'd31*/5'b10011: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd32*/5'b10011: read_addr = {1'd1, 6'd4};
// /*Address: 6'd33*/5'b01110: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd34*/5'b01110: read_addr = {1'd1, 6'd1};
// /*Address: 6'd35*/5'b01101: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd36*/5'b01101: read_addr = {1'd1, 6'd1};
// /*Address: 6'd37*/5'b01011: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd38*/5'b01011: read_addr = {1'd1, 6'd1};
// /*Address: 6'd39*/5'b00111: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd40*/5'b00111: read_addr = {1'd1, 6'd1};
// /*Address: 6'd41*/5'b11110: read_addr = {1'd0, 6'd1};//
// /*Address: 6'd42*/5'b11110: read_addr = {1'd1, 6'd2};
// /*Address: 6'd43*/5'b11101: read_addr = {1'd0, 6'd2};//
// /*Address: 6'd44*/5'b11101: read_addr = {1'd1, 6'd3};
// /*Address: 6'd45*/5'b11011: read_addr = {1'd0, 6'd3};//
// /*Address: 6'd46*/5'b11011: read_addr = {1'd1, 6'd4};
// /*Address: 6'd47*/5'b10111: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd48*/5'b10111: read_addr = {1'd1, 6'd4};
// /*Address: 6'd49*/5'b01111: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd50*/5'b01111: read_addr = {1'd1, 6'd1};
// /*Address: 6'd51*/5'b11111: read_addr = {1'd0, 6'd0};//
// /*Address: 6'd52*/5'b11111: read_addr = {1'd0, 6'd1};
// /*Address: 6'd53*/5'b11111: read_addr = {1'd1, 6'd2};

/*
Base addresses:
            5'b00000: read_addr = 6'd0 ; // 
            5'b10000: read_addr = 6'd1 ; // 
            5'b01000: read_addr = 6'd2 ; // 
            5'b00100: read_addr = 6'd3 ; // 
            5'b00010: read_addr = 6'd4 ; // 
            5'b00001: read_addr = 6'd5 ; // 
            5'b11000: read_addr = 6'd6 ; //
            5'b10100: read_addr = 6'd8 ;//
            5'b10010: read_addr = 6'd9 ;//
            5'b10001: read_addr = 6'd10;//
            5'b01100: read_addr = 6'd12;//
            5'b01010: read_addr = 6'd14;//
            5'b01001: read_addr = 6'd15;//
            5'b00110: read_addr = 6'd16;//
            5'b00101: read_addr = 6'd18;//
            5'b00011: read_addr = 6'd19;//
            5'b11100: read_addr = 6'd21;//
            5'b11010: read_addr = 6'd23;//
            5'b11001: read_addr = 6'd25;//
            5'b10110: read_addr = 6'd27;//
            5'b10101: read_addr = 6'd29;//
            5'b10011: read_addr = 6'd31;//
            5'b01110: read_addr = 6'd33;//
            5'b01101: read_addr = 6'd35;//
            5'b01011: read_addr = 6'd37;//
            5'b00111: read_addr = 6'd39;//
            5'b11110: read_addr = 6'd41;//
            5'b11101: read_addr = 6'd43;//
            5'b11011: read_addr = 6'd45;//
            5'b10111: read_addr = 6'd47;//
            5'b01111: read_addr = 6'd49;//
            5'b11111: read_addr = 6'd51;//
*/

/*
All addresses:
            5'b00000: read_addr = 6'd0 ; // 
            5'b10000: read_addr = 6'd1 ; // 
            5'b01000: read_addr = 6'd2 ; // 
            5'b00100: read_addr = 6'd3 ; // 
            5'b00010: read_addr = 6'd4 ; // 
            5'b00001: read_addr = 6'd5 ; // 
            5'b11000: read_addr = 6'd6 ; //
            5'b11000: read_addr = 6'd7 ;
            5'b10100: read_addr = 6'd8 ;//
            5'b10010: read_addr = 6'd9 ;//
            5'b10001: read_addr = 6'd10;//
            5'b10001: read_addr = 6'd11;
            5'b01100: read_addr = 6'd12;//
            5'b01100: read_addr = 6'd13;
            5'b01010: read_addr = 6'd14;//
            5'b01001: read_addr = 6'd15;//
            5'b00110: read_addr = 6'd16;//
            5'b00110: read_addr = 6'd17;
            5'b00101: read_addr = 6'd18;//
            5'b00011: read_addr = 6'd19;//
            5'b00011: read_addr = 6'd20;
            5'b11100: read_addr = 6'd21;//
            5'b11100: read_addr = 6'd22;
            5'b11010: read_addr = 6'd23;//
            5'b11010: read_addr = 6'd24;
            5'b11001: read_addr = 6'd25;//
            5'b11001: read_addr = 6'd26;
            5'b10110: read_addr = 6'd27;//
            5'b10110: read_addr = 6'd28;
            5'b10101: read_addr = 6'd29;//
            5'b10101: read_addr = 6'd30;
            5'b10011: read_addr = 6'd31;//
            5'b10011: read_addr = 6'd32;
            5'b01110: read_addr = 6'd33;//
            5'b01110: read_addr = 6'd34;
            5'b01101: read_addr = 6'd35;//
            5'b01101: read_addr = 6'd36;
            5'b01011: read_addr = 6'd37;//
            5'b01011: read_addr = 6'd38;
            5'b00111: read_addr = 6'd39;//
            5'b00111: read_addr = 6'd40;
            5'b11110: read_addr = 6'd41;//
            5'b11110: read_addr = 6'd42;
            5'b11101: read_addr = 6'd43;//
            5'b11101: read_addr = 6'd44;
            5'b11011: read_addr = 6'd45;//
            5'b11011: read_addr = 6'd46;
            5'b10111: read_addr = 6'd47;//
            5'b10111: read_addr = 6'd48;
            5'b01111: read_addr = 6'd49;//
            5'b01111: read_addr = 6'd50;
            5'b11111: read_addr = 6'd51;//
            5'b11111: read_addr = 6'd52;
            5'b11111: read_addr = 6'd53;
*/











































































































