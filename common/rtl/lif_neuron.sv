module lif_neuron #(
    parameter logic [31:0] threshold_p = 31'd2000
    )(
    input wire          clk_i,
    input wire          resetn_i,
    input wire          run_i,      //controlled by the user - should be tied high normally
    input logic [31:0]  current_i,
    output logic        spk_o,
    output logic        done_o      //passing thru the run signal downstream always
);

    logic [31:0] state_d, state_q;

    always @(posedge clk_i) begin
        if(!resetn_i) begin
            state_q <= 0;
            done_o <= 1;
        end else begin
            state_q <= state_d;
            done_o <= run_i;
        end    
    end

    always_comb begin : spiking_logic
        spk_o = (state_q >= threshold_p);
        if(spk_o) begin
            state_d = '0;
        end else begin
            if(run_i) begin
                state_d = current_i + (spk_o ? 32'b0 : (state_q >> 32'b1));
            end else begin
                state_d = state_q;  //default to state being held
            end
        end
    end

endmodule