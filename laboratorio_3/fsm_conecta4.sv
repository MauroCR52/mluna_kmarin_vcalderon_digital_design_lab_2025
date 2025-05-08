module fsm_conecta4(
    input  logic clk,
    input  logic reset,
    input  logic ficha_insertada,
    input  logic juego_terminado,
    input  logic btn_jugador1,  // flanco bajo
    input  logic btn_jugador2,  // flanco bajo
    input  logic button_start,     // ← botón para salir de INICIO

    output logic [3:0] estado_actual,
    output logic [1:0] turno_actual,
    output logic habilitar_drop
);

    typedef enum logic [3:0] {
        INICIO            = 4'd0,
        ELEGIR_JUGADOR    = 4'd1,
        TURNO_FPGA        = 4'd2,
        TURNO_ARDUINO     = 4'd3,
        MOVER_FICHA       = 4'd4,
        ACTUALIZAR_TABLERO= 4'd5,
        VERIFICAR_GANE    = 4'd6,
        MOSTRAR_GANADOR   = 4'd7,
        RESET             = 4'd8
    } estado_t;

    estado_t estado, siguiente;
    logic [1:0] prox_turno;

    // Registro de estado y turno
		always_ff @(posedge clk or posedge reset) begin
			 if (reset) begin
				  estado <= INICIO;
				  turno_actual <= 2'b00; // valor neutro
			 end else begin
				  estado <= siguiente;

				  // ← NUEVO: si el usuario eligió el jugador, guardar ese turno
				  if (estado == ELEGIR_JUGADOR && (btn_jugador1 || btn_jugador2))
						turno_actual <= prox_turno;

				  if (estado == VERIFICAR_GANE && !juego_terminado)
						turno_actual <= prox_turno;
			 end
		end

    always_comb begin
        siguiente = estado;
        habilitar_drop = 0;
        prox_turno = turno_actual;

        case (estado)
				INICIO: begin
					 if (button_start) begin
						  siguiente = ELEGIR_JUGADOR;
					 end
				end

            ELEGIR_JUGADOR: begin
                if (btn_jugador1) begin
                    prox_turno = 2'b01;
                    siguiente = TURNO_FPGA;
                end else if (btn_jugador2) begin
                    prox_turno = 2'b10;
                    siguiente = TURNO_ARDUINO;
                end
            end

            TURNO_FPGA, TURNO_ARDUINO: begin
                siguiente = MOVER_FICHA;
            end

            MOVER_FICHA: begin
                habilitar_drop = 1;
                if (ficha_insertada)
                    siguiente = ACTUALIZAR_TABLERO;
            end

            ACTUALIZAR_TABLERO: begin
                siguiente = VERIFICAR_GANE;
            end

            VERIFICAR_GANE: begin
                if (juego_terminado)
                    siguiente = MOSTRAR_GANADOR;
                else begin
                    siguiente = (turno_actual == 2'b01) ? TURNO_ARDUINO : TURNO_FPGA;
                    prox_turno = (turno_actual == 2'b01) ? 2'b10 : 2'b01;
                end
            end

            MOSTRAR_GANADOR: begin
					 if (button_start) begin
						  siguiente = RESET;
					 end

            end

            RESET: begin
                siguiente = INICIO;
            end
        endcase
    end

    assign estado_actual = estado;

endmodule
