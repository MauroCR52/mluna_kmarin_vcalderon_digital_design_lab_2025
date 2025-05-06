module vga_test(
    input  logic clk,
    input  logic reset,
    input  logic button,
    input  logic [6:0] botones,
    input  logic [6:0] switches,
    output logic vgaclk,
    output logic hsync, vsync,
    output logic sync_b, blank_b,
    output logic [7:0] r, g, b,
	 output logic [6:0] display0, display1,
    output logic led_j1,
    output logic led_j2,
    output logic color
);

    logic [9:0] x = 0;
    logic [9:0] y = 0;
    logic [1:0] tablero [5:0][6:0];
    logic [1:0] turno_actual;
    logic [3:0] state;
    logic ficha_insertada;
    logic juego_terminado;
    logic ganadoras [5:0][6:0];
    logic habilitar_drop;
	 logic reset_interno;
	 logic reset_total;
	 logic mostrar_ganador_final;



    assign juego_terminado = led_j1 | led_j2;

    // Señales auxiliares
    logic tick;
    logic pulse;
    logic [6:0] SWpulses, BTNpulses;
	 logic [6:0] pulsos_random;
	 logic [7:0] contador_segundos;
	 
	 
    pll25 vgapll(
        .refclk(clk), 
        .rst(1'b0), 
        .outclk_0(vgaclk), 
        .locked()
    );
	 
	     // FSM del juego Connect 4
    fsm_conecta4 fsm_game(
        .clk(vgaclk),
        .reset(reset),
        .button_start(pulse),          // ← nuevo
        .ficha_insertada(ficha_insertada),
        .juego_terminado(juego_terminado),
        .btn_jugador1(BTNpulses[0]),
        .btn_jugador2(BTNpulses[1]),
        .estado_actual(state),
        .turno_actual(turno_actual),
        .habilitar_drop(habilitar_drop)
    );
	 
	 	 
	 assign reset_interno = (state == 4'd8); // Estado RESET en FSM
	 assign reset_total = reset | reset_interno;

    vga_controller vgaCont(
        .vgaclk(vgaclk), 
        .hsync(hsync), 
        .vsync(vsync), 
        .sync_b(sync_b), 
        .blank_b(blank_b), 
        .x(x), 
        .y(y)
    );

    flanco_subida_array #(.N(7)) detectores_subida (
        .clk(vgaclk),
        .reset(reset_total),
        .sw_in(switches),
        .pulse(SWpulses)
    );

    flanco_bajada_array #(.N(7)) detectores_bajada (
        .clk(vgaclk),
        .reset(reset_total),
        .botones(botones),
        .pulses(BTNpulses)
    );

    flanco_bajada btn_flanco (
        .clk(vgaclk),
        .reset(reset_total),
        .btn_in(button),
        .pulse(pulse)
    );



    // Instancia del temporizador
	temporizador_aleatorio auto_drop (
		 .clk(vgaclk),
		 .reset(reset_total),
		 .enable(habilitar_drop),
		 .movimiento_hecho(ficha_insertada),
		 .tablero(tablero),
		 .pulsos_random(pulsos_random),
		 .contador(contador_segundos)
	);


	// Pulsos combinados (jugador o auto)
	logic [6:0] pulses_final;
	assign pulses_final = habilitar_drop ? 
								 (SWpulses | pulsos_random) : 7'b0;
								 
	display_7seg_doble display_driver (
    .contador(contador_segundos),
    .display1(display1),
    .display0(display0)
	);


	drop_ficha drop_inst (
		 .clk(vgaclk),
		 .reset(reset_total),
		 .pulses(pulses_final),
		 .jugador(turno_actual),
		 .inserted(ficha_insertada),
		 .juego_terminado(juego_terminado),
		 .tablero_out(tablero)
	);

    ganador_check check_winner (
        .clk(vgaclk),
        .reset(reset_total),
        .tablero(tablero),
        .led_j1(led_j1),
        .led_j2(led_j2),
        .ganadoras(ganadoras)
    );
	 
	 temporizador_ganador ganador_delay (
    .clk(vgaclk),
    .reset(reset_total),
    .enable(state == 4'd7),
    .done(mostrar_ganador_final)
);


video_gen videoInst(
    .x(x),
    .y(y),
    .blank_b(blank_b),
    .tablero(tablero),
    .ganadoras(ganadoras),
    .state_in(state),
    .color_flag(1'b0),
    .mostrar_ganador_final(mostrar_ganador_final),  // ← NUEVO
    .led_j1(led_j1),                                // ← NUEVO
    .led_j2(led_j2),                                // ← NUEVO
    .r(r),
    .g(g),
    .b(b)
);




endmodule