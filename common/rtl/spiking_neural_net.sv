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
    output vel_imu_x,
    output vel_imu_x,
    output vel_imu_y,

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
logic [2:0] input_layer_spikes;
logic [2:0] output_layer_valid_i;
logic [2:0] output_layer_valid_o;
logic [2:0] output_layer_ready_i;
logic [2:0] output_layer_ready_o;

// Euler IMU Neurons - Input Layer neurons are just LIFs with no acc units

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

assign hidden_layer_ready_i = {32{&output_layer_ready_o}};
assign output_layer_valid_i = {3{&hidden_layer_valid_o}};

// Velocity IMU Neurons

lif #(
    .weight_num_p(weight_output_p),
    .weight_hexfile_p(weights_output_neuron_1_p)
) output_lif_vel_imu_x (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .spikes_i(hidden_layer_spikes),
    .valid_i(output_layer_valid_i[0]),
    .ready_o(output_layer_ready_o[0]),
    .spk_o(vel_imu_x),
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
    .spk_o(vel_imu_y),
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
    .spk_o(vel_imu_z),
    .ready_i(output_layer_ready_i[2]),
    .valid_o(output_layer_valid_o[2])
);

assign valid_o = &output_layer_valid_o;
assign ready_o = &input_layer_ready_o;

endmodule
