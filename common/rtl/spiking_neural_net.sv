module spiking_neural_net (
    input clk_i,
    input resetn_i,
    input valid_i,

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


    output valid_o
);

logic [3:0] input_layer_spikes;
logic [3:0] input_layer_valid_o;
logic [31:0] hidden_layer_current [31:0];
logic [31:0] hidden_layer_spikes;
logic [0:0] hidden_layer_valid_i;
logic [31:0] hidden_layer_valid_o;
logic [31:0] output_layer_current [2:0];
logic [0:0] output_layer_valid_i;
logic [2:0] output_layer_valid_o;

// Euler IMU Neurons

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

always_comb begin : hidden_layer_current_calculation
    for(integer i = 0; i < 64; i++;) begin
        hidden_layer_current[i] = 
    end
end

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
