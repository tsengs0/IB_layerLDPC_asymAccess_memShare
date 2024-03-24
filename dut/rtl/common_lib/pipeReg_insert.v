// Latest date: 3rd August, 2023
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Module name: pipeReg_insert
// 
// # I/F
//  a) Output:
//  b) Input:
// 
// # Param
// 
// # Description
//      To pipeline a designated signals such that their timing can be synchrounised 
//      to the underlying pipeline architecture
// # Dependencies
// 	None
module pipeReg_insert #(
    parameter BITWIDTH = 3, //! Bitwidth of the designated signals
    parameter PIPELINE_STAGE = 5, //! Number of the pipeline stages
    parameter AGGREGATE_WIDTH = PIPELINE_STAGE*BITWIDTH
) (
    output wire [BITWIDTH-1:0] pipe_reg_o,
    output wire [AGGREGATE_WIDTH-1:0] stage_probe_o,

    input wire [BITWIDTH-1:0] sig_net_i,
    input wire [PIPELINE_STAGE-1:0] pipeLoad_en_i,
    input wire sys_clk,
    input wire rstn
);

reg [BITWIDTH-1:0] pipe_reg [0:PIPELINE_STAGE-1];
genvar stage;
generate
for(stage=0; stage<PIPELINE_STAGE; stage=stage+1) begin: pipelineStage
    if(stage == 0) begin
        always @(posedge sys_clk) begin
            if(!rstn) pipe_reg[0] <= 0;
            else if(pipeLoad_en_i[0] == 1'b1) pipe_reg[0] <= sig_net_i;
            else pipe_reg[0] <= pipe_reg[0];
        end
    end
    else begin
        always @(posedge sys_clk) begin
            if(!rstn) pipe_reg[stage] <= 0;
            else if(pipeLoad_en_i[stage] == 1'b1) pipe_reg[stage] <= pipe_reg[stage-1];
            else pipe_reg[stage] <= pipe_reg[stage];
        end
    end

    assign stage_probe_o[(stage+1)*BITWIDTH-1:stage*BITWIDTH] = pipe_reg[stage];
end
endgenerate
assign pipe_reg_o[BITWIDTH-1:0] = pipe_reg[PIPELINE_STAGE-1];
endmodule