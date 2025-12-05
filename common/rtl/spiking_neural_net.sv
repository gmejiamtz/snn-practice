module spiking_neural_net #(
    parameter integer weight_hidden_p = 6,
    parameter integer weight_output_p = 32,
    //has -1.0, -0.5, 0.0, 0.25, 0.5, 1.0
    parameter string weights_hidden_neuron_1_p = "../util/test.hex",
    parameter string weights_hidden_neuron_2_p = "../util/test.hex",
    parameter string weights_hidden_neuron_3_p = "../util/test.hex",
    parameter string weights_hidden_neuron_4_p = "../util/test.hex",
    parameter string weights_hidden_neuron_5_p = "../util/test.hex",
    parameter string weights_hidden_neuron_6_p = "../util/test.hex",
    parameter string weights_hidden_neuron_7_p = "../util/test.hex",
    parameter string weights_hidden_neuron_8_p = "../util/test.hex",
    parameter string weights_hidden_neuron_9_p = "../util/test.hex",
    parameter string weights_hidden_neuron_10_p = "../util/test.hex",
    parameter string weights_hidden_neuron_11_p = "../util/test.hex",
    parameter string weights_hidden_neuron_12_p = "../util/test.hex",
    parameter string weights_hidden_neuron_13_p = "../util/test.hex",
    parameter string weights_hidden_neuron_14_p = "../util/test.hex",
    parameter string weights_hidden_neuron_15_p = "../util/test.hex",
    parameter string weights_hidden_neuron_16_p = "../util/test.hex",
    parameter string weights_hidden_neuron_17_p = "../util/test.hex",
    parameter string weights_hidden_neuron_18_p = "../util/test.hex",
    parameter string weights_hidden_neuron_19_p = "../util/test.hex",
    parameter string weights_hidden_neuron_20_p = "../util/test.hex",
    parameter string weights_hidden_neuron_21_p = "../util/test.hex",
    parameter string weights_hidden_neuron_22_p = "../util/test.hex",
    parameter string weights_hidden_neuron_23_p = "../util/test.hex",
    parameter string weights_hidden_neuron_24_p = "../util/test.hex",
    parameter string weights_hidden_neuron_25_p = "../util/test.hex",
    parameter string weights_hidden_neuron_26_p = "../util/test.hex",
    parameter string weights_hidden_neuron_27_p = "../util/test.hex",
    parameter string weights_hidden_neuron_28_p = "../util/test.hex",
    parameter string weights_hidden_neuron_29_p = "../util/test.hex",
    parameter string weights_hidden_neuron_30_p = "../util/test.hex",
    parameter string weights_hidden_neuron_31_p = "../util/test.hex",
    parameter string weights_hidden_neuron_32_p = "../util/test.hex",
    //output neuron hexfiles
    parameter string weights_output_neuron_1_p = "../util/test.hex",
    parameter string weights_output_neuron_2_p = "../util/test.hex",
    parameter string weights_output_neuron_3_p = "../util/test.hex"
    )(
    input clk_i,
    input resetn_i,
    input valid_i,
    output ready_o,

    //input currents
    input [31:0] euler_imu_x,
    input [31:0] euler_imu_y,
    input [31:0] euler_imu_z,
    input [31:0] position_x,
    input [31:0] position_y,
    input [31:0] position_z,

    //output spikes
    output vel_imu_xp,
    output vel_imu_xn,
    output vel_imu_yp,

    input ready_i,
    output valid_o
);

logic [2:0] input_layer_spikes;
logic [2:0] input_layer_valid_o;
logic [2:0] input_layer_ready_i;
logic [2:0] input_layer_valid_i;
logic [2:0] input_layer_ready_o;
logic [31:0] hidden_layer_spikes;
logic [0:0] hidden_layer_valid_i;
logic [0:0] hidden_layer_ready_i;
logic [0:0] hidden_layer_valid_o;
logic [0:0] hidden_layer_ready_o;
logic [31:0] output_layer_current [2:0];
logic [0:0] output_layer_valid_i;
logic [2:0] output_layer_valid_o;

//BRAM memories

logic [31:0] hidden_neuron_1_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_2_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_3_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_4_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_5_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_6_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_7_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_8_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_9_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_10_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_11_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_12_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_13_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_14_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_15_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_16_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_17_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_18_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_19_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_20_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_21_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_22_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_23_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_24_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_25_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_26_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_27_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_28_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_29_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_30_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_31_weights [0:weight_hidden_p-1];
logic [31:0] hidden_neuron_32_weights [0:weight_hidden_p-1];
logic [31:0] output_neuron_1_weights [0:weight_output_p-1];
logic [31:0] output_neuron_2_weights [0:weight_output_p-1];
logic [31:0] output_neuron_3_weights [0:weight_output_p-1];

//Weight Memories
initial begin
    $readmemh(weights_hidden_neuron_1_p, hidden_neuron_1_weights);
    $readmemh(weights_hidden_neuron_2_p, hidden_neuron_2_weights);
    $readmemh(weights_hidden_neuron_3_p, hidden_neuron_3_weights);
    $readmemh(weights_hidden_neuron_4_p, hidden_neuron_4_weights);
    $readmemh(weights_hidden_neuron_5_p, hidden_neuron_5_weights);
    $readmemh(weights_hidden_neuron_6_p, hidden_neuron_6_weights);
    $readmemh(weights_hidden_neuron_7_p, hidden_neuron_7_weights);
    $readmemh(weights_hidden_neuron_8_p, hidden_neuron_8_weights);
    $readmemh(weights_hidden_neuron_9_p, hidden_neuron_9_weights);
    $readmemh(weights_hidden_neuron_10_p, hidden_neuron_10_weights);
    $readmemh(weights_hidden_neuron_11_p, hidden_neuron_11_weights);
    $readmemh(weights_hidden_neuron_12_p, hidden_neuron_12_weights);
    $readmemh(weights_hidden_neuron_13_p, hidden_neuron_13_weights);
    $readmemh(weights_hidden_neuron_14_p, hidden_neuron_14_weights);
    $readmemh(weights_hidden_neuron_15_p, hidden_neuron_15_weights);
    $readmemh(weights_hidden_neuron_16_p, hidden_neuron_16_weights);
    $readmemh(weights_hidden_neuron_17_p, hidden_neuron_17_weights);
    $readmemh(weights_hidden_neuron_18_p, hidden_neuron_18_weights);
    $readmemh(weights_hidden_neuron_19_p, hidden_neuron_19_weights);
    $readmemh(weights_hidden_neuron_20_p, hidden_neuron_20_weights);
    $readmemh(weights_hidden_neuron_21_p, hidden_neuron_21_weights);
    $readmemh(weights_hidden_neuron_22_p, hidden_neuron_22_weights);
    $readmemh(weights_hidden_neuron_23_p, hidden_neuron_23_weights);
    $readmemh(weights_hidden_neuron_24_p, hidden_neuron_24_weights);
    $readmemh(weights_hidden_neuron_25_p, hidden_neuron_25_weights);
    $readmemh(weights_hidden_neuron_26_p, hidden_neuron_26_weights);
    $readmemh(weights_hidden_neuron_27_p, hidden_neuron_27_weights);
    $readmemh(weights_hidden_neuron_28_p, hidden_neuron_28_weights);
    $readmemh(weights_hidden_neuron_29_p, hidden_neuron_29_weights);
    $readmemh(weights_hidden_neuron_30_p, hidden_neuron_30_weights);
    $readmemh(weights_hidden_neuron_31_p, hidden_neuron_31_weights);
    $readmemh(weights_hidden_neuron_32_p, hidden_neuron_32_weights);
    $readmemh(weights_output_neuron_1_p, output_neuron_1_weights);
    $readmemh(weights_output_neuron_2_p, output_neuron_2_weights);
    $readmemh(weights_output_neuron_3_p, output_neuron_3_weights);
end

// Euler IMU Neurons - Input Layer neurons are just LIFs with no acc units

lif_neuron input_lif_euler_imu_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_xp),
    .spk_o(input_layer_spikes[0]),
    .valid_o(input_layer_valid_o[0])
);

lif_neuron input_lif_euler_imu_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_xn),
    .spk_o(input_layer_spikes[1]),
    .valid_o(input_layer_valid_o[1])
);

lif_neuron input_lif_euler_imu_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_yp),
    .spk_o(input_layer_spikes[2]),
    .valid_o(input_layer_valid_o[2])
);

lif_neuron input_lif_euler_imu_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_yn),
    .spk_o(input_layer_spikes[3]),
    .valid_o(input_layer_valid_o[3])
);

lif_neuron input_lif_euler_imu_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_zp),
    .spk_o(input_layer_spikes[4]),
    .valid_o(input_layer_valid_o[4])
);

lif_neuron input_lif_euler_imu_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(valid_i),
    .current_i(euler_imu_zn),
    .spk_o(input_layer_spikes[5]),
    .valid_o(input_layer_valid_o[5])
);

// Position Neurons

lif_neuron input_lif_position_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_xp),
    .spk_o(input_layer_spikes[6]),
    .valid_o(input_layer_valid_o[6])
);

lif_neuron input_lif_position_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_xn),
    .spk_o(input_layer_spikes[7]),
    .valid_o(input_layer_valid_o[7])
);

lif_neuron input_lif_position_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_yp),
    .spk_o(input_layer_spikes[8]),
    .valid_o(input_layer_valid_o[8])
);

lif_neuron input_lif_position_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_yn),
    .spk_o(input_layer_spikes[9]),
    .valid_o(input_layer_valid_o[9])
);

lif_neuron input_position_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_zp),
    .spk_o(input_layer_spikes[10]),
    .valid_o(input_layer_valid_o[10])
);

lif_neuron input_position_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_zn),
    .spk_o(input_layer_spikes[11]),
    .valid_o(input_layer_valid_o[11])
);

assign hidden_layer_valid_i = &input_layer_valid_o;

//hidden layer calculations

genvar hidden_neuron;
generate
    for(hidden_neuron = 0; hidden_neuron < 64; hidden_neuron++) begin : hidden_layer
        lif_neuron input_lif (
            .clk_i(clk_i),
            .resetn_i(resetn_i),
            .valid_i(hidden_layer_valid_i),
            .current_i(hidden_layer_current[hidden_neuron]),
            .spk_o(hidden_layer_spikes[hidden_neuron]),
            .valid_o(hidden_layer_valid_o[hidden_neuron])
        );
    end
endgenerate

assign output_layer_valid_i = &hidden_layer_valid_o;

// Velocity IMU Neurons

lif_neuron input_lif_vel_imu_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[0]),
    .valid_i(output_layer_valid_i),
    .spk_o(vel_imu_xp),
    .valid_o(output_layer_valid_o[0])
);

lif_neuron input_lif_vel_imu_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i),
    .current_i(output_layer_current[1]),
    .spk_o(vel_imu_xn),
    .valid_o(output_layer_valid_o[1])
);

lif_neuron input_lif_vel_imu_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i),
    .current_i(output_layer_current[2]),
    .spk_o(vel_imu_yp),
    .valid_o(output_layer_valid_o[2])
);

lif_neuron input_lif_vel_imu_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i),
    .current_i(output_layer_current[3]),
    .spk_o(vel_imu_yn),
    .valid_o(output_layer_valid_o[3])
);

lif_neuron input_lif_vel_imu_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i),
    .current_i(output_layer_current[4]),
    .spk_o(vel_imu_zp),
    .valid_o(output_layer_valid_o[4])
);

lif_neuron input_lif_vel_imu_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i),
    .current_i(output_layer_current[5]),
    .spk_o(vel_imu_zn),
    .valid_o(output_layer_valid_o[5])
);

assign valid_o = output_layer_valid_o;

//Weight Calculations



endmodule
