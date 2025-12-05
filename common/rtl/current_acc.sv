module current_acc #(
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
    output [31:0] current_o
);

typedef enum logic [1:0] { idle, acc, done } state_t;

logic [31:0] current_d, current_q;
logic valid_d,valid_q;
logic ready_d,ready_q;
state_t state_d, state_q;
logic [weight_num_p - 1:0] spikes_reg;
logic [$clog2(weight_num_p)-1:0] spike_count_q, spike_count_d;
logic reset_count;

//weight memory
logic [31:0] weight [0:weight_num_p-1];
initial begin
    $readmemh(weight_hexfile_p,weight);
end

always_ff @(posedge clk_i) begin
    if(~resetn_i) begin
        state_q <= idle;
        valid_q <= 0;
        ready_q <= 1;
        current_q <= 'b0;
    end else begin
        state_q <= state_d;
        valid_q <= valid_d;
        ready_q <= ready_d;
        current_q <= current_d;
    end
end

always_ff @(posedge clk_i) begin
    if(~resetn_i) begin
        spikes_reg <= 'b0;
    end else if(ready_o & valid_i) begin
        spikes_reg <= spikes_i;
    end
end

always_ff @(posedge clk_i) begin
    if(~resetn_i) begin
        spike_count_q <= 'b0;
    end else begin
        spike_count_q <= spike_count_d;
    end
end

always_comb begin : next_state
    state_d = state_q;
    ready_d = ready_q;
    valid_q = valid_d;
    current_d = current_q;
    spike_count_d = spike_count_q;
    reset_count = 1'b0;
    case (state_q)
        idle: begin
            ready_d = 1'b1;
            valid_d = 1'b0;
            //hold spike count at 0
            reset_count = 1'b1;
            if(valid_i & ready_o) begin
                state_d = acc;
            end else begin
                state_d = idle;
            end
        end

        acc: begin
            ready_d = 0;
            valid_d = 0;
            spike_count_d = spike_count_q + 1;
            current_d = current_q + (spikes_reg[spike_count_q] ? weight[spike_count_q] : 32'h0);
            //if we gonna overflow then go to next state cuz we done
            if(spike_count_d == weight_num_p) begin
                state_d = done;
            end else begin
                state_d = acc;
            end
        end

        done: begin
            //im not ready to take new things until someone takes my current data
            ready_d = 1'b0;
            //our data is valid tho
            valid_d = 1'b1;
            current_d = current_q;
            //if downstream can take it send it down
            if(ready_i & valid_o) begin
                //always gonna send to idle just to give a state for acc to be ready to take in
                state_d = idle;
            end else begin
                state_d = done;
            end
        end

        default: begin
            state_d = state_q;
            ready_d = ready_q;
            valid_q = valid_d;
        end
    endcase
end
    
assign ready_o = ready_q;
assign valid_o = valid_q;
assign current_o = current_q;

endmodule