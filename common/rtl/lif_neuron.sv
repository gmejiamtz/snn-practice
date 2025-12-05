module lif_neuron #(
    parameter logic signed [31:0] threshold_p = 32'sd65536
    )(
    input wire          clk_i,
    input wire          resetn_i,
    input wire          valid_i,
    output logic        ready_o,
    input logic signed [31:0]  current_i,
    output logic        spk_o,
    output logic        valid_o,
    input logic         ready_i
);

    typedef enum logic [1:0] { idle, compute, done } state_t;

    logic signed [31:0] membrane_d, membrane_q;
    logic signed [31:0] current_reg;

    state_t state_d,state_q;
    logic valid_d,valid_q;
    logic ready_d,ready_q;
    logic spk_d, spk_q;

    always @(posedge clk_i) begin
        if(!resetn_i) begin
            state_q <= idle;
            ready_q <= '0;
            valid_q <= '0;
            spk_q <= '0;
        end else begin
            state_q <= state_d;
            ready_q <= ready_d;
            valid_q <= valid_d;
            spk_q <= spk_d;
        end
    end

    always @(posedge clk_i) begin
        if(!resetn_i) begin
            membrane_q <= 0;
        end else begin
            membrane_q <= membrane_d;
        end
    end

    always @(posedge clk_i) begin
        if(!resetn_i) begin
            current_reg <= 0;
        end else if(ready_o & valid_i) begin
            current_reg <= current_i;
        end
    end

    always_comb begin : spiking_logic
        membrane_d = membrane_q;  //default to state being held
        valid_d = valid_q;
        spk_d = spk_q;
        ready_d = ready_q;
        state_d = state_q;

        case (state_q)

            idle: begin
                valid_d = 1'b0;
                ready_d = 1'b1;
                membrane_d = membrane_q;
                spk_d = spk_q;
                if(valid_i & ready_o) begin
                    state_d = compute;
                end else begin
                    state_d = idle;
                end
            end

            compute: begin
                valid_d = 1'b0;
                ready_d = 1'b0;
                membrane_d = current_reg + (membrane_q >>> 32'b1);
                if(membrane_d >= threshold_p) begin
                    spk_d = 1'b1;
                    state_d = done;
                end else begin
                    spk_d = 1'b0;
                    state_d = done;
                end
            end

            done: begin
                valid_d = 1'b1;
                ready_d = 1'b0;
                if(spk_o) begin
                    membrane_d = '0;
                end else begin
                    membrane_d = membrane_q;
                end
                if(ready_i & valid_o) begin
                    state_d = idle;
                end else begin
                    state_d = done;
                end
            end

            default: begin
                membrane_d = membrane_q;  //default to state being held
                valid_d = valid_q;
                spk_q = spk_d;
                ready_d = ready_q;
                state_d = state_q;
            end
        endcase

    end

    assign spk_o = spk_q;
    assign valid_o = valid_q;
    assign ready_o = ready_q;

endmodule