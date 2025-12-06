module snn_axil #(
    parameter integer weight_hidden_p = 6,
    parameter integer weight_output_p = 32,
    //has -1.0, -0.5, 0.0, 0.25, 0.5, 1.0
    parameter string hidden_weight_hexfile_1_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_2_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_3_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_4_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_5_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_6_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_7_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_8_p = "../util/test.hex",
    parameter string hidden_weight_hexfile_9_p = "../util/test.hex",
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
    parameter string output_weight_hexfile_1_p = "../util/test1.hex",
    parameter string output_weight_hexfile_2_p = "../util/test1.hex",
    parameter string output_weight_hexfile_3_p = "../util/test1.hex"
) (
    // Clock
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ACLK, ASSOCIATED_BUSIF M00_AXI, ASSOCIATED_RESET M00_AXI_ARESETN" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M00_AXI_ACLK CLK" *)
    input  wire M00_ACLK,

    // Reset (active-low)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXI_ARESETN, POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M00_AXI_ARESETN RST" *)
    input  wire M00_ARESETN,

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

//Addresses
localparam logic [31:0] RxFifoAddress_lp  = 32'h0;
localparam logic [31:0] TxFifoAddress_lp  = 32'h4;
localparam logic [31:0] STAT_REG_Address_lp = 32'h8;
localparam logic [31:0] CTRL_REG_Address_lp = 32'hC;
localparam logic [31:0] BRAM_ADDRESS_lp = 32'h80;   //beginning of bram - only need 6 elements

//Tx Codes - How to read Tx
localparam logic [31:0] Load_Data_lp = 32'h5E9D_DA1A;  //send data - sent to bram
localparam logic [31:0] Stall_Input_lp = 32'h5109_DA1A;    //stop data input
localparam logic [31:0] Spike_Output_lp = 32'hDA1A_5000;    //spikes are ready

logic  [31:0]  rx_data_r;
logic ar_transaction_done_r, rx_got_data_d, rx_got_data_q;

typedef enum logic [1:0] { ar_is_valid, ar_is_not_valid } ar_state_t;
typedef enum logic { aw_wait_for_slave, aw_slave_takes_awaddr } aw_state_t;
typedef enum logic [1:0] { w_wait_for_data, w_wait_for_slave, w_slave_takes_wdata } w_state_t;
typedef enum logic [3:0] { idle, load_data, setup_snn, run_snn, decode_snn, output_data, error } snn_state_t;

ar_state_t ar_state_q, ar_state_d;
aw_state_t aw_state_q, aw_state_d;
w_state_t  w_state_q, w_state_d;
snn_state_t snn_state_d, snn_state_q;

//bus declarations
logic [31:0] ar_addr_d,ar_addr_q;
logic [0:0] ar_valid_d, ar_valid_q;
logic [31:0] aw_addr_d,aw_addr_q;
logic [0:0] aw_valid_d, aw_valid_q;
logic [0:0] w_valid_d, w_valid_q;
logic [31:0] w_data_d, w_data_q;

//transaction busses
logic start_read,start_write;

//SNN busses
logic snn_valid_i, snn_valid_o;
logic snn_valid_d, snn_valid_q;
logic snn_ready_i, snn_ready_o;
logic snn_ready_d, snn_ready_q;
logic [31:0] bram_index_reg_q,bram_index_reg_d;
logic bram_index_reg_reset;

//top bit is valid bit
logic [31:0] euler_imu_x, euler_imu_x_d;
logic [31:0] euler_imu_y, euler_imu_y_d;
logic [31:0] euler_imu_z, euler_imu_z_d;
logic [31:0] position_x, position_x_d;
logic [31:0] position_y, position_y_d;
logic [31:0] position_z, position_z_d;

//Spike bus - x = b[0], y = b[1], z = b[2]
logic [2:0] snn_spikes;

// AW CHANNEL
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
    if(start_write) begin
        aw_valid_d = 1'b1;
    end
    if(M00_axi_awvalid & M00_axi_awready) begin
        aw_valid_d = 1'b0;
    end
    //where the next ar_addr
    case (snn_state_q)
        idle: aw_addr_d = 32'b0;
        load_data: aw_addr_d = BRAM_ADDRESS_lp + (bram_index_reg_q << 32'h2);
        setup_snn: aw_addr_d = TxFifoAddress_lp;
        run_snn: aw_addr_d = TxFifoAddress_lp;
        decode_snn: aw_addr_d = TxFifoAddress_lp;
        error: aw_addr_d = TxFifoAddress_lp;
        default: aw_addr_d = TxFifoAddress_lp;
    endcase 
end

assign M00_axi_awaddr = aw_addr_q;
assign M00_axi_awvalid = aw_valid_q;

// W CHANNEL
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
    M00_axi_wstrb = 4'hf;
    w_state_d = w_state_q;
    w_valid_d = w_valid_q;
    if(start_write) begin
        w_valid_d = 1'b1;
    end
    if(M00_axi_wready & M00_axi_wvalid) begin
        w_valid_d = 1'b0;
    end
end

assign M00_axi_wdata = w_data_q;
assign M00_axi_wvalid = w_valid_q;

// B CHANNEL
assign M00_axi_bready = 1'b1;

// AR CHANNEL
//set by SNN FSM
always_ff @(posedge M00_ACLK) begin
    if(~M00_ARESETN) begin
        ar_addr_q <= STAT_REG_Address_lp;
    end else begin
        ar_addr_q <= ar_addr_d;
    end
end

always_ff @(posedge M00_ACLK) begin
    if(~M00_ARESETN) begin
        ar_valid_q <= 1'b0;
    end else begin
        ar_valid_q <= ar_valid_d;
    end
end

always_comb begin
    M00_axi_arprot = 3'b0;
    ar_valid_d = ar_valid_q;
    ar_addr_d = ar_addr_q;
    if(start_read) begin
        ar_valid_d = 1'b1;
    end
    if(M00_axi_arvalid & M00_axi_arready) begin
        ar_valid_d = 1'b0;
    end
    //where the next ar_addrs(-)
    case (snn_state_q)
        idle: ar_addr_d = STAT_REG_Address_lp;
        load_data: ar_addr_d = RxFifoAddress_lp;
        setup_snn: ar_addr_d = BRAM_ADDRESS_lp + (bram_index_reg_q << 32'h2);
        run_snn: ar_addr_d = ar_addr_q;
        decode_snn: ar_addr_d = ar_addr_q;
        error: ar_addr_d = STAT_REG_Address_lp;
        default: ar_addr_d = STAT_REG_Address_lp;
    endcase 
end

assign M00_axi_araddr = ar_addr_q;
assign M00_axi_arvalid = ar_valid_q;

// R CHANNEL
assign M00_axi_rready = 1'b1;

// Spiking Neural Net

always_comb begin : snn_state_logic
    snn_state_d = snn_state_q;
    snn_valid_d = snn_valid_q;
    snn_ready_d = snn_ready_q;
    start_read = 0;
    start_write = 0;
    euler_imu_x_d = euler_imu_x;
    euler_imu_y_d = euler_imu_y;
    euler_imu_z_d = euler_imu_z;
    position_x_d = position_x;
    position_y_d = position_y;
    position_z_d = position_z;
    //bram index
    bram_index_reg_d = bram_index_reg_q;
    bram_index_reg_reset = 1'b0;
    //sets the w_data
    w_data_d = w_data_q;
    case (snn_state_q)
        idle: begin
            //signal to send data
            start_read = 1;
            start_write = 0;
            w_data_d = '0;
            bram_index_reg_reset = 1'b1;
            if(M00_axi_rready & M00_axi_rvalid & M00_axi_rdata[0]) begin
                snn_state_d = load_data;
            end else begin
                snn_state_d = idle;
            end
        end

        load_data: begin
            //read from RX Fifo and do not write at all
            start_read = 1'b1;
            bram_index_reg_reset = 1'b0;
            if(M00_axi_rready & M00_axi_rvalid) begin
                //increment bram address
                start_write = 1'b1;
                w_data_d = M00_axi_rdata;
                bram_index_reg_d = bram_index_reg_q + 32'd1;
                if(bram_index_reg_d >= 32'd6) begin
                    snn_state_d = setup_snn;
                    //reset for a cycle
                    bram_index_reg_reset = 1;
                end else begin
                    snn_state_d = load_data;
                end
            end else begin
                snn_state_d = load_data;
            end
        end

        setup_snn: begin
            //reads from BRAM
            start_read = 1;
            bram_index_reg_reset = 0;
            if(M00_axi_rready & M00_axi_rvalid) begin
               bram_index_reg_d = bram_index_reg_q + 32'd1;
               //lazy
               euler_imu_x_d = bram_index_reg_q == 32'd0 ? M00_axi_rdata : euler_imu_x;
               euler_imu_y_d = bram_index_reg_q == 32'd1 ? M00_axi_rdata : euler_imu_y;
               euler_imu_z_d = bram_index_reg_q == 32'd2 ? M00_axi_rdata : euler_imu_z;
               position_x_d = bram_index_reg_q == 32'd3 ? M00_axi_rdata : position_x;
               position_y_d = bram_index_reg_q == 32'd4 ? M00_axi_rdata : position_y;
               position_z_d = bram_index_reg_q == 32'd5 ? M00_axi_rdata : position_z;
                if(bram_index_reg_d >= 32'd6) begin
                    snn_state_d = run_snn;
                    snn_valid_d = 1;
                    snn_ready_d = 1;
                end else begin
                    snn_state_d = setup_snn;
                end
            end else begin
                snn_state_d = setup_snn;
            end
        end

        run_snn: begin
            start_read = 0;
            start_write = 0;
            if(snn_valid_o) begin
                snn_state_d = decode_snn;
            end else begin
                snn_state_d = run_snn;
            end
        end

        decode_snn: begin
            start_write = 1;
            w_data_d = Spike_Output_lp | {23'b0, snn_spikes[2], 8'b0} | {27'b0, snn_spikes[1], 4'b0} | {31'b0,snn_spikes[0]};
            snn_state_d = idle;
        end

        error: begin
            snn_state_d = error;
            start_write = 1;
            w_data_d = '1;
        end

        default: begin
            snn_state_d = error;
        end
    endcase

end

always_ff @(posedge M00_ACLK) begin
    if (!M00_ARESETN) begin
        euler_imu_x <= 32'h0;
        euler_imu_y <= 32'h0;
        euler_imu_z <= 32'h0;
        position_x <= 32'h0;
        position_y <= 32'h0;
        position_z <= 32'h0;
    end else if (snn_valid_i & snn_ready_o) begin
        euler_imu_x <= euler_imu_x_d;
        euler_imu_y <= euler_imu_y_d;
        euler_imu_z <= euler_imu_z_d;
        position_x <= position_x_d;
        position_y <= position_y_d;
        position_z <= position_z_d;
    end
end

always_ff @(posedge M00_ACLK) begin
    if(!M00_ARESETN) begin
        snn_state_q <= idle;
        snn_valid_q <= 0;
        snn_ready_q <= 0;
    end else begin
        snn_state_q <= snn_state_d;
        snn_valid_q <= snn_valid_d;
        snn_ready_q <= snn_ready_d;
    end
end

always_ff @( posedge M00_ACLK ) begin
    if(!M00_ARESETN | bram_index_reg_reset) begin
        bram_index_reg_q <= '0;
    end else begin
        bram_index_reg_q <= bram_index_reg_d;
    end
end

assign snn_valid_i = snn_valid_q;
assign snn_ready_i = snn_ready_q;

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
) snn(
    .clk_i(M00_ACLK),
    .resetn_i(M00_ARESETN),
    .valid_i(snn_valid_i),
    .ready_o(snn_ready_o),
    .euler_imu_x(euler_imu_x),
    .euler_imu_y(euler_imu_y),
    .euler_imu_z(euler_imu_z),
    .position_x(position_x),
    .position_y(position_y),
    .position_z(position_z),
    .vel_imu_x(snn_spikes[0]),
    .vel_imu_y(snn_spikes[1]),
    .vel_imu_z(snn_spikes[2]),
    .valid_o(snn_valid_o),
    .ready_i(snn_ready_i)
);

endmodule
