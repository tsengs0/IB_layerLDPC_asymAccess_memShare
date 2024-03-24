// Latency: 1 clock cycles
// Logic LUT: 5
// FF: 15 (Q=3)
// FF: 20 (Q=4)

// In Q=3,
//      Logic LUT approximately equal to W^{s},
//      FF = W^{s}*3.

// In Q=4,
//      Logic LUT approximately equal to W^{s},
//      FF = W^{s}*Q.
`include "memShare_config.vh"
//`define DECODER_3bit
//`define SOL_2
`define SOL_3

//==============================================================================================================
`ifdef SOL_2
module l2pa_logic #(
    parameter SHIFT_LENGTH = 5,
	parameter QUAN_SIZE = 3,
    parameter MAX_MEMSHARE_INSTANCES = 3 // maximum number of memShare allocation instances to complete
                                         // a set of W^{s} requestors' IB-RAM accesses
) (
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit2_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit1_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit0_o,
    `ifdef DECODER_4bit
        output wire [SHIFT_LENGTH-1:0] l2paOut_bit3_o,
    `endif

    input wire [SHIFT_LENGTH-1:0] l1paOut_bit2_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit1_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit0_i,
    `ifdef DECODER_4bit
        input wire [SHIFT_LENGTH-1:0] l1paOut_bit3_i,  
    `endif
    
    // Layer status control
    input wire isMsgPass_i, //! Current L2PA usage is for V2C/C2V permutation
    input wire [SHIFT_LENGTH-1:0] shiftROM_load_en_i, // load_en of bus combiner instructed by layer-shifting ROM
    input wire preV2CPerm_l2pa_rstn,

    input wire rstn,
    input wire sys_clk
);

//------------------------------------------------------------
// Zero detection
wire [SHIFT_LENGTH-1:0] isNonzero;
genvar share_element_id;
generate;
    for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_zeroDetector
        `ifdef DECODER_3bit
            assign isNonzero[share_element_id] = |{l1paOut_bit2_i[share_element_id], l1paOut_bit1_i[share_element_id], l1paOut_bit0_i[share_element_id]};
        `endif

        `ifdef DECODER_4bit
            assign isNonzero[share_element_id] = |{l1paOut_bit3_i[share_element_id], l1paOut_bit2_i[share_element_id], l1paOut_bit1_i[share_element_id], l1paOut_bit0_i[share_element_id]};
        `endif
    end
endgenerate
//------------------------------------------------------------
// Priority-based load-enable signal generator
wire [SHIFT_LENGTH-1:0] priority_load_en;
wire isMsgPass_neg; // negation of isMsgPass_i;
generate;
    for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_priorityLoadEn_gen
        assign priority_load_en[share_element_id] = (isNonzero[share_element_id] & isMsgPass_neg) | 
                                                    (shiftROM_load_en_i[share_element_id] & isMsgPass_i);
    end
endgenerate
assign isMsgPass_neg = ~isMsgPass_i;
//------------------------------------------------------------
// Reset circuit of bus combiner
wire [SHIFT_LENGTH-1:0] busCombRst_gp;
localparam IS_ZERO_FFNUM = MAX_MEMSHARE_INSTANCES-1;
generate;
for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_rstLogic
    wire isZero; 
    reg [IS_ZERO_FFNUM-1:0] isZero_pipeN;
    wire [MAX_MEMSHARE_INSTANCES-1:0] isZero_validity_vec; // nothing but just for ease of RTL coding of reduction AND operation
    wire isZero_validity;
    //=================================================================
    // Shift register for recording history
    if(IS_ZERO_FFNUM == 2) begin
    	always @(posedge sys_clk) begin 
            if(!preV2CPerm_l2pa_rstn)
                isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {IS_ZERO_FFNUM{1'b1}};
	    else
	        isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {isZero_pipeN[0], isZero};
        end
    end
    else begin
    	always @(posedge sys_clk) begin 
            if(!preV2CPerm_l2pa_rstn)
                isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {IS_ZERO_FFNUM{1'b1}};
	    else
	        isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {isZero_pipeN[IS_ZERO_FFNUM-2:0], isZero};
        end
    end
    //==========End of shift register===================================
    assign isZero = ~isNonzero[share_element_id];
    assign isZero_validity_vec[MAX_MEMSHARE_INSTANCES-1:0] = {isZero_pipeN[IS_ZERO_FFNUM-1:0], isZero};
    assign isZero_validity = &isZero_validity_vec[MAX_MEMSHARE_INSTANCES-1:0];

    // The rest signal (active HIGH) for bus combiner 
    assign busCombRst_gp[share_element_id] = ((isZero | ~rstn) & isZero_validity & ~shiftROM_load_en_i[share_element_id]);
end
endgenerate
//------------------------------------------------------------
// Bus combiner
data_bus_combiner #(
	.UNIT_NUM   (SHIFT_LENGTH), 
	.UNIT_WIDTH (QUAN_SIZE)
) l2pa (
`ifdef DECODER_4bit
	.port_out_o ({
					l2paOut_bit3_o[SHIFT_LENGTH-1:0],
					l2paOut_bit2_o[SHIFT_LENGTH-1:0],
					l2paOut_bit1_o[SHIFT_LENGTH-1:0],
					l2paOut_bit0_o[SHIFT_LENGTH-1:0]
				 }
	),
	.port_in_i ({
                    l1paOut_bit3_i[SHIFT_LENGTH-1:0],
					l1paOut_bit2_i[SHIFT_LENGTH-1:0],
					l1paOut_bit1_i[SHIFT_LENGTH-1:0],
					l1paOut_bit0_i[SHIFT_LENGTH-1:0]
				}
	),
`endif // DECODER_4bit
`ifdef DECODER_3bit
	.port_out_o ({
                    l2paOut_bit2_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit1_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit0_o[SHIFT_LENGTH-1:0]
				 }
	),
	.port_in_i ({
                    l1paOut_bit2_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit1_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit0_i[SHIFT_LENGTH-1:0]
				}
	),
`endif // DECODER_3bit
	.load_en_i (priority_load_en[SHIFT_LENGTH-1:0]),
	.sys_clk   (sys_clk),
	.rstn      (~busCombRst_gp[SHIFT_LENGTH-1:0])
);
endmodule
`endif // SOL_2
//==============================================================================================================
`ifdef SOL_3
module l2pa_logic #(
    parameter SHIFT_LENGTH = 5,
    parameter QUAN_SIZE = 3,
    parameter MAX_MEMSHARE_INSTANCES = 3 // maximum number of memShare allocation instances to complete
                                         // a set of W^{s} requestors' IB-RAM accesses
) (
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit2_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit1_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit0_o,
    `ifdef DECODER_4bit
        output wire [SHIFT_LENGTH-1:0] l2paOut_bit3_o,
    `endif

    input wire [SHIFT_LENGTH-1:0] l1paOut_bit2_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit1_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit0_i,
    `ifdef DECODER_4bit
        input wire [SHIFT_LENGTH-1:0] l1paOut_bit3_i,  
    `endif
    
    // Layer status control
    input wire is_preV2CPerm_i, //! Current L2PA usage is for preprocessing V2C permutation
    input wire [SHIFT_LENGTH-1:0] shiftROM_load_en_i, // load_en of bus combiner instructed by layer-shifting ROM
    input wire preV2CPerm_l2pa_rstn,

    input wire rstn,
    input wire sys_clk
);

//------------------------------------------------------------
// Zero detection
wire [SHIFT_LENGTH-1:0] isZero;
genvar share_element_id;
generate;
    for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_zeroDetector
        `ifdef DECODER_3bit
            assign isZero[share_element_id] = ~(|{l1paOut_bit2_i[share_element_id], l1paOut_bit1_i[share_element_id], l1paOut_bit0_i[share_element_id]});
        `endif

        `ifdef DECODER_4bit
            assign isZero[share_element_id] = ~(|{l1paOut_bit3_i[share_element_id], l1paOut_bit2_i[share_element_id], l1paOut_bit1_i[share_element_id], l1paOut_bit0_i[share_element_id]});
        `endif
    end
endgenerate
//------------------------------------------------------------
// Priority-based load-enable signal generator
wire [SHIFT_LENGTH-1:0] priority_load_en;
generate;
    for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_priorityLoadEn_gen
        assign priority_load_en[share_element_id] = (shiftROM_load_en_i[share_element_id] & ~is_preV2CPerm_i) | 
                                                    (~isZero[share_element_id] & is_preV2CPerm_i);
    end
endgenerate
//------------------------------------------------------------
// Reset circuit of bus combiner
wire [SHIFT_LENGTH-1:0] busCombRst_gp;
localparam IS_ZERO_FFNUM = MAX_MEMSHARE_INSTANCES-1;
generate;
for(share_element_id=0; share_element_id<SHIFT_LENGTH; share_element_id=share_element_id+1) begin: shareGroup_rstLogic
    reg [IS_ZERO_FFNUM-1:0] isZero_pipeN;
    wire [MAX_MEMSHARE_INSTANCES-1:0] isZero_validity_vec; // nothing but just for ease of RTL coding of reduction AND operation
    wire isZero_validity;
    //=================================================================
    // Shift register for recording history
    if(IS_ZERO_FFNUM == 2) begin
        always @(posedge sys_clk) begin 
            if(!preV2CPerm_l2pa_rstn)
                isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {IS_ZERO_FFNUM{1'b1}};
        else
            isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {isZero_pipeN[0], isZero[share_element_id]};
        end
    end
    else begin
        always @(posedge sys_clk) begin 
            if(!preV2CPerm_l2pa_rstn)
                isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {IS_ZERO_FFNUM{1'b1}};
        else
            isZero_pipeN[IS_ZERO_FFNUM-1:0] <= {isZero_pipeN[IS_ZERO_FFNUM-2:0], isZero[share_element_id]};
        end
    end
    //==========End of shift register===================================
    assign isZero_validity_vec[MAX_MEMSHARE_INSTANCES-1:0] = {isZero_pipeN[IS_ZERO_FFNUM-1:0], isZero[share_element_id]};
    assign isZero_validity = &isZero_validity_vec[MAX_MEMSHARE_INSTANCES-1:0];

    // The rest signal (active HIGH) for bus combiner 
    assign busCombRst_gp[share_element_id] = isZero_validity;
end
endgenerate
//------------------------------------------------------------
// Bus combiner
data_bus_combiner #(
    .UNIT_NUM   (SHIFT_LENGTH), 
    .UNIT_WIDTH (QUAN_SIZE)
) l2pa (
`ifdef DECODER_4bit
    .port_out_o ({
                    l2paOut_bit3_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit2_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit1_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit0_o[SHIFT_LENGTH-1:0]
                 }
    ),
    .port_in_i ({
                    l1paOut_bit3_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit2_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit1_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit0_i[SHIFT_LENGTH-1:0]
                }
    ),
`endif // DECODER_4bit
`ifdef DECODER_3bit
    .port_out_o ({
                    l2paOut_bit2_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit1_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit0_o[SHIFT_LENGTH-1:0]
                 }
    ),
    .port_in_i ({
                    l1paOut_bit2_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit1_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit0_i[SHIFT_LENGTH-1:0]
                }
    ),
`endif // DECODER_3bit
    .load_en_i (priority_load_en[SHIFT_LENGTH-1:0]),
    .sys_clk   (sys_clk),
    .rstn      (~busCombRst_gp[SHIFT_LENGTH-1:0])
);
endmodule
`endif // SOL_3
//==============================================================================================================

module l2pa_dummy #(
    parameter SHIFT_LENGTH = 5,
	parameter QUAN_SIZE = 3
) (
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit2_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit1_o,
    output wire [SHIFT_LENGTH-1:0] l2paOut_bit0_o,
    `ifdef DECODER_4bit
        output wire [SHIFT_LENGTH-1:0] l2paOut_bit3_o,
    `endif

    input wire [SHIFT_LENGTH-1:0] l1paOut_bit2_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit1_i,
    input wire [SHIFT_LENGTH-1:0] l1paOut_bit0_i,
    `ifdef DECODER_4bit
        input wire [SHIFT_LENGTH-1:0] l1paOut_bit3_i,  
    `endif
    
    // Layer status control
    input wire is_preV2CPerm_i, //! Current L2PA usage is for preprocessing V2C permutation
    input wire [SHIFT_LENGTH-1:0] shiftROM_load_en_i, // load_en of bus combiner instructed by layer-shifting ROM 

    input wire rstn,
    input wire sys_clk
);

//------------------------------------------------------------
// Zero detection
wire [SHIFT_LENGTH-1:0] dummy_load_en;
assign dummy_load_en[SHIFT_LENGTH-1:0] = {SHIFT_LENGTH{1'b1}};
data_bus_combiner #(
	.UNIT_NUM   (SHIFT_LENGTH), 
	.UNIT_WIDTH (QUAN_SIZE)
) l2pa (
`ifdef DECODER_4bit
	.port_out_o ({
					l2paOut_bit3_o[SHIFT_LENGTH-1:0],
					l2paOut_bit2_o[SHIFT_LENGTH-1:0],
					l2paOut_bit1_o[SHIFT_LENGTH-1:0],
					l2paOut_bit0_o[SHIFT_LENGTH-1:0]
				 }
	),
	.port_in_i ({
                    l1paOut_bit3_i[SHIFT_LENGTH-1:0],
					l1paOut_bit2_i[SHIFT_LENGTH-1:0],
					l1paOut_bit1_i[SHIFT_LENGTH-1:0],
					l1paOut_bit0_i[SHIFT_LENGTH-1:0]
				}
	),
`endif // DECODER_4bit
`ifdef DECODER_3bit
	.port_out_o ({
                    l2paOut_bit2_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit1_o[SHIFT_LENGTH-1:0],
                    l2paOut_bit0_o[SHIFT_LENGTH-1:0]
				 }
	),
	.port_in_i ({
                    l1paOut_bit2_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit1_i[SHIFT_LENGTH-1:0],
                    l1paOut_bit0_i[SHIFT_LENGTH-1:0]
				}
	),
`endif // DECODER_3bit
	.load_en_i (dummy_load_en[SHIFT_LENGTH-1:0]),
	.sys_clk   (sys_clk),
	.rstn      ({SHIFT_LENGTH{rstn}})
);
endmodule
