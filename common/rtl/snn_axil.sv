module snn_axil (
    input M00_ACLK,
    input M00_ARESETN,

    //MAXIL Interface
    //Address write channel
    output logic [31:0]              M00_axi_awaddr,
    output logic [2:0]               M00_axi_awprot,
    output logic                     M00_axi_awvalid,
    input  wire                     M00_axi_awready,
    //Write channel
    output logic [31:0]             M00_axi_wdata,
    output logic [3:0]              M00_axi_wstrb,
    output logic                    M00_axi_wvalid,
    input  wire                    M00_axi_wready,
    //Write Response Channel
    input  wire [1:0]              M00_axi_bresp,
    input  wire                    M00_axi_bvalid,
    output logic                    M00_axi_bready,
    //Address Read channel
    output logic [31:0]             M00_axi_araddr,
    output logic [2:0]              M00_axi_arprot,
    output logic                    M00_axi_arvalid,
    input  wire                    M00_axi_arready,
    //Read channel
    input  wire [31:0]             M00_axi_rdata,
    input  wire [1:0]              M00_axi_rresp,
    input  wire                    M00_axi_rvalid,
    output logic                    M00_axi_rready
);

//Taken from Xilinx DS741
localparam RxFifoAddress_lp = 32'h0;  //Read Channels 
localparam TxFifoAddress_lp = 32'h4;  //Write Channels
localparam STAT_REG_Address_lp = 32'h8; //Read Chennels
localparam CTRL_REG_Address_lp = 32'hc; //Write Channels

//Bus Declarations
reg [7:0] rx_data_r;
reg ar_transaction_done_r;


//AW Channel - Write to TX Fifo

//set high when SNN needs to transmit - hardcoded high for now

reg [0:0] write_to_fifo_r = 1;

always_comb begin
    //write_to_fifo_r = 1'b1;
    M00_axi_awaddr = TxFifoAddress_lp;
    M00_axi_awprot = 4'b0;
end

always_ff @(posedge M00_ACLK) begin
    if (M00_ARESETN == 0) begin
        M00_axi_awvalid <= 1'b0;
    end else begin
        if(write_to_fifo_r) begin 
            M00_axi_awvalid <= 1'b1;
        end
        if(M00_axi_awready & M00_axi_awvalid) begin
            M00_axi_awvalid <= 1'b0;
        end
    end
end

//W Channel - Data to send

//set high when SNN needs to transmit - hardcoded high for now

always_comb begin
    M00_axi_wdata = {24'b0,8'h67};
end

always_ff @(posedge M00_ACLK) begin
    if (M00_ARESETN == 0) begin
        M00_axi_wvalid <= 1'b0;
    end else begin
        if(write_to_fifo_r) begin 
            M00_axi_wvalid <= 1'b1;
        end
        if(M00_axi_awready & M00_axi_awvalid) begin
            M00_axi_wvalid <= 1'b0;
        end
    end
end

//Write Response Channel - Verify Write Status

always_comb begin
    M00_axi_bready = 1'b1;
end

//AR Channel - Read from RX Fifo

//set high when SNN needs to read - hardcoded high for now

reg [0:0] read_from_fifo_r = 1;

always_comb begin
    //read_from_fifo_r = 1'b1;
    M00_axi_araddr = RxFifoAddress_lp;
    M00_axi_arprot = 4'b0;
    M00_axi_wstrb = 4'b1;
end

always_ff @(posedge M00_ACLK) begin
    if (M00_ARESETN == 0) begin
        M00_axi_arvalid <= 1'b0;
        ar_transaction_done_r <= 1'b0;
    end else begin
        if(read_from_fifo_r) begin 
            M00_axi_arvalid <= 1'b1;
            ar_transaction_done_r <= 1'b0;
    end else begin
        end
        if(M00_axi_arready & M00_axi_arvalid) begin
            M00_axi_arvalid <= 1'b0;
            ar_transaction_done_r <= 1'b1;
        end
    end
end

//R Channel - Data from Rx

always_comb begin
    M00_axi_rready = 1'b1;
end

endmodule
