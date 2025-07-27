`timescale 1ns/1ps

module tb_gpio_register;

    reg         sys_clk;
    reg         sys_rst;
    reg         gpio_we;
    reg  [31:0] gpio_addr;
    reg  [31:0] gpio_dat_i;
    reg  [31:0] aux_i;
    reg  [31:0] in_pad_i;
    reg         gpio_eclk;

    wire        gpio_inta_o;
    wire [31:0] gpio_dat_o;
    wire [31:0] out_pad_o;
    wire [31:0] oen_padoe_o;

    // Instantiate DUT
    GPIO_register dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_we(gpio_we),
        .gpio_addr(gpio_addr),
        .gpio_dat_i(gpio_dat_i),
        .aux_i(aux_i),
        .in_pad_i(in_pad_i),
        .gpio_eclk(gpio_eclk),
        .gpio_inta_o(gpio_inta_o),
        .gpio_dat_o(gpio_dat_o),
        .out_pad_o(out_pad_o),
        .oen_padoe_o(oen_padoe_o)
    );

    // Clock generation
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

    // ECLK generation (external clock)
    initial begin
        gpio_eclk = 0;
        forever #7 gpio_eclk = ~gpio_eclk;  // not synced with sys_clk
    end

    // Test sequence
    initial begin
        $display("Starting GPIO Register Testbench");
        gpio_we = 0;
        gpio_addr = 0;
        gpio_dat_i = 0;
        aux_i = 0;
        in_pad_i = 0;
        sys_rst = 1;

        #10 sys_rst = 0;
        #10 sys_rst = 1;

        // Test writing to RGPIO_OUT
        gpio_we = 1;
        gpio_addr = 32'h04;  // RGPIO_OUT
        gpio_dat_i = 32'hAAAAAAAA;
        #10 gpio_we = 0;

        // Test writing to RGPIO_OE
        gpio_we = 1;
        gpio_addr = 32'h08;  // RGPIO_OE
        gpio_dat_i = 32'hFFFFFFFF;
        #10 gpio_we = 0;

        // Test writing to RGPIO_AUX
        gpio_we = 1;
        gpio_addr = 32'h14;  // RGPIO_AUX
        gpio_dat_i = 32'hFFFFFFFF;
        aux_i = 32'h12345678;
        #10 gpio_we = 0;

        // Test reading back RGPIO_OUT
        gpio_we = 0;
        gpio_addr = 32'h04;
        #10;

        // Simulate input pad value and test interrupt trigger
        gpio_we = 1;
        gpio_addr = 32'h0C;  // RGPIO_INTE
        gpio_dat_i = 32'h00000001;
        #10;

        gpio_addr = 32'h10;  // RGPIO_PTRIG
        gpio_dat_i = 32'h00000001;
        #10 gpio_we = 0;

        // Apply rising edge to bit 0 of in_pad_i
        in_pad_i = 32'h00000000;
        #10 in_pad_i = 32'h00000001;

        // Let the system run
        #50;

        $stop;
    end

endmodule
