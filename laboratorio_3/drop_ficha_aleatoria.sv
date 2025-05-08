module drop_ficha_aleatoria(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [1:0] jugador,
    input  logic [1:0] tablero_in [5:0][6:0],
    output logic inserted,
    output logic [1:0] tablero_out [5:0][6:0]
);
    typedef enum logic [1:0] {IDLE, BUSCANDO, INSERTANDO} state_t;
    state_t state;

    logic [2:0] col;
    logic [2:0] random_col;
    logic [3:0] intento;
    logic inserted_flag;
    logic success;

    // LFSR de 3 bits para valores 0-6
    logic [2:0] lfsr;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 3'b101;
        end else begin
            lfsr <= {lfsr[1] ^ lfsr[0], lfsr[2:1]};
        end
    end

    assign random_col = (lfsr > 3'd6) ? lfsr % 7 : lfsr;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            inserted <= 0;
            inserted_flag <= 0;
            intento <= 0;

            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= 2'b00;
        end else begin
            // Siempre sincronizamos la copia base del tablero
            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= tablero_in[i][j];

            case (state)
                IDLE: begin
                    inserted <= 0;
                    inserted_flag <= 0;
                    intento <= 0;
                    if (enable && !inserted_flag) begin
                        state <= BUSCANDO;
                    end
                end

                BUSCANDO: begin
                    col <= random_col;
                    state <= INSERTANDO;
                end

                INSERTANDO: begin
                    inserted <= 0;
                    success = 0;

                    for (int row = 5; row >= 0; row--) begin
                        if (tablero_in[row][col] == 2'b00 && !success) begin
                            tablero_out[row][col] <= jugador;
                            success = 1;
                        end
                    end

                    if (success) begin
                        inserted <= 1;
                        inserted_flag <= 1;
                        state <= IDLE;
                    end else begin
                        intento <= intento + 1;
                        if (intento < 10)
                            state <= BUSCANDO;
                        else begin
                            inserted <= 0;
                            inserted_flag <= 1;  // Aun así finalizar para no atascarse
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
