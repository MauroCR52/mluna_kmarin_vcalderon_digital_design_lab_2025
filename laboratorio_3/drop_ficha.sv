module drop_ficha #(
    parameter WAIT_CYCLES = 12_500_000  // 0.5 segundos a 25 MHz
)(
    input  logic clk,
    input  logic reset,
    input  logic [6:0] pulses,
    input  logic [1:0] jugador,
    input  logic juego_terminado,                    // ← nuevo
    output logic inserted,
    output logic [1:0] tablero_out [5:0][6:0]
);

    typedef enum logic [1:0] {IDLE, INSERTANDO, COOLDOWN} state_t;
    state_t state = IDLE;

    logic [6:0] pulse_buffer = 0;
    logic [2:0] col_insertar = 0;
    logic [23:0] cooldown_counter = 0;
    logic pulse_consumido = 0;
    logic inserted_flag = 0;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            pulse_buffer <= 0;
            cooldown_counter <= 0;
            pulse_consumido <= 0;
            inserted <= 0;
            inserted_flag <= 0;

            for (int i = 0; i < 6; i++)
                for (int j = 0; j < 7; j++)
                    tablero_out[i][j] <= 2'b00;

        end else begin
            inserted <= inserted_flag;
            inserted_flag <= 0;

            // Si ya hay ganador, bloquear cualquier acción
            if (juego_terminado) begin
                state <= IDLE;
                pulse_buffer <= 0;
                inserted_flag <= 0;
                cooldown_counter <= 0;
                pulse_consumido <= 0;
            end else begin
                if (state == IDLE)
                    pulse_buffer <= pulse_buffer | pulses;

                case (state)
                    IDLE: begin
                        pulse_consumido <= 0;
                        for (int col = 0; col < 7; col++) begin
                            if (pulse_buffer[col]) begin
                                col_insertar <= col;
                                state <= INSERTANDO;
                                break;
                            end
                        end
                    end

                    INSERTANDO: begin
                        if (!pulse_consumido) begin
                            for (int row = 5; row >= 0; row--) begin
                                if (tablero_out[row][col_insertar] == 2'b00) begin
                                    tablero_out[row][col_insertar] <= jugador;
                                    pulse_buffer[col_insertar] <= 1'b0;
                                    pulse_consumido <= 1;
                                    inserted_flag <= 1;
                                    cooldown_counter <= 0;
                                    state <= COOLDOWN;
                                    break;
                                end
                            end

                            if (tablero_out[0][col_insertar] != 2'b00) begin
                                pulse_buffer[col_insertar] <= 1'b0;
                                state <= IDLE;
                            end
                        end
                    end

                    COOLDOWN: begin
                        if (cooldown_counter >= WAIT_CYCLES) begin
                            cooldown_counter <= 0;
                            state <= IDLE;
                        end else begin
                            cooldown_counter <= cooldown_counter + 1;
                        end
                    end
                endcase
            end
        end
    end
endmodule