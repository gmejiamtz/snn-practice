`timescale 1ns/1ps

module tb_lif_acc;

    // Clock and reset
    reg clk;
    reg resetn;
    reg valid_i;
    reg valid_o;
    reg ready_i;
    reg ready_o;
    reg [5:0] spikes_i;
    reg [0:0] spike_o;
    int error;
    lif #(
      .weight_hexfile_p("/home/gary/Documents/snn-practice/common/util/test.hex")
    ) dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .spike_i(spike_i),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .spike_o(spike_o),
        .valid_o(valid_o),
        .ready_i(ready_i)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut(); begin
        resetn = 0;
        error = 0;
        valid_i = 0;
        ready_i = 0;
        spikes_i = '0;
        repeat (10) begin
            @(posedge clk);
        end
        @(negedge clk);
        resetn = 1;
        @(posedge clk);
    end
    endtask

    task send_spikes(input logic[5:0] spikes); begin
        @(negedge clk);
        spikes_i = spikes;
        valid_i = 1;
        @(posedge clk);
        @(negedge clk);
        valid_i = 0;
    end
    endtask

    task read_spike_o(); begin
        @(negedge clk);
        ready_i = 1;
        @(posedge clk);
        if(!valid_o) begin
            $display("ACC NOT DONE");
        end else begin
            $display("ACC OUTPUTS SPIKE: %b", spike_o);
        end
        @(negedge clk);
        ready_i = 0;
    end
    endtask
    
    task wait_cycles(input int n); begin
        repeat (n) begin
            @(posedge clk);
        end
    end
    endtask

    // Example test sequence
    initial begin
        reset_dut();
        send_spikes(6'b001011);
        wait_cycles(10);
        read_spike_o();
        wait_cycles(10);
        $finish;
    end

endmodule

