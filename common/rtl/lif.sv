module lif #(
    parameter weight_num_p = 6,
    parameter string weight_hexfile_p = "test.hex"
    ) (
    input clk_i,
    input resetn_i,
    input [weight_num_p-1:0] spikes_i, //hidden layer takes from 6 input layer
    input valid_i,        //all the spikes are valid
    output ready_o,       //can take in these spikes
    input ready_i,        //downstream LIF can take current
    output valid_o,       //calculated current into downstream LIF is valid
    output spike_o
);

logic acc_valid_o, acc_ready_o, acc_valid_i, acc_ready_i;
logic neuron_ready_o, neuron_valid_o, neuron_ready_i, neuron_valid_i;
logic [31:0] current_o;

current_acc #(
    .weight_num_p(weight_num_p),
    .weight_hexfile_p(weight_hexfile_p)
) acc_inst(
        .clk_i(clk_i),
        .resetn_i(resetn_i),
        .valid_i(acc_valid_i),
        .ready_o(acc_ready_o),
        .spikes_i(spikes_i),
        .valid_o(acc_valid_o),
        .ready_i(acc_ready_i),
        .current_o(current_o)
);

lif_neuron neuron(
    .clk_i(clk_i),
    .resetn_i(resetn_i),
    .current_i(current_o),
    .valid_i(neuron_valid_i),
    .ready_o(neuron_ready_o),
    .spk_o(spike_o),
    .valid_o(neuron_valid_o),
    .ready_i(neuron_ready_i)
);

assign acc_valid_i = valid_i;
assign acc_ready_i = neuron_ready_o;
assign neuron_valid_i = acc_valid_o;
assign neuron_ready_i = ready_i;

assign valid_o = neuron_valid_o;
assign ready_o = acc_ready_o;

endmodule