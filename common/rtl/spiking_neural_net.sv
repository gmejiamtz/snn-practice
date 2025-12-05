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
    parameter string weights_output_neuron_1_p = "../util/test1.hex",
    parameter string weights_output_neuron_2_p = "../util/test1.hex",
    parameter string weights_output_neuron_3_p = "../util/test1.hex"
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
    output vel_imu_x,
    output vel_imu_y,
    output vel_imu_z,

    input ready_i,
    output valid_o
);

//input layer inferace
logic [5:0] input_layer_spikes;
logic [5:0] input_layer_valid_o;
logic [5:0] input_layer_ready_i;
logic [5:0] input_layer_valid_i;
logic [5:0] input_layer_ready_o;
//hidden layer inferface
logic [31:0] hidden_layer_spikes;
logic [31:0] hidden_layer_valid_i;
logic [31:0] hidden_layer_ready_i;
logic [31:0] hidden_layer_valid_o;
logic [31:0] hidden_layer_ready_o;
//output layer inferace
logic [2:0] output_layer_valid_i;
logic [2:0] output_layer_valid_o;
logic [2:0] output_layer_ready_i;
logic [2:0] output_layer_ready_o;

// Euler IMU Neurons - Input Layer neurons are just LIFs with no acc units

assign input_layer_valid_i = {6{valid_i}};

lif_neuron input_lif_euler_imu_x (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[0]),
    .ready_o(input_layer_ready_o[0]),
    .current_i(euler_imu_x),
    .spk_o(input_layer_spikes[0]),
    .ready_i(input_layer_ready_i[0]),
    .valid_o(input_layer_valid_o[0])
);

lif_neuron input_lif_euler_imu_y (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[1]),
    .ready_o(input_layer_ready_o[1]),
    .current_i(euler_imu_y),
    .spk_o(input_layer_spikes[1]),
    .valid_o(input_layer_valid_o[1]),
    .ready_i(input_layer_ready_i[1])
);

lif_neuron input_lif_euler_imu_z (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[2]),
    .ready_o(input_layer_ready_o[2]),
    .current_i(euler_imu_z),
    .spk_o(input_layer_spikes[2]),
    .valid_o(input_layer_valid_o[2]),
    .ready_i(input_layer_ready_i[2])
);

// Position Neurons

lif_neuron input_lif_position_x (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[3]),
    .ready_o(input_layer_ready_o[3]),
    .current_i(position_x),
    .spk_o(input_layer_spikes[3]),
    .ready_i(input_layer_ready_i[3]),
    .valid_o(input_layer_valid_o[3])
);

lif_neuron input_lif_position_y (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[4]),
    .ready_o(input_layer_ready_o[4]),
    .current_i(position_y),
    .spk_o(input_layer_spikes[4]),
    .ready_i(input_layer_ready_i[4]),
    .valid_o(input_layer_valid_o[4])
);

lif_neuron input_lif_position_z (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(input_layer_valid_i[5]),
    .ready_o(input_layer_ready_o[5]),
    .current_i(position_y),
    .spk_o(input_layer_spikes[5]),
    .ready_i(input_layer_ready_i[5]),
    .valid_o(input_layer_valid_o[5])
);

assign input_layer_ready_i = {6{&hidden_layer_ready_o}};
assign hidden_layer_valid_i = {32{&input_layer_valid_o}};

//hidden layer - cant use genvar cuz parameters are all different file names

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_1_p)
) hidden_lif_1 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[0]),
    .ready_o(hidden_layer_ready_o[0]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[0]),
    .ready_i(hidden_layer_ready_i[0]),
    .valid_o(hidden_layer_valid_o[0])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_2_p)
) hidden_lif_2 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[1]),
    .ready_o(hidden_layer_ready_o[1]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[1]),
    .ready_i(hidden_layer_ready_i[1]),
    .valid_o(hidden_layer_valid_o[1])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_3_p)
) hidden_lif_3 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[2]),
    .ready_o(hidden_layer_ready_o[2]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[2]),
    .ready_i(hidden_layer_ready_i[2]),
    .valid_o(hidden_layer_valid_o[2])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_4_p)
) hidden_lif_4 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[3]),
    .ready_o(hidden_layer_ready_o[3]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[3]),
    .ready_i(hidden_layer_ready_i[3]),
    .valid_o(hidden_layer_valid_o[3])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_5_p)
) hidden_lif_5 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[4]),
    .ready_o(hidden_layer_ready_o[4]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[4]),
    .ready_i(hidden_layer_ready_i[4]),
    .valid_o(hidden_layer_valid_o[4])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_6_p)
) hidden_lif_6 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[5]),
    .ready_o(hidden_layer_ready_o[5]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[5]),
    .ready_i(hidden_layer_ready_i[5]),
    .valid_o(hidden_layer_valid_o[5])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_7_p)
) hidden_lif_7 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[6]),
    .ready_o(hidden_layer_ready_o[6]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[6]),
    .ready_i(hidden_layer_ready_i[6]),
    .valid_o(hidden_layer_valid_o[6])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_8_p)
) hidden_lif_8 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[7]),
    .ready_o(hidden_layer_ready_o[7]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[7]),
    .ready_i(hidden_layer_ready_i[7]),
    .valid_o(hidden_layer_valid_o[7])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_9_p)
) hidden_lif_9 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[8]),
    .ready_o(hidden_layer_ready_o[8]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[8]),
    .ready_i(hidden_layer_ready_i[8]),
    .valid_o(hidden_layer_valid_o[8])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_10_p)
) hidden_lif_10 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[9]),
    .ready_o(hidden_layer_ready_o[9]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[9]),
    .ready_i(hidden_layer_ready_i[9]),
    .valid_o(hidden_layer_valid_o[9])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_11_p)
) hidden_lif_11 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[10]),
    .ready_o(hidden_layer_ready_o[10]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[10]),
    .ready_i(hidden_layer_ready_i[10]),
    .valid_o(hidden_layer_valid_o[10])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_12_p)
) hidden_lif_12 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[11]),
    .ready_o(hidden_layer_ready_o[11]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[11]),
    .ready_i(hidden_layer_ready_i[11]),
    .valid_o(hidden_layer_valid_o[11])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_13_p)
) hidden_lif_13 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[12]),
    .ready_o(hidden_layer_ready_o[12]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[12]),
    .ready_i(hidden_layer_ready_i[12]),
    .valid_o(hidden_layer_valid_o[12])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_14_p)
) hidden_lif_14 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[13]),
    .ready_o(hidden_layer_ready_o[13]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[13]),
    .ready_i(hidden_layer_ready_i[13]),
    .valid_o(hidden_layer_valid_o[13])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_15_p)
) hidden_lif_15 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[14]),
    .ready_o(hidden_layer_ready_o[14]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[14]),
    .ready_i(hidden_layer_ready_i[14]),
    .valid_o(hidden_layer_valid_o[14])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_16_p)
) hidden_lif_16 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[15]),
    .ready_o(hidden_layer_ready_o[15]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[15]),
    .ready_i(hidden_layer_ready_i[15]),
    .valid_o(hidden_layer_valid_o[15])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_17_p)
) hidden_lif_17 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[16]),
    .ready_o(hidden_layer_ready_o[16]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[16]),
    .ready_i(hidden_layer_ready_i[16]),
    .valid_o(hidden_layer_valid_o[16])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_18_p)
) hidden_lif_18 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[17]),
    .ready_o(hidden_layer_ready_o[17]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[17]),
    .ready_i(hidden_layer_ready_i[17]),
    .valid_o(hidden_layer_valid_o[17])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_19_p)
) hidden_lif_19 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[18]),
    .ready_o(hidden_layer_ready_o[18]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[18]),
    .ready_i(hidden_layer_ready_i[18]),
    .valid_o(hidden_layer_valid_o[18])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_20_p)
) hidden_lif_20 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[19]),
    .ready_o(hidden_layer_ready_o[19]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[19]),
    .ready_i(hidden_layer_ready_i[19]),
    .valid_o(hidden_layer_valid_o[19])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_21_p)
) hidden_lif_21 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[20]),
    .ready_o(hidden_layer_ready_o[20]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[20]),
    .ready_i(hidden_layer_ready_i[20]),
    .valid_o(hidden_layer_valid_o[20])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_22_p)
) hidden_lif_22 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[21]),
    .ready_o(hidden_layer_ready_o[21]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[21]),
    .ready_i(hidden_layer_ready_i[21]),
    .valid_o(hidden_layer_valid_o[21])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_23_p)
) hidden_lif_23 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[22]),
    .ready_o(hidden_layer_ready_o[22]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[22]),
    .ready_i(hidden_layer_ready_i[22]),
    .valid_o(hidden_layer_valid_o[22])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_24_p)
) hidden_lif_24 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[23]),
    .ready_o(hidden_layer_ready_o[23]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[23]),
    .ready_i(hidden_layer_ready_i[23]),
    .valid_o(hidden_layer_valid_o[23])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_25_p)
) hidden_lif_25 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[24]),
    .ready_o(hidden_layer_ready_o[24]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[24]),
    .ready_i(hidden_layer_ready_i[24]),
    .valid_o(hidden_layer_valid_o[24])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_26_p)
) hidden_lif_26 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[25]),
    .ready_o(hidden_layer_ready_o[25]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[25]),
    .ready_i(hidden_layer_ready_i[25]),
    .valid_o(hidden_layer_valid_o[25])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_27_p)
) hidden_lif_27 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[26]),
    .ready_o(hidden_layer_ready_o[26]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[26]),
    .ready_i(hidden_layer_ready_i[26]),
    .valid_o(hidden_layer_valid_o[26])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_28_p)
) hidden_lif_28 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[27]),
    .ready_o(hidden_layer_ready_o[27]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[27]),
    .ready_i(hidden_layer_ready_i[27]),
    .valid_o(hidden_layer_valid_o[27])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_29_p)
) hidden_lif_29 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[28]),
    .ready_o(hidden_layer_ready_o[28]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[28]),
    .ready_i(hidden_layer_ready_i[28]),
    .valid_o(hidden_layer_valid_o[28])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_30_p)
) hidden_lif_30 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[29]),
    .ready_o(hidden_layer_ready_o[29]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[29]),
    .ready_i(hidden_layer_ready_i[29]),
    .valid_o(hidden_layer_valid_o[29])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_31_p)
) hidden_lif_31 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[30]),
    .ready_o(hidden_layer_ready_o[30]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[30]),
    .ready_i(hidden_layer_ready_i[30]),
    .valid_o(hidden_layer_valid_o[30])
);

lif #(
    .weight_num_p(weight_hidden_p),
    .weight_hexfile_p(weights_hidden_neuron_32_p)
) hidden_lif_32 (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(hidden_layer_valid_i[31]),
    .ready_o(hidden_layer_ready_o[31]),
    .spikes_i(input_layer_spikes),
    .spike_o(hidden_layer_spikes[31]),
    .ready_i(hidden_layer_ready_i[31]),
    .valid_o(hidden_layer_valid_o[31])
);

assign hidden_layer_ready_i = {32{&output_layer_ready_o}};
assign output_layer_valid_i = {3{&hidden_layer_valid_o}};

// Velocity IMU Neurons - ouput layer

assign output_layer_ready_i = {3{ready_i}};

lif #(
    .weight_num_p(weight_output_p),
    .weight_hexfile_p(weights_output_neuron_1_p)
) output_lif_vel_imu_x (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .spikes_i(hidden_layer_spikes),
    .valid_i(output_layer_valid_i[0]),
    .ready_o(output_layer_ready_o[0]),
    .spike_o(vel_imu_x),
    .ready_i(output_layer_ready_i[0]),
    .valid_o(output_layer_valid_o[0])
);

lif #(
    .weight_num_p(weight_output_p),
    .weight_hexfile_p(weights_output_neuron_2_p)
) output_lif_vel_imu_y (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i[1]),
    .ready_o(output_layer_ready_o[1]),
    .spikes_i(hidden_layer_spikes),
    .spike_o(vel_imu_y),
    .ready_i(output_layer_ready_i[1]),
    .valid_o(output_layer_valid_o[1])
);

lif #(
    .weight_num_p(weight_output_p),
    .weight_hexfile_p(weights_output_neuron_3_p)
) output_lif_vel_imu_z (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .valid_i(output_layer_valid_i[2]),
    .ready_o(output_layer_ready_o[2]),
    .spikes_i(hidden_layer_spikes),
    .spike_o(vel_imu_z),
    .ready_i(output_layer_ready_i[2]),
    .valid_o(output_layer_valid_o[2])
);

assign valid_o = &output_layer_valid_o;
assign ready_o = &input_layer_ready_o;

endmodule
