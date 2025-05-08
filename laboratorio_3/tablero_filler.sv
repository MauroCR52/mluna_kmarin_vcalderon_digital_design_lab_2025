module tablero_filler (
    input  logic clk,
    input  logic reset,
    output logic [1:0] tablero [5:0][6:0]
);

    // Posición actual de llenado
    logic [5:0] index;
    logic [2:0] row, col;

    assign row = index % 6;
    assign col = index / 6;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 0;

            // Vaciar tablero
            for (int i = 0; i < 6; i++) begin
                for (int j = 0; j < 7; j++) begin
                    tablero[i][j] <= 2'b00;
                end
            end

        end else begin
            if (index < 42) begin
                tablero[row][col] <= (index % 2 == 0) ? 2'b01 : 2'b10; // Alternar color
                index <= index + 1;
            end
        end
    end
endmodule
