module snn_axil #(
    parameter integer weight_hidden_p = 6,
    parameter integer weight_output_p = 32,
    //has -1.0, -0.5, 0.0, 0.25, 0.5, 1.0
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_10_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_11_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_12_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_13_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_14_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_15_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_16_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_17_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_18_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_19_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_20_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_21_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_22_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_23_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_24_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_25_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_26_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_27_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_28_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_29_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_30_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_31_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_32_p = "../util/test.hex",
    //output neuron hexfiles
    parameter string weights_output_neuron_1_p = "../util/test1.hex",
    parameter string weights_output_neuron_2_p = "../util/test1.hex",
    parameter string weights_output_neuron_3_p = "../util/test1.hex"
) (
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
logic  [31:0]  rx_data_r;
logic ar_transaction_done_r, rx_got_data_d, rx_got_data_q;

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
    M00_axi_wstrb = 4'h1;
    w_state_d = w_state_q;
    w_valid_d = w_valid_q;
    w_data_d = w_data_q;
    case(w_state_q)
        w_wait_for_data:
            begin
                w_data_d = 'b0;
                w_valid_d = 1'b0;
                //AR has read from Rx Fifo and got something
                if(M00_axi_rvalid & M00_axi_rready & (ar_state_q == ar_rx_fifo_send)) begin
                    w_state_d = w_wait_for_slave;
                end
            end
        w_wait_for_slave: begin
            w_valid_d = 1'b1;
            w_data_d = rx_data_r;
            if(M00_axi_wready & M00_axi_wready) begin
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
                else begin
                    w_state_d = w_wait_for_slave;
                    w_data_d = rx_data_r;
                end
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
        //AR reads from the Status Register
        ar_status_reg_wait:
            begin
                ar_valid_d = 1'b1;
                ar_addr_d = STAT_REG_Address_lp;
                //When status is ready send it
                if(M00_axi_arready & M00_axi_arvalid) begin
                    ar_state_d = ar_status_reg_send;
                    ar_valid_d = 1'b0;
                end
                else begin
                    ar_state_d = ar_status_reg_wait;
                end
            end
        ar_status_reg_send:
            begin
                //AR has sent a valid Stat Reg address and waits to read RxFifo
                ar_valid_d = 1'b0;
                ar_addr_d = STAT_REG_Address_lp;
                //if rdata[0] is high then rx fifo has something
                if(M00_axi_rvalid & M00_axi_rdata[0]) begin
                    ar_state_d = ar_rx_fifo_wait;
                //else if rdata[0] is low go back and reassert arvalid with stat reg addr
                end else if (~M00_axi_rdata[0] & M00_axi_rvalid & M00_axi_rready) begin
                    ar_state_d = ar_status_reg_wait;
                //else wait on rvalid by not sending a new addr
                end else begin
                    ar_state_d = ar_status_reg_send;
                end
            end
        ar_rx_fifo_wait:
            begin
                //AR has sent a valid RxFifo address and waits for a response
                ar_addr_d = RxFifoAddress_lp;
                ar_valid_d = 1'b1;
                //If RxFifo is ready send the Rxfifo address
                if(M00_axi_arready & M00_axi_arvalid) begin
                    ar_state_d = ar_rx_fifo_send;
                    ar_valid_d = 1'b0;
                end else begin
                    //else wait
                    ar_state_d = ar_rx_fifo_wait;
                end
            end
        ar_rx_fifo_send:
            begin
                //rdata in this state should be rx data
                ar_addr_d = RxFifoAddress_lp;
                ar_valid_d = 1'b0;
                //if rvalid is gotten then go back and read status reg again to see rxfifo status
                if(M00_axi_rvalid & M00_axi_rready) begin
                    ar_state_d = ar_status_reg_wait;
                end else begin
                    //else stay
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
    else if(M00_axi_rvalid & M00_axi_rready & (ar_rx_fifo_send == ar_state_q))
        rx_data_r <= {24'h0, M00_axi_rdata[7:0]};
end

// Spiking Neural Net

  spiking_neural_net #(
      .weight_hidden_p(weight_hidden_p),
      .weight_output_p(weight_output_p),
      .weights_hidden_neuron_1_p(hidden_weight_hexfile_1_p),
      .weights_hidden_neuron_2_p(hidden_weight_hexfile_2_p),
      .weights_hidden_neuron_3_p(hidden_weight_hexfile_3_p),
      .weights_hidden_neuron_4_p(hidden_weight_hexfile_4_p),
      .weights_hidden_neuron_5_p(hidden_weight_hexfile_5_p),
      .weights_hidden_neuron_6_p(hidden_weight_hexfile_6_p),
      .weights_hidden_neuron_7_p(hidden_weight_hexfile_7_p),
      .weights_hidden_neuron_8_p(hidden_weight_hexfile_8_p),
      .weights_hidden_neuron_9_p(hidden_weight_hexfile_9_p),
      .weights_hidden_neuron_10_p(hidden_weight_hexfile_10_p),
      .weights_hidden_neuron_11_p(hidden_weight_hexfile_11_p),
      .weights_hidden_neuron_12_p(hidden_weight_hexfile_12_p),
      .weights_hidden_neuron_13_p(hidden_weight_hexfile_13_p),
      .weights_hidden_neuron_14_p(hidden_weight_hexfile_14_p),
      .weights_hidden_neuron_15_p(hidden_weight_hexfile_15_p),
      .weights_hidden_neuron_16_p(hidden_weight_hexfile_16_p),
      .weights_hidden_neuron_17_p(hidden_weight_hexfile_17_p),
      .weights_hidden_neuron_18_p(hidden_weight_hexfile_18_p),
      .weights_hidden_neuron_19_p(hidden_weight_hexfile_19_p),
      .weights_hidden_neuron_20_p(hidden_weight_hexfile_20_p),
      .weights_hidden_neuron_21_p(hidden_weight_hexfile_21_p),
      .weights_hidden_neuron_22_p(hidden_weight_hexfile_22_p),
      .weights_hidden_neuron_23_p(hidden_weight_hexfile_23_p),
      .weights_hidden_neuron_24_p(hidden_weight_hexfile_24_p),
      .weights_hidden_neuron_25_p(hidden_weight_hexfile_25_p),
      .weights_hidden_neuron_26_p(hidden_weight_hexfile_26_p),
      .weights_hidden_neuron_27_p(hidden_weight_hexfile_27_p),
      .weights_hidden_neuron_28_p(hidden_weight_hexfile_28_p),
      .weights_hidden_neuron_29_p(hidden_weight_hexfile_29_p),
      .weights_hidden_neuron_30_p(hidden_weight_hexfile_30_p),
      .weights_hidden_neuron_31_p(hidden_weight_hexfile_31_p),
      .weights_hidden_neuron_32_p(hidden_weight_hexfile_32_p),
      .weights_output_neuron_1_p(output_weight_hexfile_1_p),
      .weights_output_neuron_2_p(output_weight_hexfile_2_p),
      .weights_output_neuron_3_p(output_weight_hexfile_3_p)
     ) dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .euler_imu_x(euler_imu_x_i),
        .euler_imu_y(euler_imu_y_i),
        .euler_imu_z(euler_imu_z_i),
        .position_x(position_x_i),
        .position_y(position_y_i),
        .position_z(position_z_i),
        .vel_imu_x(vel_imu_x_o),
        .vel_imu_y(vel_imu_y_o),
        .vel_imu_z(vel_imu_z_o),
        .valid_o(valid_o),
        .ready_i(ready_i)
    );

endmodule
