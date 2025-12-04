module lif_neuron #(
    parameter logic [31:0] threshold_p = 31'd2000
    )(
    input wire          clk_i,
    input wire          resetn_i,
    input wire          valid_i,      //controlled by the user - should be tied high normally
    input logic [31:0]  current_i,
    output logic        spk_o,
    output logic        valid_o      //passing thru the run signal downstream always
);

    logic [31:0] state_d, state_q;

    always @(posedge clk_i) begin
        if(!resetn_i) begin
            state_q <= 0;
        end else if (valid_i) begin
            state_q <= state_d;
        end
    end

    always_comb begin : spiking_logic
        state_d = state_q;  //default to state being held
        spk_o = 0;
        valid_o = 0;
        if(valid_i) begin
            spk_o = (state_q >= threshold_p);
            valid_o = 1;
            if(spk_o) begin
                state_d = '0;
            end else begin
                state_d = current_i + (spk_o ? 32'b0 : (state_q >> 32'b1));
            end
        end
    end

endmodule