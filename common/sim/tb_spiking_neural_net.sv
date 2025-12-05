`timescale 1ns/1ps

module tb_spiking_neural_net;

    // Clock and reset
    reg clk;
    reg resetn;
    reg valid_i;
    reg valid_o;
    reg ready_i;
    reg ready_o;
    logic [31:0] euler_imu_x_i;
    logic [31:0] euler_imu_y_i;
    logic [31:0] euler_imu_z_i;
    logic [31:0] position_x_i;
    logic [31:0] position_y_i;
    logic [31:0] position_z_i;
    logic vel_imu_x_o;
    logic vel_imu_y_o;
    logic vel_imu_z_o;
    int error;
    spiking_neural_net #(
      .weights_hidden_neuron_1_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_2_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_3_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_4_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_5_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_6_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_7_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_8_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_9_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_10_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_11_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_12_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_13_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_14_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_15_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_16_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_17_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_18_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_19_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_20_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_21_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_22_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_23_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_24_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_25_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_26_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_27_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_28_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_29_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_30_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_31_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_hidden_neuron_32_p("/home/gary/Documents/snn-practice/common/util/test.hex"),
      .weights_output_neuron_1_p("/home/gary/Documents/snn-practice/common/util/test1.hex"),
      .weights_output_neuron_2_p("/home/gary/Documents/snn-practice/common/util/test1.hex"),
      .weights_output_neuron_3_p("/home/gary/Documents/snn-practice/common/util/test1.hex")
     ) dut(
        .clk_i(clk),
        .resetn_i(resetn),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .euler_imu_x(euler_imu_x_i),
        .euler_imu_y(euler_imu_y_i),
        .euler_imu_z(euler_imu_z_i),
        .position_x(position_x_i),
        .position_y(position_y_i),
        .position_z(position_z_i),
        .vel_imu_x(vel_imu_x_o),
        .vel_imu_y(vel_imu_y_o),
        .vel_imu_z(vel_imu_z_o),
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
        euler_imu_x_i = '0;
        euler_imu_y_i = '0;
        euler_imu_z_i = '0;
        position_x_i = '0;
        position_y_i = '0;
        position_z_i = '0;
        repeat (10) begin
            @(posedge clk);
        end
        @(negedge clk);
        resetn = 1;
        @(posedge clk);
    end
    endtask

    task send_data(
        input logic[31:0] imu_x,
        input logic[31:0] imu_y,
        input logic[31:0] imu_z,
        input logic[31:0] position_x,
        input logic[31:0] position_y,
        input logic[31:0] position_z
    ); begin
        @(negedge clk);
        euler_imu_x_i = imu_x;
        euler_imu_y_i = imu_y;
        euler_imu_z_i = imu_z;
        position_x_i = position_x;
        position_y_i = position_y;
        position_z_i = position_z;
        valid_i = 1;
        @(posedge clk);
        @(negedge clk);
        valid_i = 0;
    end
    endtask

    task wait_till_done(); begin
        while(!valid_o) begin
            @(posedge clk);
        end
        $display("At time: %d | SNN Spike Output: %b",$time, {vel_imu_z_o,vel_imu_y_o,vel_imu_x_o});
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
        wait_cycles(10);
        wait_cycles(10);
        $finish;
    end

endmodule

