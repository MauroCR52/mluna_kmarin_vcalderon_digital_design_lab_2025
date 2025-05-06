module video_gen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic blank_b,
    input  logic [1:0] tablero [5:0][6:0],
    input  logic [3:0] state_in,
    input  logic ganadoras [5:0][6:0],
    input  logic color_flag,
    input  logic mostrar_ganador_final,  // ← NUEVO
    input  logic led_j1,                 // ← NUEVO
    input  logic led_j2,                 // ← NUEVO
    output logic [7:0] r, g, b
);

    localparam CELL_WIDTH  = 91;
    localparam CELL_HEIGHT = 80;

    logic [2:0] col;
    logic [2:0] fila;
    logic [9:0] x_in_cell, y_in_cell;
    logic signed [10:0] dx, dy;
    logic inside_circle;
    logic [1:0] ficha;

    assign col = x / CELL_WIDTH;
    assign fila = y / CELL_HEIGHT;
    assign x_in_cell = x % CELL_WIDTH;
    assign y_in_cell = y % CELL_HEIGHT;

    always_comb begin
        r = 8'h00;
        g = 8'h00;
        b = 8'h00;
        dx = 0;
        dy = 0;
        inside_circle = 1'b0;
        ficha = 2'b00;

        if (blank_b) begin
            case (state_in)
                4'd0: begin  // INICIO
                     if (y > 200 && y < 280) begin
                         b = 8'hFF; // franja azul
 
                         // Píxeles aproximados para escribir "START" con bloques (modo pixel-art)
                         if (
                             // S
                             ((x >= 170 && x <= 220) && (y >= 210 && y <= 220)) ||
                             ((x >= 160 && x <= 170) && (y >= 220 && y <= 240)) ||
                             ((x >= 170 && x <= 210) && (y >= 240 && y <= 250)) ||
                             ((x >= 210 && x <= 220) && (y >= 250 && y <= 260)) ||
 									 ((x >= 160 && x <= 210) && (y >= 260 && y <= 270)) ||
 
                             // T
                             ((x >= 230 && x <= 290) && (y >= 210 && y <= 220)) ||
                             ((x >= 255 && x <= 265) && (y >= 220 && y <= 270)) ||
 
                             // A
                             ((x >= 300 && x <= 310) && (y >= 220 && y <= 270)) ||
                             ((x >= 310 && x <= 350) && (y >= 210 && y <= 220)) ||
                             ((x >= 310 && x <= 350) && (y >= 240 && y <= 250)) ||
                             ((x >= 350 && x <= 360) && (y >= 220 && y <= 270)) //||
 
                             // R
                             //((x >= 370 && x <= 380) && (y >= 220 && y <= 270)) ||
                             //((x >= 380 && x <= 390) && (y >= 210 && y <= 220)) ||
                             //((x >= 390 && x <= 400) && (y >= 225 && y <= 245)) ||
                             //((x >= 410 && x <= 420) && (y >= 240 && y <= 245)) ||
 									// ((x >= 430 && x <= 440) && (y >= 245 && y <= 275)) ||
 
                             // T
                            // ((x >= 320 && x <= 350) && (y >= 225 && y <= 235)) ||
                          //  ((x >= 332 && x <= 338) && (y >= 225 && y <= 255))
                         ) begin
                             r = 8'hFF;
                             g = 8'hFF;
                             b = 8'hFF; // blanco
                         end
                     end
                 end

                4'd1: begin // ELEGIR_JUGADOR
                    dx = x - 220;
                    dy = y - 240;
                    if ((dx*dx + dy*dy) < 40*40) begin
                        r = 8'hFF; g = 8'h00; b = 8'h00;
                    end

                    dx = x - 420;
                    dy = y - 240;
                    if ((dx*dx + dy*dy) < 40*40) begin
                        r = 8'hFF; g = 8'hFF; b = 8'h00;
                    end
                end

                4'd2, 4'd3, 4'd4, 4'd5, 4'd6: begin
                    if (fila < 6 && col < 7)
                        ficha = tablero[fila][col];

                    dx = x_in_cell - (CELL_WIDTH / 2);
                    dy = y_in_cell - (CELL_HEIGHT / 2);
                    inside_circle = (dx*dx + dy*dy) < (30*30);

                    r = 8'h00; g = 8'h00; b = 8'hFF;

                    if (inside_circle) begin
								 case (ficha)
									  2'b01: begin r = 8'hFF; g = 8'h00; b = 8'h00; end
									  2'b10: begin r = 8'hFF; g = 8'hFF; b = 8'h00; end
									  default: begin r = 8'hFF; g = 8'hFF; b = 8'hFF; end
								 endcase
                    end
                end
					 
					 4'd7: begin
					 
					  if (mostrar_ganador_final) begin
        // Círculo al centro
        dx = x - 320;
        dy = y - 240;
        if ((dx*dx + dy*dy) < (50*50)) begin
            if (led_j1) begin
                r = 8'hFF; g = 8'h00; b = 8'h00; // rojo
            end else if (led_j2) begin
                r = 8'hFF; g = 8'hFF; b = 8'h00; // amarillo
            end
        end
    end else begin
	 
			if (fila < 6 && col < 7)
			ficha = tablero[fila][col];

	  dx = x_in_cell - (CELL_WIDTH / 2);
	  dy = y_in_cell - (CELL_HEIGHT / 2);
	  inside_circle = (dx*dx + dy*dy) < (30*30);

	  r = 8'h00; g = 8'h00; b = 8'hFF;

	  if (inside_circle) begin
			if (ganadoras[fila][col]) begin
				 r = 8'h00; g = 8'hFF; b = 8'h00;
			end else begin
				 case (ficha)
					  2'b01: begin r = 8'hFF; g = 8'h00; b = 8'h00; end
					  2'b10: begin r = 8'hFF; g = 8'hFF; b = 8'h00; end
					  default: begin r = 8'hFF; g = 8'hFF; b = 8'hFF; end
				 endcase
			end
	  end


end
				 
					 
                end
					 
                4'd8: begin
					 
                end

                default: begin
                    if (fila < 6 && col < 7)
                        ficha = tablero[fila][col];

                    dx = x_in_cell - (CELL_WIDTH / 2);
                    dy = y_in_cell - (CELL_HEIGHT / 2);
                    inside_circle = (dx*dx + dy*dy) < (30*30);

                    r = 8'h00; g = 8'h00; b = 8'hFF;

                    if (inside_circle) begin
                        if (ganadoras[fila][col]) begin
                            r = 8'h00; g = 8'hFF; b = 8'h00;
                        end else begin
                            case (ficha)
                                2'b01: begin r = 8'hFF; g = 8'h00; b = 8'h00; end
                                2'b10: begin r = 8'hFF; g = 8'hFF; b = 8'h00; end
                                default: begin r = 8'hFF; g = 8'hFF; b = 8'hFF; end
                            endcase
                        end
                    end
                end
            endcase
        end
    end

endmodule