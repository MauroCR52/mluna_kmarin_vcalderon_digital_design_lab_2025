module vga_controller #(
    parameter HACTIVE = 10'd640,
    HFP = 10'd16,
    HSYN = 10'd96,
    HBP = 10'd48,
    HMAX = HACTIVE + HFP + HSYN + HBP,
    VACTIVE = 10'd480,
    VFP = 10'd11,
    VSYN = 10'd2,
    VBP = 10'd32,
    VMAX = VACTIVE + VFP + VSYN + VBP
)(
    input  logic vgaclk,
    input  logic reset,
    output logic hsync, vsync, sync_b, blank_b,
    output logic [9:0] x, y
);

    logic [9:0] x_reg = 0;
    logic [9:0] y_reg = 0;

    always_ff @(posedge vgaclk or posedge reset) begin
        if (reset) begin
            x_reg <= 0;
            y_reg <= 0;
        end else begin
            if (x_reg == HMAX - 1) begin
                x_reg <= 0;
                if (y_reg == VMAX - 1)
                    y_reg <= 0;
                else
                    y_reg <= y_reg + 1;
            end else begin
                x_reg <= x_reg + 1;
            end
        end
    end

    assign x = x_reg;
    assign y = y_reg;

    assign hsync   = ~(x_reg >= HACTIVE + HFP && x_reg < HACTIVE + HFP + HSYN);
    assign vsync   = ~(y_reg >= VACTIVE + VFP && y_reg < VACTIVE + VFP + VSYN);
    assign sync_b  = hsync & vsync;
    assign blank_b = (x_reg < HACTIVE) && (y_reg < VACTIVE);

endmodule
