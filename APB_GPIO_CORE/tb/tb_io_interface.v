`timescale 1ns/1ps

module tb_io_interface;

    reg  [31:0] out_pad_o;
    reg  [31:0] oen_padoe_o;
    wire [31:0] in_pad_i;
    wire [31:0] io_pad;

    // Drive the bidirectional io_pad externally for input mode simulation
    reg [31:0] external_drive;
    assign io_pad = (~oen_padoe_o) ? external_drive : 32'bz;


    // Instantiate the DUT
    io_interface dut (
        .out_pad_o(out_pad_o),
        .oen_padoe_o(oen_padoe_o),
        .io_pad(io_pad),
        .in_pad_i(in_pad_i)
    );

    initial begin
        $display("Starting IO Interface Testbench");

        // Set output values
        out_pad_o = 32'hAAAA5555;

        // Test output mode (enable all pins as output)
        oen_padoe_o = 32'hFFFFFFFF;  // all bits are outputs
        #10;

        // Now test input mode (disable all outputs)
        oen_padoe_o = 32'h00000000;  // all bits are inputs
        external_drive = 32'hCAFEBABE;
  // simulate external pin values
        #10;

        // Mixed mode: lower 16 output, upper 16 input
        oen_padoe_o = 32'h0000FFFF;
        out_pad_o = 32'hDEADBEEF;
        external_drive = 32'hCAFEBABE;
        #10;

        $stop;
    end

endmodule
