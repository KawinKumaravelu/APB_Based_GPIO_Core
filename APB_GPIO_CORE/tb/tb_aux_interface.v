

`timescale 1ns/1ps

module tb_aux_interface;

    reg        sys_clk;
    reg        sys_rst;
    reg [31:0] aux_in;
    wire [31:0] aux_i;

    // Instantiate the DUT
    aux_interface dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .aux_in(aux_in),
        .aux_i(aux_i)
    );

    // Clock generation
    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk; // 10 ns clock period

    initial begin
        $display("Starting AUX Interface Testbench");

        // Initialize inputs
        sys_rst = 1;
        aux_in = 32'h00000000;

        // Apply reset
        #10;
        sys_rst = 0;

        // Apply test vectors
        #10 aux_in = 32'hA5A5A5A5;
        #10 aux_in = 32'h5A5A5A5A;
        #10 aux_in = 32'hFFFFFFFF;
        #10 aux_in = 32'h00000000;

        // Apply reset during operation
        #10 sys_rst = 1;
        #10 sys_rst = 0;

        #20;
        $stop;
    end

endmodule
