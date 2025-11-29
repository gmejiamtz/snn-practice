module snn_axil (
    input m_axil_clk,
    input resetn_i,

    //MAXIL Interface
    //Address write channel
    output wire [31:0]              m_axil_awaddr,
    output wire [2:0]               m_axil_awprot,
    output wire                     m_axil_awvalid,
    input  wire                     m_axil_awready,
    //Write channel
    output wire [31-1:0]            m_axil_wdata,
    output wire [3:0]               m_axil_wstrb,
    output wire                     m_axil_wvalid,
    input  wire                     m_axil_wready,
    //Write Response Channel
    input  wire [1:0]               m_axil_bresp,
    input  wire                     m_axil_bvalid,
    output wire                     m_axil_bready,
    //Address Read channel
    output wire [31:0]              m_axil_araddr,
    output wire [2:0]               m_axil_arprot,
    output wire                     m_axil_arvalid,
    input  wire                     m_axil_arready,
    //Read channel
    input  wire [31:0]              m_axil_rdata,
    input  wire [1:0]               m_axil_rresp,
    input  wire                     m_axil_rvalid,
    output wire                     m_axil_rready
);

//Taken from Xilinx DS741
localparam RxFifoAddress_lp = 32'h0;  //Read Channels 
localparam TxFifoAddress_lp = 32'h4;  //Write Channels
localparam STAT_REG_Address_lp = 32'h8; //Read Chennels
localparam CTRL_REG_Address_lp = 32'hc; //Write Channels


endmodule