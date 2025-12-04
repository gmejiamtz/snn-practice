`timescale 1ns/1ps

module tb_lif_neuron;

    // Clock and reset
    reg clk;
    reg resetn;
    reg [31:0] current_i;
    reg valid_i;
    reg valid_o;
    reg spk_o;
    int error;
    lif_neuron #(
      .weight_hexfile_p("/home/gary/Documents/snn-practice/common/util/test.hex")
    ) dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .current_i(current_i),
        .valid_i(valid_i),
        .spk_o(spk_o),
        .valid_o(valid_o)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut(); begin
        resetn = 0;
        error = 0;
        valid_i = 1;
        current_i = '0;
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
    
    task wait_cycles(input int n); begin
        repeat (n) begin
            @(posedge clk);
        end
    end
    endtask
    
    task run_neuron(); begin
        valid_i = 1;
    end
    endtask
    
    task stall_neuron(); begin
        valid_i = 0;
    end
    endtask
    
    task check_spike(input logic spike_status); begin
        @(negedge clk);
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
        wait_cycles(5);
        stall_neuron();
        send_current(32'd4351);
        check_spike(1'b0);
        run_neuron();
        send_current(32'd51);
        send_current(32'd401);
        send_current(32'd900);
        send_current(32'd1500);
        send_current(32'd1987);
        send_current(32'd1500);
        send_current(32'd1500);
        send_current(32'd1500);
        wait_cycles(3);
        send_current(32'd0);
        wait_cycles(10);
        send_current(32'd10000);
        wait_cycles(200);
        $finish;
    end

endmodule

