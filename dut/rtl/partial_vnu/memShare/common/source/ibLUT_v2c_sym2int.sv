module ibLUT_v2c_sym2int #(
    parameter MSG_WIDTH = 4
) (
    output logic [MSG_WIDTH-1:0] sym2int_msg_o,
    input logic raw_v2c_sign_i, // source: channel message or itermediate V2C
    input logic [MSG_WIDTH-1:0] map_v2c_i // IB-LUT mapping result as itermediate V2C or V2c @ last decpomsition level
);

logic sym2int_sign;
assign sym2int_sign = (!raw_v2c_sign_i) ? ~map_v2c_i[MSG_WIDTH-1] : map_v2c_i[MSG_WIDTH-1];
assign sym2int_msg_o[MSG_WIDTH-1:0] = {sym2int_sign, map_v2c_i[MSG_WIDTH-2:0]};
endmodule
