module snn_axil (
    // Clock
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ACLK, ASSOCIATED_BUSIF M00_AXI, ASSOCIATED_RESET M00_AXI_ARESETN" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M00_AXI_ACLK CLK" *)
    input  wire M00_ACLK,

    // Reset (active-low)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ARESETN, POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M00_AXI_ARESETN RST" *)
    input  wire M00_ARESETN,

    //========================================================
    // AXI4-Lite Master Interface (M00_AXI)
    //========================================================

    // AW Channel
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWADDR" *)
    output logic [31:0] M00_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWPROT" *)
    output logic [2:0]  M00_axi_awprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWVALID" *)
    output logic        M00_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWREADY" *)
    input  wire         M00_axi_awready,

    // W Channel
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WDATA" *)
    output logic [31:0] M00_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WSTRB" *)
    output logic [3:0]  M00_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WVALID" *)
    output logic        M00_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WREADY" *)
    input  wire         M00_axi_wready,

    // B Channel
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BRESP" *)
    input  wire [1:0]   M00_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BVALID" *)
    input  wire         M00_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BREADY" *)
    output logic        M00_axi_bready,

    // AR Channel
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARADDR" *)
    output logic [31:0] M00_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARPROT" *)
    output logic [2:0]  M00_axi_arprot,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARVALID" *)
    output logic        M00_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARREADY" *)
    input  wire         M00_axi_arready,

    // R Channel
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RDATA" *)
    input  wire [31:0]  M00_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RRESP" *)
    input  wire [1:0]   M00_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RVALID" *)
    input  wire         M00_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RREADY" *)
    output logic        M00_axi_rready
);

/////////////////////////////////////////////////////////////////
// Local parameters for UART Lite registers
/////////////////////////////////////////////////////////////////
localparam logic [31:0] RxFifoAddress_lp  = 32'h0;
localparam logic [31:0] TxFifoAddress_lp  = 32'h4;
localparam logic [31:0] STAT_REG_Address_lp = 32'h8;
localparam logic [31:0] CTRL_REG_Address_lp = 32'hC;

/////////////////////////////////////////////////////////////////
// Internal registers and state machines
/////////////////////////////////////////////////////////////////
reg  [7:0]  rx_data_r;
reg         ar_transaction_done_r;

typedef enum logic { ar_wait_for_slave, ar_slave_takes_araddr } ar_state_t;
typedef enum logic { aw_wait_for_slave, aw_slave_takes_awaddr } aw_state_t;
typedef enum logic [1:0] { w_wait_for_data, w_wait_for_slave, w_slave_takes_wdata } w_state_t;

ar_state_t ar_state_q, ar_state_d;
aw_state_t aw_state_q, aw_state_d;
w_state_t  w_state_q, w_state_d;

/////////////////////////////////////////////////////////////////
// AW CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        aw_state_q <= aw_wait_for_slave;
    else
        aw_state_q <= aw_state_d;
end

always_comb begin
    M00_axi_awaddr  = TxFifoAddress_lp;
    M00_axi_awprot  = 3'b000;
    M00_axi_awvalid = 1'b1;

    aw_state_d = aw_state_q;

    case(aw_state_q)
        aw_wait_for_slave:
            if(M00_axi_awready)
                aw_state_d = aw_slave_takes_awaddr;

        aw_slave_takes_awaddr: begin
            M00_axi_awvalid = 1'b0;
            aw_state_d = aw_wait_for_slave;
        end
    endcase
end

/////////////////////////////////////////////////////////////////
// W CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        w_state_q <= w_wait_for_data;
    else
        w_state_q <= w_state_d;
end

always_comb begin
    M00_axi_wstrb = 4'hF;
    M00_axi_wdata = {24'b0, rx_data_r};

    w_state_d = w_state_q;
    M00_axi_wvalid = 1'b0;

    case(w_state_q)
        w_wait_for_data:
            if(M00_axi_rvalid)
                w_state_d = w_wait_for_slave;

        w_wait_for_slave: begin
            M00_axi_wvalid = 1'b1;
            if(M00_axi_wready) begin
                M00_axi_wvalid = 1'b0;
                w_state_d = w_slave_takes_wdata;
            end
        end

        w_slave_takes_wdata:
            if(!M00_axi_rvalid)
                w_state_d = w_wait_for_data;
            else
                w_state_d = w_wait_for_slave;
        default: w_state_d = w_state_q;
    endcase
end

/////////////////////////////////////////////////////////////////
// B CHANNEL
/////////////////////////////////////////////////////////////////
assign M00_axi_bready = 1'b1;

/////////////////////////////////////////////////////////////////
// AR CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        ar_state_q <= ar_wait_for_slave;
    else
        ar_state_q <= ar_state_d;
end

always_comb begin
    M00_axi_araddr  = RxFifoAddress_lp;
    M00_axi_arprot  = 3'b000;
    M00_axi_arvalid = 1'b1;

    ar_state_d = ar_state_q;

    case(ar_state_q)
        ar_wait_for_slave:
            if(M00_axi_arready)
                ar_state_d = ar_slave_takes_araddr;

        ar_slave_takes_araddr: begin
            M00_axi_arvalid = 1'b0;
            ar_state_d = ar_wait_for_slave;
        end
    endcase
end

/////////////////////////////////////////////////////////////////
// R CHANNEL
/////////////////////////////////////////////////////////////////
assign M00_axi_rready = 1'b1;

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        rx_data_r <= 8'h00;
    else if(M00_axi_rvalid)
        rx_data_r <= M00_axi_rdata[7:0];
end

endmodule
