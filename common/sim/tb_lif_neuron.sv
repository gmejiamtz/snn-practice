`timescale 1ns/1ps

module tb_lif_neuron;

    // Clock and reset
    reg clk;
    reg resetn;
    reg [31:0] current_i;
    reg valid_i;
    reg valid_o;
    reg ready_i;
    reg ready_o;
    reg spk_o;
    int error;
    lif_neuron dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .current_i(current_i),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .spk_o(spk_o),
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
        valid_i = 1;
        @(posedge clk);
        @(negedge clk);
        valid_i = 0;
    end
    endtask
    
    task wait_cycles(input int n); begin
        repeat (n) begin
            @(posedge clk);
        end
    end
    endtask
    
    task read_neuron(); begin
        if(valid_o) begin
            @(negedge clk);
            ready_i = 1;
            @(posedge clk);
            $display("At time: %d | Spike Status: %b",$time, spk_o);
            @(negedge clk);
            ready_i = 0;
        end else begin
            $display("Not valid data yer");
        end
    end
    endtask

    // Example test sequence
    initial begin
        reset_dut();
        send_current(32'd100);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        send_current(32'd00);
        read_neuron();
        wait_cycles(5);
        send_current(32'd4351);
        read_neuron();
        send_current(32'd51);
        read_neuron();
        send_current(32'd401);
        read_neuron();
        send_current(32'd900);
        read_neuron();
        send_current(32'd1500);
        read_neuron();
        send_current(32'd1987);
        read_neuron();
        send_current(32'd1500);
        read_neuron();
        send_current(32'd1500);
        read_neuron();
        send_current(32'd1500);
        read_neuron();
        wait_cycles(3);
        send_current(32'd0);
        wait_cycles(10);
        read_neuron();
        send_current(32'd10000);
        wait_cycles(200);
        read_neuron();
        wait_cycles(3);
        $display("Sim over");
        $finish;
    end

endmodule
