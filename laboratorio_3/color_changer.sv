module color_changer (
    input  logic clk,
    input  logic reset,
    input  logic tick,           // Señal de avance desde color_timer
    input  logic blank_b,        // Solo pintar en región activa
    output logic [7:0] r, g, b
);
    logic [2:0] color_index;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            color_index <= 0;
        else if (tick)
            color_index <= color_index + 1;
    end

    always_comb begin
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;

        if (blank_b) begin
            case (color_index)
                3'd0: r = 8'hFF;
                3'd1: g = 8'hFF;
                3'd2: b = 8'hFF;
                3'd3: begin r = 8'hFF; g = 8'hFF; end
                3'd4: begin g = 8'hFF; b = 8'hFF; end
                3'd5: begin r = 8'hFF; b = 8'hFF; end
                3'd6: begin r = 8'hFF; g = 8'hFF; b = 8'hFF; end
                default: ; // Negro
            endcase
        end
    end
endmodule
