module snn_axil (
    input M00_ACLK,
    input M00_ARESETN,

    //MAXIL Interface
    //Address write channel
    output wire [31:0]              M00_axi_awaddr,
    output wire [2:0]               M00_axi_awprot,
    output wire                     M00_axi_awvalid,
    input  wire                     M00_axi_awready,
    //Write channel
    output wire [31-1:0]            M00_axi_wdata,
    output wire [3:0]               M00_axi_wstrb,
    output wire                     M00_axi_wvalid,
    input  wire                     M00_axi_wready,
    //Write Response Channel
    input  wire [1:0]               M00_axi_bresp,
    input  wire                     M00_axi_bvalid,
    output wire                     M00_axi_bready,
    //Address Read channel
    output wire [31:0]              M00_axi_araddr,
    output wire [2:0]               M00_axi_arprot,
    output wire                     M00_axi_arvalid,
    input  wire                     M00_axi_rready,
    //Read channel
    input  wire [31:0]              M00_axi_rdata,
    input  wire [1:0]               M00_axi_rresp,
    input  wire                     M00_axi_rvalid,
    output wire                     M00_axi_rready
);

//Taken from Xilinx DS741
localparam RxFifoAddress_lp = 32'h0;  //Read Channels 
localparam TxFifoAddress_lp = 32'h4;  //Write Channels
localparam STAT_REG_Address_lp = 32'h8; //Read Chennels
localparam CTRL_REG_Address_lp = 32'hc; //Write Channels


endmodule
