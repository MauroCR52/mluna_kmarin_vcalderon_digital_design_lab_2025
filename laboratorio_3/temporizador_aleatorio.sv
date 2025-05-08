module temporizador_aleatorio #(
    parameter CLK_FREQ_HZ = 25_175_000,
    parameter SEGUNDOS_MAX = 10
)(
    input  logic clk,
    input  logic reset,
    input  logic enable,                   // Se activa en estado MOVER_FICHA
    input  logic movimiento_hecho,         // Se pone en 1 cuando se inserta ficha
    input  logic [1:0] tablero [5:0][6:0], // Para verificar columnas válidas
    output logic [6:0] pulsos_random,      // Pulso en una columna aleatoria
    output logic [7:0] contador            // Segundos restantes (0-10)
);

    // Contador de ciclos de 1 segundo (basado en frecuencia)
    logic [$clog2(CLK_FREQ_HZ)-1:0] seg_counter = 0;
    logic [3:0] segundos_restantes = SEGUNDOS_MAX;

    logic activo = 0;
    logic [2:0] lfsr = 3'b001;
    logic [2:0] col_random;

    function logic columna_valida(input [2:0] col);
        columna_valida = (tablero[0][col] == 2'b00);
    endfunction

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            seg_counter <= 0;
            segundos_restantes <= SEGUNDOS_MAX;
            pulsos_random <= 7'b0;
            activo <= 0;
        end else begin
            if (enable) begin
                if (!activo) begin
                    activo <= 1;
                    segundos_restantes <= SEGUNDOS_MAX;
                    seg_counter <= 0;
                end

                if (movimiento_hecho) begin
                    segundos_restantes <= SEGUNDOS_MAX;
                    seg_counter <= 0;
                    pulsos_random <= 7'b0;
                    activo <= 0;
                end else begin
                    if (seg_counter >= CLK_FREQ_HZ) begin
                        seg_counter <= 0;
                        if (segundos_restantes > 0) begin
                            segundos_restantes <= segundos_restantes - 1;
                        end else begin
                            // Generar pulso aleatorio
                            for (int i = 0; i < 7; i++) begin
                                lfsr <= {lfsr[1:0], lfsr[2] ^ lfsr[0]};
                                col_random = lfsr % 7;
                                if (columna_valida(col_random)) begin
                                    pulsos_random <= 7'b0000001 << col_random;
                                    break;
                                end
                            end
                            segundos_restantes <= SEGUNDOS_MAX;
                            activo <= 0;
                        end
                    end else begin
                        seg_counter <= seg_counter + 1;
                        pulsos_random <= 7'b0;
                    end
                end
            end else begin
                seg_counter <= 0;
                segundos_restantes <= SEGUNDOS_MAX;
                pulsos_random <= 7'b0;
                activo <= 0;
            end
        end
    end

    assign contador = segundos_restantes;

endmodule
