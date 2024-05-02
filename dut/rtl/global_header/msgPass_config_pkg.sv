package msgPass_config_pkg;

//-----------------------------------------------------------------------------------------------------
// Configuration of the message-passing buffer
//-----------------------------------------------------------------------------------------------------
localparam MSGPASS_BUFF_ADDR_WIDTH = 7; // tentative
localparam MSGPASS_BUFF_RDATA_WIDTH = 2*5; // tentatively fixed to the SCU.memShare()'s configuration
endpackage: msgPass_config_pkg
