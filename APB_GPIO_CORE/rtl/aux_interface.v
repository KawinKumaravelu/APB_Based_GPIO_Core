module aux_interface (
    input  sys_clk,
    input  sys_rst,
    input  wire [31:0] aux_in,
    output wire [31:0] aux_i
	 
);

    reg [31:0] aux_reg;

    always @(posedge sys_clk or posedge sys_rst) begin
        if (sys_rst)
            aux_reg <= 32'b0;
        else
            aux_reg <= aux_in;
    end

    assign aux_i = aux_reg;

endmodule