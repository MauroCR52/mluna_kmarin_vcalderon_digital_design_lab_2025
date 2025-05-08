module insertar_ficha (
    input  logic clk,
    input  logic reset,
    input  logic [6:0] pulses,                // Pulsos de flanco de bajada de switches
    input  logic [1:0] jugador,               // 2'b01 para jugador 1
    input  logic [1:0] tablero_in [5:0][6:0], // Tablero actual
    output logic [1:0] tablero_out [5:0][6:0] // Tablero actualizado
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= 2'b00;

        end else begin
            // Copiar estado actual
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= tablero_in[i][j];

				// Insertar ficha
				for (int col = 0; col < 7; col++) begin
					 if (pulses[col]) begin
						  logic done = 0;
						  for (int row = 5; row >= 0 && !done; row--) begin
								if (tablero_in[row][col] == 2'b00) begin
									 tablero_out[row][col] <= jugador;
									 done = 1; // marcar que ya insertó ficha
								end
						  end
					 end
				end
        end
    end
endmodule
