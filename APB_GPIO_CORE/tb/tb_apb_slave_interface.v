`timescale 1ns/1ps

module tb_apb_slave_interface;

    reg pclk, presetn, psel, penable, pwrite;
    reg [31:0] paddr;
    reg [31:0] pwdata;
    reg gpio_inta_o;
    reg [31:0] gpio_dat_o;
    wire [31:0] gpio_dat_i, prdata;
    wire pready, sys_clk, sys_rst, gpio_we;
    wire [31:0] gpio_addr;
    wire irq;

    apb_slave_interface DUT (
        .pclk(pclk),
        .presetn(presetn),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .gpio_inta_o(gpio_inta_o),
        .gpio_dat_o(gpio_dat_o),
        .gpio_dat_i(gpio_dat_i),
        .prdata(prdata),
        .pready(pready),
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .gpio_we(gpio_we),
        .gpio_addr(gpio_addr),
        .irq(irq)
    );

    // Clock generation
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

    // Reset task
    task r;
    begin
        @(negedge pclk);
        presetn = 0;
        @(negedge pclk);
        presetn = 1;
    end
    endtask

    // APB Write task
    task in;
        input p, q, r;
        input [3:0] pa;
        input [31:0] pw;
    begin
        @(negedge pclk);
        psel    = p;
        penable = q;
        pwrite  = r;
        paddr   = pa;
        pwdata  = pw;
    end
    endtask

    // APB Read response task
    task res;
        input [31:0] g;
        input a;
    begin
        @(negedge pclk);
        gpio_dat_o = g;
        gpio_inta_o = a;
    end
    endtask

    // Test sequence
    initial begin
        r;
        in(1'b1, 1'b0, 1'b1, 4'h2, 32'h45678971); // Write
        #50;
        res(32'h0, 1'b0);

        in(1'b1, 1'b1, 1'b1, 4'h2, 32'h45678912); // Write
        #10;
        in(1'b1, 1'b1, 1'b0, 4'h2, 32'h12345678); // Read
        #10;
        $stop;
    end

endmodule
