module spiking_neural_net (
    input clk_i,
    input resetn_i,

    //input currents
    input [31:0] euler_imu_xp,
    input [31:0] euler_imu_xn,
    input [31:0] euler_imu_yp,
    input [31:0] euler_imu_yn,
    input [31:0] euler_imu_zp,
    input [31:0] euler_imu_zn,
    
    input [31:0] position_xp,
    input [31:0] position_xn,
    input [31:0] position_yp,
    input [31:0] position_yn,
    input [31:0] position_zp,
    input [31:0] position_zn,

    //output spikes
    output vel_imu_xp,
    output vel_imu_xn,
    output vel_imu_yp,
    output vel_imu_yn,
    output vel_imu_zp,
    output vel_imu_zn
);

logic [11:0] input_layer_spikes;
logic [31:0] hidden_layer_current [63:0];
logic [11:0] hidden_layer_spikes;
logic [31:0] output_layer_current [5:0];

// Euler IMU Neurons

lif_neuron input_lif_euler_imu_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_xp),
    .spk_o(input_layer_spikes[0])
);

lif_neuron input_lif_euler_imu_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_xn),
    .spk_o(input_layer_spikes[1])
);

lif_neuron input_lif_euler_imu_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_yp),
    .spk_o(input_layer_spikes[2])
);

lif_neuron input_lif_euler_imu_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_yn),
    .spk_o(input_layer_spikes[3])
);

lif_neuron input_lif_euler_imu_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_zp),
    .spk_o(input_layer_spikes[4])
);

lif_neuron input_lif_euler_imu_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(euler_imu_zn),
    .spk_o(input_layer_spikes[5])
);

// Position Neurons

lif_neuron input_lif_position_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_xp),
    .spk_o(input_layer_spikes[6])
);

lif_neuron input_lif_position_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_xn),
    .spk_o(input_layer_spikes[7])
);

lif_neuron input_lif_position_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_yp),
    .spk_o(input_layer_spikes[8])
);

lif_neuron input_lif_position_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_yn),
    .spk_o(input_layer_spikes[9])
);

lif_neuron input_position_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_zp),
    .spk_o(input_layer_spikes[10])
);

lif_neuron input_position_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(position_zn),
    .spk_o(input_layer_spikes[11])
);

genvar hidden_neuron;
generate
    for(hidden_neuron = 0; hidden_neuron < 12; hidden_neuron++) begin : input_layer
        lif_neuron input_lif (
            .clk_i(clk_i),
            .resetn_i(resetn_i),
            .current_i(hidden_layer_current[hidden_neuron]),
            .spk_o(hidden_layer_spikes[hidden_neuron])
        );
    end
endgenerate

// Velocity IMU Neurons

lif_neuron input_lif_vel_imu_xp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[0]),
    .spk_o(vel_imu_xp)
);

lif_neuron input_lif_vel_imu_xn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[1]),
    .spk_o(vel_imu_xn)
);

lif_neuron input_lif_vel_imu_yp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[2]),
    .spk_o(vel_imu_yp)
);

lif_neuron input_lif_vel_imu_yn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[3]),
    .spk_o(vel_imu_yn)
);

lif_neuron input_lif_vel_imu_zp (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[4]),
    .spk_o(vel_imu_zp)
);

lif_neuron input_lif_vel_imu_zn (
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(output_layer_current[5]),
    .spk_o(vel_imu_zn)
);

//Weight Calculations

endmodule
