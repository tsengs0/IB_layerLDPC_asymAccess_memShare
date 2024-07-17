module ibLUT_c2v_symConv #(
    parameter MSG_WIDTH = 4
) (
    output logic [MSG_WIDTH-1:0] symConv_msg_o,
    input logic                 raw_v2c_sign_i, // source: channel message or itermediate V2C
    input logic [MSG_WIDTH-1:0] raw_c2v_msg_i
);

logic sign_conversion;
assign sign_conversion = raw_v2c_sign_i^raw_c2v_msg_i[MSG_WIDTH-1];
assign symConv_msg_o[MSG_WIDTH-1:0] = {sign_conversion, raw_c2v_msg_i[MSG_WIDTH-2:0]};
endmodule
