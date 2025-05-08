module vga_top(
    input  logic clk,  // Entrada de 50 MHz de la placa
    input  logic reset,
	 output logic vgaclk,
    output logic hsync, vsync, sync_b, blank_b,
    output logic [7:0] r, g, b
);

    logic locked;
    logic [9:0] x, y;

    // Clock VGA mediante PLL
    pll25 vgapll(
        .refclk(clk), 
        .rst(1'b0), 
        .outclk_0(vgaclk), 
        .locked()
    );

    // Instancia del controlador VGA
    vga_controller vga_ctrl (
        .vgaclk(vgaclk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .x(x),
        .y(y)
    );

    // Color changer
    logic [25:0] color_counter = 0;
    logic [2:0] color_index = 0;

    logic tick;

	color_toggle timer_inst (
		 .clk(vgaclk),
		 .reset(reset),
		 .tick(tick)
	);

	color_changer color_inst (
		 .clk(vgaclk),
		 .reset(reset),
		 .tick(tick),
		 .blank_b(blank_b),
		 .r(r),
		 .g(g),
		 .b(b)
	);


endmodule
