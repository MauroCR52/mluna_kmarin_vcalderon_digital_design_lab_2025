module ganador_check (
    input  logic clk,
    input  logic reset,
    input  logic [1:0] tablero [5:0][6:0],
    output logic led_j1,
    output logic led_j2,
    output logic ganadoras [5:0][6:0]
);

    logic [1:0] f;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            led_j1 <= 0;
            led_j2 <= 0;
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    ganadoras[i][j] <= 0;
        end else begin
            // Reiniciar en cada ciclo
            led_j1 <= 0;
            led_j2 <= 0;
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    ganadoras[i][j] <= 0;

            // Verificar condiciones de victoria
            for (int i = 0; i < 6; i++) begin
                for (int j = 0; j < 7; j++) begin
                    f = tablero[i][j];

                    if (f != 2'b00) begin
                        // Horizontal →
                        if (j <= 3) begin
                            if (f == tablero[i][j+1] &&
                                f == tablero[i][j+2] &&
                                f == tablero[i][j+3]) begin
                                ganadoras[i][j]     <= 1;
                                ganadoras[i][j+1]   <= 1;
                                ganadoras[i][j+2]   <= 1;
                                ganadoras[i][j+3]   <= 1;
                                if (f == 2'b01) led_j1 <= 1;
                                else if (f == 2'b10) led_j2 <= 1;
                            end
                        end

                        // Vertical ↓
                        if (i <= 2) begin
                            if (f == tablero[i+1][j] &&
                                f == tablero[i+2][j] &&
                                f == tablero[i+3][j]) begin
                                ganadoras[i][j]     <= 1;
                                ganadoras[i+1][j]   <= 1;
                                ganadoras[i+2][j]   <= 1;
                                ganadoras[i+3][j]   <= 1;
                                if (f == 2'b01) led_j1 <= 1;
                                else if (f == 2'b10) led_j2 <= 1;
                            end
                        end

                        // Diagonal ↘
                        if (i <= 2 && j <= 3) begin
                            if (f == tablero[i+1][j+1] &&
                                f == tablero[i+2][j+2] &&
                                f == tablero[i+3][j+3]) begin
                                ganadoras[i][j]     <= 1;
                                ganadoras[i+1][j+1] <= 1;
                                ganadoras[i+2][j+2] <= 1;
                                ganadoras[i+3][j+3] <= 1;
                                if (f == 2'b01) led_j1 <= 1;
                                else if (f == 2'b10) led_j2 <= 1;
                            end
                        end

                        // Diagonal ↗
                        if (i <= 2 && j >= 3) begin
                            if (f == tablero[i+1][j-1] &&
                                f == tablero[i+2][j-2] &&
                                f == tablero[i+3][j-3]) begin
                                ganadoras[i][j]     <= 1;
                                ganadoras[i+1][j-1] <= 1;
                                ganadoras[i+2][j-2] <= 1;
                                ganadoras[i+3][j-3] <= 1;
                                if (f == 2'b01) led_j1 <= 1;
                                else if (f == 2'b10) led_j2 <= 1;
                            end
                        end
                    end
                end
            end
        end
    end

endmodule
