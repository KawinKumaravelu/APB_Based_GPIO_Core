`timescale 1ns / 1ps

module tb_GPIO_top;

    // Clock and Reset
    reg pclk;
    reg presetn;

    // APB signals
    reg psel;
    reg penable;
    reg pwrite;
    reg [3:0] paddr;
    reg [31:0] pwdata;
    wire [31:0] prdata;
    wire pready;
    wire irq;

    // AUX and IO
    reg [31:0] aux_in;
    reg ext_clk_pad_i;
    wire [31:0] io_pad;

    // IO pad simulation
    reg [31:0] io_drive;
    reg        io_dir;
    assign io_pad = io_dir ? io_drive : 32'bz;

    // Instantiate DUT
    GPIO_top dut (
        .pclk(pclk),
        .presetn(presetn),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .irq(irq),
        .aux_in(aux_in),
        .ext_clk_pad_i(ext_clk_pad_i),
        .io_pad(io_pad)
    );

    // Clock generation
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

    // External clock
    initial begin
        ext_clk_pad_i = 0;
        forever #7 ext_clk_pad_i = ~ext_clk_pad_i;
    end

    // Reset
    task reset;
    begin
        presetn = 0;
        #20;
        presetn = 1;
    end
    endtask

    // APB Write Task
    task apb_write(input [3:0] addr, input [31:0] data);
    begin
        @(posedge pclk);
        psel = 1;
        pwrite = 1;
        penable = 0;
        paddr = addr;
        pwdata = data;
        @(posedge pclk);
        penable = 1;
        @(posedge pclk);
        psel = 0;
        penable = 0;
    end
    endtask

    // APB Read Task
    task apb_read(input [3:0] addr);
    begin
        @(posedge pclk);
        psel = 1;
        pwrite = 0;
        penable = 0;
        paddr = addr;
        @(posedge pclk);
        penable = 1;
        @(posedge pclk);
        psel = 0;
        penable = 0;
    end
    endtask

    task drive_io(input [31:0] value);
    begin
        io_dir = 1;
        io_drive = value;
    end
    endtask

    task release_io;
    begin
        io_dir = 0;
    end
    endtask

    // Test sequence
    initial begin
        // Initialize
        psel = 0; penable = 0; pwrite = 0;
        paddr = 4'b0; pwdata = 32'b0;
        aux_in = 32'hABCD_EF01;
        io_dir = 0;
        io_drive = 32'b0;

        // Reset the system
        reset;

        // Drive IO for sampling
        drive_io(32'h1122_3344);

        // Write values to various GPIO registers
        apb_write(4'h1, 32'hA5A5_A5A5);  // OUT
        apb_write(4'h2, 32'hFFFF_0000);  // OE
        apb_write(4'h3, 32'h0000_FFFF);  // INTE
        apb_write(4'h4, 32'hFFFF_FFFF);  // PTRIG
        apb_write(4'h5, 32'h0000_FFFF);  // AUX
        apb_write(4'h6, 32'b11);         // CTRL
        apb_write(4'h8, 32'h0000_0001);  // ECLK
        apb_write(4'h9, 32'h0000_0000);  // NEC

        // Release IO for input sampling
        release_io;

        // Read back the input register
        apb_read(4'h0);

        // Wait and finish
        #100;
        $finish;
    end

endmodule
