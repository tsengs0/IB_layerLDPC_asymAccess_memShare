/*
Created date: 26 May, 2022
Developer: Bo-Yu Tseng
Email: tsengs0@gamil.com
Module name: data_bus_combiner

# I/F
1) Output:
2) Input:

# Param

# Description:

# Pipeline capability: yes
# Pipeline stage: 1
*/
module data_bus_combiner #(
	parameter UNIT_NUM = 5,
	parameter UNIT_WIDTH = 4
) (
	output wire [(UNIT_NUM*UNIT_WIDTH)-1:0] port_out_o,

	input wire [(UNIT_NUM*UNIT_WIDTH)-1:0] port_in_i,
	input wire [UNIT_NUM-1:0] load_en_i,
	input wire sys_clk,
	input wire [UNIT_NUM-1:0] rstn
);

reg [UNIT_WIDTH-1:0] data_latch [0:UNIT_NUM-1];
generate
	genvar i;
	for(i=0; i<UNIT_NUM; i=i+1) begin : dataLatchCtrl_inst
		initial data_latch[i] <= 0;
		always @(posedge sys_clk) begin
			if(rstn[i] == 1'b0) data_latch[i] <= 0;
			else if(load_en_i[i] == 1'b1) data_latch[i] <= port_in_i[(i+1)*UNIT_WIDTH-1:i*UNIT_WIDTH];
		end

		assign port_out_o[(i+1)*UNIT_WIDTH-1:i*UNIT_WIDTH] = data_latch[i];
	end
endgenerate
endmodule
