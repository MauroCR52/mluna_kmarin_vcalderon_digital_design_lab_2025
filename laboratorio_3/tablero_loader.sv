module tablero_loader(
    input  logic clk,
    input  logic reset,
    input  logic load_switch,  // Switch externo (activo al subir)
    output logic [1:0] tablero [5:0][6:0]
);

    logic prev_switch;

    always_ff @(posedge clk) begin
        if (reset) begin
            // Vaciar tablero
            for (int i = 0; i < 6; i++) begin
                for (int j = 0; j < 7; j++) begin
                    tablero[i][j] <= 2'b00;
                end
            end
            prev_switch <= 1'b0;
        end else begin
            // Detectar flanco de subida del switch
            if (load_switch && !prev_switch) begin
                int counter = 0;
                for (int i = 0; i < 6; i++) begin
                    for (int j = 0; j < 7; j++) begin
                        if (counter < 10) begin
                            tablero[i][j] <= (counter % 2 == 0) ? 2'b01 : 2'b10;
                            counter++;
                        end else begin
                            tablero[i][j] <= 2'b00;
                        end
                    end
                end
            end
            prev_switch <= load_switch;
        end
    end

endmodule
