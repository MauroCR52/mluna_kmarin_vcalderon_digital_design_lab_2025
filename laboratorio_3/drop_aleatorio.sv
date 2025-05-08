module drop_aleatorio(
    input  logic clk,
    input  logic reset,
    input  logic enable,                       // Activar cuando FSM entre en MOVER_ALEATORIO
    input  logic [1:0] jugador,                // Jugador actual (2'b01 o 2'b10)
    input  logic [1:0] tablero_in [5:0][6:0],  // Estado actual del tablero
    output logic [1:0] tablero_out [5:0][6:0], // Tablero actualizado con ficha aleatoria
    output logic done                          // Señal que indica que ya se insertó la ficha
);

    typedef enum logic [1:0] {IDLE, BUSCANDO, INSERTANDO} state_t;
    state_t estado = IDLE;

    logic [2:0] col_actual = 0;
    logic found = 0;

    // Copia inicial del tablero
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            estado <= IDLE;
            col_actual <= 0;
            done <= 0;
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= tablero_in[i][j];
        end else begin
            done <= 0;
            case (estado)
                IDLE: begin
                    if (enable)
                        estado <= BUSCANDO;
                end

                BUSCANDO: begin
                    // Buscar columna aleatoria libre
                    col_actual <= (col_actual + 3) % 7; // simple pseudo-aleatoriedad determinística

                    if (tablero_out[0][col_actual] == 2'b00) begin
                        estado <= INSERTANDO;
                    end
                end

                INSERTANDO: begin
                    for (int row = 5; row >= 0; row--) begin
                        if (tablero_out[row][col_actual] == 2'b00) begin
                            tablero_out[row][col_actual] <= jugador;
                            done <= 1;
                            estado <= IDLE;
                            break;
                        end
                    end
                end
            endcase
        end
    end

endmodule
