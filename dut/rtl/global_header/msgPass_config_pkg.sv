package msgPass_config_pkg;

//-----------------------------------------------------------------------------------------------------
// Configuration of the message-passing buffer
//-----------------------------------------------------------------------------------------------------
localparam MSGPASS_BUFF_ADDR_WIDTH = 7; // tentative
localparam MSGPASS_BUFF_RDATA_WIDTH = 2*5; // tentatively fixed to the SCU.memShare()'s configuration
localparam MSGPASS_BUFF_DEPTH = 2**MSGPASS_BUFF_ADDR_WIDTH; // tentative
//-----------------------------------------------------------------------------------------------------
// Configuration of the module "msgPass_addr_gen"
//-----------------------------------------------------------------------------------------------------
localparam INCREMENT_SRC_NUM = 3;
localparam INCREMENT_SRC_SEL_WIDTH = $clog2(INCREMENT_SRC_NUM);
endpackage: msgPass_config_pkg
