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

typedef enum logic [1:0] { ar_status_reg_wait, ar_status_reg_send, ar_rx_fifo_wait, ar_rx_fifo_send } ar_state_t;
typedef enum logic { aw_wait_for_slave, aw_slave_takes_awaddr } aw_state_t;
typedef enum logic [1:0] { w_wait_for_data, w_wait_for_slave, w_slave_takes_wdata } w_state_t;

ar_state_t ar_state_q, ar_state_d;
aw_state_t aw_state_q, aw_state_d;
w_state_t  w_state_q, w_state_d;

//bus declarations
logic [31:0] ar_addr_d,ar_addr_q;
logic [0:0] ar_valid_d, ar_valid_q;
logic [31:0] aw_addr_d,aw_addr_q;
logic [0:0] aw_valid_d, aw_valid_q;
logic [0:0] w_valid_d, w_valid_q;
logic [31:0] w_data_d, w_data_q;

/////////////////////////////////////////////////////////////////
// AW CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        aw_state_q <= aw_wait_for_slave;
    else
        aw_state_q <= aw_state_d;
end

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        aw_addr_q <= TxFifoAddress_lp;
    else
        aw_addr_q <= aw_addr_d;
end

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        aw_valid_q <= 1'b1;
    else
        aw_valid_q <= aw_valid_d;
end

always_comb begin
    M00_axi_awprot  = 3'b000;
    aw_addr_d = aw_addr_q;
    aw_valid_d = aw_valid_q;
    aw_state_d = aw_state_q;

    case(aw_state_q)
        aw_wait_for_slave:
            begin
                aw_addr_d = TxFifoAddress_lp;
                aw_valid_d = 1'b1;
                if(M00_axi_awready)
                    aw_state_d = aw_slave_takes_awaddr;
            end
        aw_slave_takes_awaddr: begin
            aw_valid_d = 1'b0;
            aw_addr_d = TxFifoAddress_lp;
            aw_state_d = aw_wait_for_slave;
        end
    endcase
end

assign M00_axi_awaddr = aw_addr_q;
assign M00_axi_awvalid = aw_valid_q;

/////////////////////////////////////////////////////////////////
// W CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        w_state_q <= w_wait_for_data;
    else
        w_state_q <= w_state_d;
end

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        w_data_q <= 'b0;
    else
        w_data_q <= w_data_d;
end

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        w_valid_q <= 1'b0;
    else
        w_valid_q <= w_valid_d;
end

always_comb begin
    M00_axi_wstrb = 4'hF;
    w_state_d = w_state_q;
    w_valid_d = w_valid_q;
    w_data_d = w_data_q;
    case(w_state_q)
        w_wait_for_data:
            begin
                w_data_d = 'b0;
                w_valid_d = 1'b0;
                //AR has read from Rx Fifo and got something
                if(M00_axi_rvalid & M00_axi_rready & (ar_state_q == ar_rx_fifo_send))
                    w_state_d = w_wait_for_slave;
                    w_data_d = M00_axi_rdata;
            end
        w_wait_for_slave: begin
            w_valid_d = 1'b1;
            if(M00_axi_wready) begin
                w_valid_d = 1'b0;
                w_state_d = w_slave_takes_wdata;
            end
        end
        w_slave_takes_wdata:
            begin
                w_valid_d = 1'b0;
                w_data_d = 'b0;
                if(!M00_axi_rvalid)
                    w_state_d = w_wait_for_data;
                else
                    w_state_d = w_wait_for_slave;
                    w_data_d = M00_axi_rdata;
            end
        default: w_state_d = w_state_q;
    endcase
end

assign M00_axi_wdata = w_data_q;
assign M00_axi_wvalid = w_valid_q;

/////////////////////////////////////////////////////////////////
// B CHANNEL
/////////////////////////////////////////////////////////////////
assign M00_axi_bready = 1'b1;

/////////////////////////////////////////////////////////////////
// AR CHANNEL
/////////////////////////////////////////////////////////////////
always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        ar_state_q <= ar_status_reg_wait;
    else
        ar_state_q <= ar_state_d;
end

always_ff @(posedge M00_ACLK) begin
    if(~M00_ARESETN) begin
        ar_addr_q <= STAT_REG_Address_lp;
    end else begin
        ar_addr_q <= ar_addr_d;
    end
end

always_ff @(posedge M00_ACLK) begin
    if(~M00_ARESETN) begin
        ar_valid_q <= 1'b1;
    end else begin
        ar_valid_q <= ar_valid_d;
    end
end

always_comb begin
    M00_axi_arprot  = 3'b000;
    ar_state_d = ar_state_q;
    ar_addr_d = ar_addr_q;
    ar_valid_d = ar_valid_q;
    case(ar_state_q)
        ar_status_reg_wait:
            begin
                ar_valid_d = 1'b1;
                ar_addr_d = STAT_REG_Address_lp;
                if(M00_axi_arready)
                    ar_state_d = ar_status_reg_send;
                else
                    ar_state_d = ar_status_reg_wait;
            end
        ar_status_reg_send:
            begin
                ar_valid_d = 1'b0;
                ar_addr_d = STAT_REG_Address_lp;
                //if rdata[0] is high then rx fifo has something
                if(M00_axi_rvalid & M00_axi_rdata[0]) begin
                    ar_state_d = ar_rx_fifo_wait;
                //else if rdata[0] is low go back and reassert arvalid with stat reg addr
                end else if (~M00_axi_rdata[0] & M00_axi_rvalid) begin
                    ar_state_d = ar_status_reg_wait;
                //else wait on rvalid by not sending a new addr
                end else begin
                    ar_state_d = ar_status_reg_send;
                end
            end
        ar_rx_fifo_wait:
            begin
                ar_addr_d = RxFifoAddress_lp;
                ar_valid_d = 1'b1;
                if(M00_axi_arready) begin
                    ar_state_d = ar_rx_fifo_send;
                end else begin
                    ar_state_d = ar_rx_fifo_wait;
                end
            end
        ar_rx_fifo_send:
            begin
                ar_addr_d = RxFifoAddress_lp;
                ar_valid_d = 1'b0;
                //if rvalid is gotten then go back and read status reg again
                if(M00_axi_rvalid) begin
                    ar_state_d = ar_status_reg_wait;
                end else begin
                    ar_state_d = ar_rx_fifo_send;
                end
            end
    endcase
end

assign M00_axi_araddr = ar_addr_q;
assign M00_axi_arvalid = ar_valid_q;

/////////////////////////////////////////////////////////////////
// R CHANNEL
/////////////////////////////////////////////////////////////////
assign M00_axi_rready = 1'b1;

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN)
        rx_data_r <= 32'h00;
    else if(M00_axi_rvalid & M00_axi_rready)
        rx_data_r <= {24'h0, M00_axi_rdata[7:0]};
end

endmodule
