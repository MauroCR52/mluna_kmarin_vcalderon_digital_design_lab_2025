module flanco_bajada (
    input  logic clk,
    input  logic reset,
    input  logic btn_in,      // Activo en bajo
    output logic pulse
);
    logic btn_sync_0, btn_sync_1;

    // Sincronización y almacenamiento del valor anterior
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 1'b1;  // botón inactivo
            btn_sync_1 <= 1'b1;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end
    end

    // Detectar flanco de bajada: 1 → 0
    assign pulse = btn_sync_1 & ~btn_sync_0;
endmodule
