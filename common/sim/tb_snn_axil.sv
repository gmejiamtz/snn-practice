`timescale 1ns/1ps

module tb_snn_axil;

    // Clock and reset
    reg M00_ACLK;
    reg M00_ARESETN;

    // AXI Lite signals
    wire  [31:0] M00_axi_awaddr; //out
    wire  [2:0]  M00_axi_awprot; //out
    wire         M00_axi_awvalid;    //out
    reg        M00_axi_awready; //in

    wire  [31:0] M00_axi_wdata;    //out
    wire  [3:0]    M00_axi_wstrb;    //out
    wire           M00_axi_wvalid;   //out
    reg          M00_axi_wready;    //in

    reg [1:0]  M00_axi_bresp;   //in
    reg        M00_axi_bvalid;  //in
    wire         M00_axi_bready; //out

    wire  [31:0] M00_axi_araddr; //out
    wire  [2:0]  M00_axi_arprot; //out
    wire         M00_axi_arvalid;    //out
    reg        M00_axi_arready; //in

    reg [31:0] M00_axi_rdata;   //in
    reg [1:0]  M00_axi_rresp;   //in
    reg        M00_axi_rvalid;  //in
    wire         M00_axi_rready; //out

    // Instantiate the DUT
    snn_axil dut (
        .M00_ACLK(M00_ACLK),
        .M00_ARESETN(M00_ARESETN),

        .M00_axi_awaddr(M00_axi_awaddr),
        .M00_axi_awprot(M00_axi_awprot),
        .M00_axi_awvalid(M00_axi_awvalid),
        .M00_axi_awready(M00_axi_awready),

        .M00_axi_wdata(M00_axi_wdata),
        .M00_axi_wstrb(M00_axi_wstrb),
        .M00_axi_wvalid(M00_axi_wvalid),
        .M00_axi_wready(M00_axi_wready),

        .M00_axi_bresp(M00_axi_bresp),
        .M00_axi_bvalid(M00_axi_bvalid),
        .M00_axi_bready(M00_axi_bready),

        .M00_axi_araddr(M00_axi_araddr),
        .M00_axi_arprot(M00_axi_arprot),
        .M00_axi_arvalid(M00_axi_arvalid),
        .M00_axi_arready(M00_axi_arready),

        .M00_axi_rdata(M00_axi_rdata),
        .M00_axi_rresp(M00_axi_rresp),
        .M00_axi_rvalid(M00_axi_rvalid),
        .M00_axi_rready(M00_axi_rready)
    );

    // Clock generation: 10ns period
    initial begin
        M00_ACLK = 0;
        forever #5 M00_ACLK = ~M00_ACLK;
    end

    // Reset generation
    initial begin
        M00_ARESETN = 0;
        repeat (10) @(posedge M00_ACLK);
        M00_ARESETN = 1;
    end

    // Initialize outputs
    initial begin
        M00_axi_awready = 0;
        M00_axi_wready = 0;
        M00_axi_bresp = 0;
        M00_axi_bvalid = 0;
        M00_axi_arready = 0;
        M00_axi_rdata = 0;
        M00_axi_rresp = 0;
        M00_axi_rvalid = 0;
    end

    task axi_aw_transaction(); begin
        @(negedge M00_ACLK);
        M00_axi_awready = 1;
        @(posedge M00_ACLK);
        $display("AW Ready");
        @(negedge M00_ACLK);
        $display("AW Over");
        M00_axi_awready = 0;
    end
    endtask
    
    task axi_ar_transaction(input [7:0] data); begin
        @(negedge M00_ACLK);
        M00_axi_arready = 1;
        @(posedge M00_ACLK);
        $display("AR Ready");
        @(negedge M00_ACLK);
        $display("Read Valid");
        M00_axi_rvalid = 1;
        M00_axi_rdata = data;
        @(posedge M00_ACLK);
        $display("Read Transaction Occuring");
        @(negedge M00_ACLK);
        $display("AR Over");
        M00_axi_arready = 0;
        M00_axi_rvalid = 0;
        M00_axi_rdata = 0;
    end
    endtask
 
    // Example test sequence
    initial begin

        @(posedge M00_ARESETN);
        axi_ar_transaction(8'h67);
        repeat (5) @(posedge M00_ACLK);
        axi_aw_transaction();
        repeat (5) @(posedge M00_ACLK);
        $display("Simulation Done");

        $finish;
    end

endmodule

