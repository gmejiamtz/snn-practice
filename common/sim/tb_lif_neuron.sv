`timescale 1ns/1ps

module tb_lif_neuron;

    // Clock and reset
    reg clk;
    reg resetn;
    reg [31:0] current_i;
    reg spk_o;
    int error;
    lif_neuron dut (
        .clk_i(clk),
        .resetn_i(resetn),
        .current_i(current_i),
        .spk_o(spk_o)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut(); begin
        resetn = 0;
        error = 0;
        repeat (10) begin
            @(posedge clk);
        end
        @(negedge clk);
        resetn = 1;
        @(posedge clk);
    end
    endtask

    task send_current(input logic[31:0] current); begin
        @(negedge clk);
        current_i = current;
        @(posedge clk);
    end
    endtask

    task check_spike(input logic spike_status); begin
        if(spike_status != spk_o) begin
            error++;
            $display("Spike Status %b did not match LIF status %b | error count: %d", spike_status,spk_o,error);
        end else begin
            $display("Correct Spike Behavior!");
        end
    end
    endtask

    // Example test sequence
    initial begin
        reset_dut();
        send_current(32'd100);
        check_spike(1'b0);
        $finish;
    end

endmodule

