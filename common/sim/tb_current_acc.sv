`timescale 1ns/1ps

module tb_current_acc;

    // Clock and reset
    reg clk;
    reg resetn;
    reg [31:0] current_o;
    reg valid_i;
    reg valid_o;
    reg ready_i;
    reg ready_o;
    reg [5:0] spikes_i;
    int error;
    current_acc #(
      .weight_hexfile_p("/home/gary/Documents/snn-practice/common/util/test.hex")
    ) dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .spikes_i(spikes_i),
        .valid_o(valid_o),
        .ready_i(ready_i),
        .current_o(current_o)
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

    task read_current_o(); begin
        @(negedge clk);
        ready_i = 1;
        @(posedge clk);
        if(!valid_o) begin
            $display("ACC NOT DONE");
        end else begin
            $display("ACC OUTPUTS CURRENT: %h", current_o);
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
        $finish;
    end

endmodule

